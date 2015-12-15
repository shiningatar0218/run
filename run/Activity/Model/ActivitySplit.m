//
//  ActivitySplit.m
//  run1.2
//
//  Created by runner on 15/1/28.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "ActivitySplit.h"
#import "NSDictionaryAdditions.h"

@implementation ActivitySplit

- (id)initWithJsonParma:(NSDictionary *)dic {
    
    self = [super init];
    if (self) {
        self.activity_id = [dic getLongLongValueValueForKey:@"activity_id" defaultValue:1];
        self.number = [dic getFloatValueForKey:@"number" defaultValue:0];
        self.value = [dic getFloatValueForKey:@"value" defaultValue:0];
    }
    
    return self;
}


@end
