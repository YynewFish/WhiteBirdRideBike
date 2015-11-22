//
//  RideRecord.h
//  WhiteBirdRideBike
//
//  Created by Xu Menghua on 15/11/22.
//  Copyright © 2015年 Xu Menghua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RideRecord : NSObject

@property (nonatomic, assign) int time;
@property (nonatomic, assign) double distance;
@property (nonatomic, assign) double averageSpeed;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *overTime;
@property (nonatomic, strong) NSMutableArray *locationsArray;

@end
