//
//  TaskData.m
//  run
//
//  Created by 孙 哲恒 on 14/12/11.
//  Copyright (c) 2014年 abc. All rights reserved.
//

#import "Task.h"
#import "NSDictionaryAdditions.h"

@implementation Task

-(Task *) init {
    
    return self;
}

- (Task*)initWithJsonDictionary:(NSDictionary*)dic {
    
    if (self = [super init]) {
        _task_id = [dic getLongLongValueValueForKey:@"task_id" defaultValue:-1];
        _user_id_creator = [dic getLongLongValueValueForKey:@"user_id_creator" defaultValue:-1];
        _name = [dic getStringValueForKey:@"name" defaultValue:@""];
        _task_description = [dic getStringValueForKey:@"description" defaultValue:@""];
        _limit_number = [dic getIntValueForKey:@"limit_number" defaultValue:0];
        //_begin_time = [dic getTimeValueForKey:@"begin_time" defaultValue:@"2014-12-12"];
        //_end_time = [dic getTimeValueForKey:@"end_time" defaultValue:@""];
        
        _begin_time = [dic getStringValueForKey:@"begin_time" defaultValue:@""];
        _end_time = [dic getStringValueForKey:@"end_time" defaultValue:@""];
        
        _award_name =[dic getStringValueForKey:@"award_name" defaultValue:@""];
        _award_pic_1 =[dic getStringValueForKey:@"award_pic_1" defaultValue:@""];
        _award_pic_2 =[dic getStringValueForKey:@"award_pic_2" defaultValue:@""];
        _integration_rule_sign = [dic getFloatValueForKey:@"integration_rule_sign" defaultValue:0];
        _integration_rule_distance= [dic getFloatValueForKey:@"integration_rule_distance" defaultValue:0];
        _integration_rule_pace = [dic getFloatValueForKey:@"integration_rule_pace" defaultValue:0];
        _publish_type = [dic getIntValueForKey:@"publish_type" defaultValue:0];
        _publish_value =[dic getStringValueForKey:@"publish_value" defaultValue:@""];
        _target_distance = [dic getFloatValueForKey:@"target_distance" defaultValue:0];
    }
    return self;
}

+ (Task*)taskWithJsonDictionary:(NSDictionary*)dic {
    return [[Task alloc] initWithJsonDictionary:dic];
}

@end
