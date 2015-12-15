//
//  Task.h
//  run
//
//  Created by 孙 哲恒 on 14/12/11.
//  Copyright (c) 2014年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskMember.h"

// 任务的数据
@interface Task : NSObject
@property (nonatomic, assign) long long task_id;
@property (nonatomic, assign) long long user_id_creator;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *task_description;
@property (nonatomic, assign) int limit_number;
@property (nonatomic, retain) NSString *begin_time;
@property (nonatomic, retain) NSString *end_time;
@property (nonatomic, retain) NSString *award_name;
@property (nonatomic, retain) NSString *award_pic_1;
@property (nonatomic, retain) NSString *award_pic_2;
@property (nonatomic, assign) float integration_rule_sign;
@property (nonatomic, assign) float integration_rule_distance;
@property (nonatomic, assign) float integration_rule_pace;
@property (nonatomic, assign) int publish_type;
@property (nonatomic, retain) NSString *publish_value;
@property (nonatomic, assign) float target_distance;
@property (nonatomic, retain) NSMutableArray *userArray;

-(Task *) init;
- (Task*)initWithJsonDictionary:(NSDictionary*)dic;
+ (Task*)taskWithJsonDictionary:(NSDictionary*)dic;
@end

