//
//  RideViewController.h
//  WhiteBirdRideBike
//
//  Created by Xu Menghua on 15/11/20.
//  Copyright © 2015年 Xu Menghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RideViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *locationsArray;

@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageSpeedLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *gpsStatusLabel;

- (IBAction)start:(UIButton *)sender;
- (IBAction)toMap:(UISwipeGestureRecognizer *)sender;


@end
