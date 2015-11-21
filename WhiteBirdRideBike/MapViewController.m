//
//  MapViewController.m
//  WhiteBirdRideBike
//
//  Created by Xu Menghua on 15/11/21.
//  Copyright © 2015年 Xu Menghua. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "RideViewController.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKPolyline *routeLine;
@property (nonatomic, strong) MKPolylineView *routeLineView;
@property (nonatomic, assign) MKMapRect routeRect;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([CLLocationManager locationServicesEnabled]) {
        self.mapView.mapType = MKMapTypeStandard;
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 5.0f;
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
        self.locationManager.pausesLocationUpdatesAutomatically = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [self.locationManager startUpdatingLocation];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 事件处理

- (IBAction)quit:(UIBarButtonItem *)sender {
    UITabBarController *tabBarController = (UITabBarController *)self.presentingViewController;
    UINavigationController *navgationController = tabBarController.viewControllers[0];
    RideViewController *presentingVC = (RideViewController *)navgationController.viewControllers[0];
    presentingVC.locationsArray = self.locationsArray;
    //NSLog(@"%@", [presentingVC class]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 内部方法

-(void) loadRoute
{
    //NSLog(@"loadRoute");
    MKMapPoint *pointArr = malloc(sizeof(CLLocationCoordinate2D) * self.locationsArray.count);
    
    for(int i = 0; i < self.locationsArray.count; i++)
    {
        CLLocation *location = [self.locationsArray objectAtIndex:i];
        CLLocationCoordinate2D coordinate = location.coordinate;
        MKMapPoint point = MKMapPointForCoordinate(coordinate);
        pointArr[i] = point;
    }
    
    self.routeLine = [MKPolyline polylineWithPoints:pointArr count:self.locationsArray.count];
    
    free(pointArr); 
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    //NSLog(@"didUpdateLocations");
    if (self.flag == 2) {
        CLLocation *currentLocation = [locations lastObject];
        [self.locationsArray addObject:currentLocation];
        
        if (self.routeLine != nil) {
            self.routeLine = nil;
            self.routeLineView = nil;
            [self.mapView removeOverlay:self.routeLine];
            //NSLog(@"removeOverlay");
        }
        
        // create the overlay
        [self loadRoute];
        
        if (self.routeLine != nil) {
            [self.mapView addOverlay:self.routeLine];
            //NSLog(@"addOverlay");
        }
    }
}

#pragma mark - MKMapViewDelegate

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay {
    //NSLog(@"viewForOverlay");
    MKOverlayView *overlayView = nil;
    
    if(overlay == self.routeLine) {
        if(self.routeLineView == nil) {
            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
            self.routeLineView.fillColor = [UIColor blueColor];
            self.routeLineView.strokeColor = [UIColor blueColor];
            self.routeLineView.lineWidth = 5;
        }
        
        overlayView = self.routeLineView;
    }
    
    return overlayView;
}

@end
