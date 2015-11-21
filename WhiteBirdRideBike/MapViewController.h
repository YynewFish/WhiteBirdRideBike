//
//  MapViewController.h
//  WhiteBirdRideBike
//
//  Created by Xu Menghua on 15/11/21.
//  Copyright © 2015年 Xu Menghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController

- (IBAction)quit:(UIBarButtonItem *)sender;

@property (nonatomic, strong) NSMutableArray *locationsArray;
@property (nonatomic, assign) int flag;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
