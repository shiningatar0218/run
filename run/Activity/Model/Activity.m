//
//  Activity.m
//  run
//
//  Created by 孙 哲恒 on 14/12/9.
//  Copyright (c) 2014年 abc. All rights reserved.
//

#import "Activity.h"
#import "DataModel.h"
#import "MagicalRecord.h"
#import "CoreData+MagicalRecord.h"
#import "NSNumber+NumberWithString.h"

/// 训练部分的数据
@implementation Activity

@dynamic session_id;
@dynamic user_id_creator;
@dynamic activity_description;
@dynamic activity_id;
@dynamic energy;
@dynamic file_url;
@dynamic name;
@dynamic pace;
@dynamic sport;
@dynamic tag_id_s;
@dynamic total_distance;
@dynamic total_time;
@dynamic user_id;
@dynamic update_time;
@dynamic create_time;
@dynamic splits;


+ (Activity *)activityWithJsonDictionary:(NSDictionary *)dic {
    Activity *activity = [Activity MR_createEntity];
    
    NSArray *number_key = @[@"user_id_creator",@"activity_id",@"energy",@"pace",@"sport",@"user_id",@"total_distance",@"total_time"];
    
    for (NSString *key in dic.allKeys) {
        
        if ([key isEqualToString:@"description"]) {
            [activity setValue:[dic getStringValueForKey:key defaultValue:@""] forKey:@"activity_description"];
            continue;
        }else if ([number_key containsObject:key]) {
            [activity setValue:[NSNumber numberWithString:dic[key]] forKey:key];
            continue;
        }
        
        [activity setValue:[dic getStringValueForKey:key defaultValue:@""] forKey:key];
    }
    
    return activity;
}



@end
