//
//  UserStatistics.h
//  run1.2
//
//  Created by runner on 15/1/26.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserStatistics : NSObject

@property (nonatomic, assign) int week_activity_count;
@property (nonatomic, assign) float week_activity_distance;
@property (nonatomic, strong) NSString *week_activity_time;
@property (nonatomic, assign) float year_activity_distance;
@property (nonatomic, strong) NSString *year_activity_time;
@property (nonatomic, assign) float year_average_height;
@property (nonatomic, assign) int year_activity_count;
@property (nonatomic, assign) float year_average_pace;
@property (nonatomic, assign) float total_distance;
@end
