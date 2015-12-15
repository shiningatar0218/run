//
//  FileData.m
//  run
//
//  Created by runner on 15/3/26.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "FileData.h"
#import "NSDictionaryAdditions.h"

@implementation FileData

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (id)FileDataWithModel:(NSDictionary *)dic {
    FileData *model = [[FileData alloc] init];
    model.longitude = [dic getFloatValueForKey:@"long" defaultValue:0];
    model.alt = [dic getFloatValueForKey:@"alt" defaultValue:0];
    model.cal = [dic getFloatValueForKey:@"cal" defaultValue:0];
    model.dis = [dic getFloatValueForKey:@"dis" defaultValue:0];
    model.time = [dic getFloatValueForKey:@"time" defaultValue:0];
    model.topredis = [dic getFloatValueForKey:@"topredis" defaultValue:0];
    model.topretime = [dic getFloatValueForKey:@"topretime" defaultValue:0];
    model.lat = [dic getFloatValueForKey:@"lat" defaultValue:0];
    model.pace = model.topredis*1000/model.topretime;
    
    return model;
}

@end
