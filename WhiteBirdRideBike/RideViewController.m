//
//  RideViewController.m
//  WhiteBirdRideBike
//
//  Created by Xu Menghua on 15/11/20.
//  Copyright © 2015年 Xu Menghua. All rights reserved.
//

#import "RideViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MapViewController.h"

@interface RideViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) int time;
@property (strong) NSTimer *timer;
@property (nonatomic, strong) CLLocation *oldLocation;
@property (nonatomic, assign) double distance;
@property (nonatomic, assign) double averageSpeed;
@property (strong) NSTimer *tipLabelAnimationTimer;

@end

@implementation RideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 5.0f;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.pausesLocationUpdatesAutomatically = YES;
    
    self.locationsArray = [[NSMutableArray alloc] init];
    self.time = -1;
    self.distance = 0;
    self.averageSpeed = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [self.locationManager startUpdatingLocation];
    [self tipLabelAnimationStart];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"rideBiketoMap"]) {
        MapViewController *destinationVC = segue.destinationViewController;
        destinationVC.locationsArray = self.locationsArray;
        destinationVC.flag = self.startButton.tag;
    }
}

#pragma mark - 事件处理

- (IBAction)start:(UIButton *)sender {
    if (sender.tag == 1) {
        self.time = -1;
        self.distance = 0;
        self.averageSpeed = 0;
        [self timeStart];
        //NSLog(@"%d", sender.tag);
        [sender setTitle:@"停止" forState:UIControlStateNormal];
        [sender setBackgroundColor:[UIColor redColor]];
        [sender setTag:2];
    }else if (sender.tag == 2) {
        [self.timer invalidate];
        //NSLog(@"%d", sender.tag);
        self.speedLabel.text = @"0.00";
        [sender setTitle:@"开始" forState:UIControlStateNormal];
        [sender setBackgroundColor:[UIColor colorWithRed:0 green:0.5 blue:1 alpha:1]];
        [sender setTag:1];
    }
}

- (IBAction)toMap:(UISwipeGestureRecognizer *)sender {
    [self performSegueWithIdentifier:@"rideBiketoMap" sender:nil];
}

#pragma mark - 内部方法
#pragma mark 计时器

- (void)timeStart{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
        _time = -1;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer fire];
}

- (void)updateTime {
    self.time++;
    int seconds = self.time % 60;
    int minutes = self.time / 60;
    int hours = self.time / 3600;
    if (hours < 10 || minutes < 10 || seconds < 10) {
        if (hours < 10 && minutes < 10 && seconds < 10) {
            self.timeLabel.text = [NSString stringWithFormat:@"0%d:0%d:0%d", hours, minutes, seconds];
            return;
        }
        if (hours < 10 || minutes < 10) {
            if (hours < 10 && minutes < 10) {
                self.timeLabel.text = [NSString stringWithFormat:@"0%d:0%d:%d", hours, minutes, seconds];
                return;
            }
            if (hours < 10) {
                self.timeLabel.text = [NSString stringWithFormat:@"0%d:%d:%d", hours, minutes, seconds];
                return;
            }
            if (minutes < 10) {
                self.timeLabel.text = [NSString stringWithFormat:@"%d:0%d:%d", hours, minutes, seconds];
                return;
            }
        }
        
        if (hours < 10 || seconds < 10) {
            if (hours < 10 && seconds < 10) {
                self.timeLabel.text = [NSString stringWithFormat:@"0%d:%d:0%d", hours, minutes, seconds];
                return;
            }
            if (hours < 10) {
                self.timeLabel.text = [NSString stringWithFormat:@"0%d:%d:%d", hours, minutes, seconds];
                return;
            }
            if (seconds < 10) {
                self.timeLabel.text = [NSString stringWithFormat:@"%d:%d:0%d", hours, minutes, seconds];
                return;
            }
        }
        
        if (seconds < 10 || minutes < 10) {
            if (seconds < 10 && minutes < 10) {
                self.timeLabel.text = [NSString stringWithFormat:@"%d:0%d:0%d", hours, minutes, seconds];
                return;
            }
            if (seconds < 10) {
                self.timeLabel.text = [NSString stringWithFormat:@"%d:%d:0%d", hours, minutes, seconds];
                return;
            }
            if (minutes < 10) {
                self.timeLabel.text = [NSString stringWithFormat:@"%d:0%d:%d", hours, minutes, seconds];
                return;
            }
        }
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%d:%d:%d", hours, minutes, seconds];
    //NSLog(@"%f", self.time);
}

#pragma mark 提示Label动画实现

- (void)tipLabelAnimationStart {
    if (_tipLabelAnimationTimer) {
        [_tipLabelAnimationTimer invalidate];
        _tipLabelAnimationTimer = nil;
    }
    
    _tipLabelAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(tipLabelAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_tipLabelAnimationTimer forMode:NSRunLoopCommonModes];
    [_tipLabelAnimationTimer fire];
    //NSLog(@"animationStart");
}

- (void)tipLabelAnimation {
    dispatch_async(dispatch_get_main_queue(), ^{
        static double flag = 0;
        static double red = 0.6;
        static double green = 0.6;
        static double blue = 0.6;
        if (red >= 1 && green >= 1 && blue >= 1) {
            flag = 1;
        }
        if (red <= 0 && green <= 0 && blue <= 0) {
            flag = 0;
        }
        if (flag == 0) {
            red += 0.02;
            green += 0.02;
            blue += 0.02;
            //NSLog(@"%f", red);
            [self.tipLabel setTextColor:[UIColor colorWithRed:red green:green blue:blue alpha:1.0]];
        }
        if (flag == 1) {
            red -= 0.02;
            green -= 0.02;
            blue -= 0.02;
            //NSLog(@"%f", red);
            [self.tipLabel setTextColor:[UIColor colorWithRed:red green:green blue:blue alpha:1.0]];
        }
    });
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if ([locations lastObject].horizontalAccuracy < 20) {
        self.gpsStatusLabel.text = @"GPS已准备好";
    } else {
        self.gpsStatusLabel.text = @"GPS未准备好";
    }
    
    if (self.startButton.tag == 2) {
        CLLocation *currentLocation = [locations lastObject];
        [self.locationsArray addObject:currentLocation];
        //double altitude = currentLocation.altitude;
        //double latitude = currentLocation.coordinate.latitude;
        //double longitude = currentLocation.coordinate.longitude;
        double speed = currentLocation.speed;
        double distance = [currentLocation distanceFromLocation:self.oldLocation];
        
        if (distance > 0) {
            self.distance += distance;
        }
        
        if (self.time > 5 && self.distance > 20) {
            self.averageSpeed = (self.distance / self.time);
        }
        
        if (speed >= 0) {
            self.speedLabel.text = [NSString stringWithFormat:@"%.2f", speed * 3.6];
            if (self.distance >= 0) {
                self.rangeLabel.text = [NSString stringWithFormat:@"%.2f", (self.distance / 1000)];
            }
            if (self.averageSpeed >= 0) {
                self.averageSpeedLabel.text = [NSString stringWithFormat:@"%.2f", self.averageSpeed * 3.6];
            }
        }
        
        self.oldLocation = [locations lastObject];
        
        //NSLog(@"altitude:%f\nlatitude:%f\nlongitude:%f\n", altitude, latitude, longitude);
        //NSLog(@"%@ %@", [locations lastObject], [locations firstObject]);
        //NSLog(@"%f", self.distance);
        //NSLog(@"%@", self.locationsArray);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //NSLog(@"%@", error);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
}

@end
