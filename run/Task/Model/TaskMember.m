//
//  TaskMember.m
//  run1.2
//
//  Created by runner on 15/1/19.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "TaskMember.h"
#import "NSDictionaryAdditions.h"

@implementation TaskMember


- (id)initWithJsonDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        _nick_name = [dic getStringValueForKey:@"nick_name" defaultValue:@"abc"];
        _task_id = [dic getLongLongValueValueForKey:@"task_id" defaultValue:0];
        _user_id = [dic getLongLongValueValueForKey:@"user_id" defaultValue:0];
        _pace = [dic getStringValueForKey:@"pace" defaultValue:@"3:25"];
        _distance = [dic getFloatValueForKey:@"distance" defaultValue:101];
        _image = [dic getUrlValueForKey:@"image" defaultValue:@""];
    }
    return self;
}

@end
