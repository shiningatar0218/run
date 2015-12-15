//
//  Activity.h
//  run
//
//  Created by 孙 哲恒 on 14/12/9.
//  Copyright (c) 2014年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef NS_ENUM(int, SportType) {
    run = 0,
    ride = 1
};

// 每次训练的数据，需要持续完善中
@interface Activity : NSManagedObject
@property (nonatomic, retain) NSString *session_id;
@property (nonatomic, retain) NSNumber *activity_id;
@property (nonatomic, retain) NSNumber *user_id;
@property (nonatomic, retain) NSNumber *user_id_creator;
@property (nonatomic, retain) NSString *activity_description;
@property (nonatomic, retain) NSNumber *sport; // 0: 跑步， 1:骑车
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *total_time;
@property (nonatomic, retain) NSNumber *total_distance;
@property (nonatomic, retain) NSString *tag_id_s;
@property (nonatomic, retain) NSNumber *pace;
@property (nonatomic, retain) NSString *file_url;//轨迹数据的文件，服务器不解析，透传
@property (nonatomic, retain) NSNumber *energy;//消耗的能量，单位：大卡
@property (nonatomic, retain) NSString *update_time;
@property (nonatomic, retain) NSString *create_time;
@property (nonatomic, retain) NSDictionary *splits;
//
+ (Activity *)activityWithJsonDictionary:(NSDictionary *)dic;

@end


