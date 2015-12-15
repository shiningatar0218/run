//
//  NSMutableArray+addOtherObject.m
//  run1.2
//
//  Created by runner on 15/1/12.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "NSMutableArray+addOtherObject.h"

@implementation NSMutableArray (addOtherObject)


- (void)addOtherObject:(id)object {
    if ([self containsObject:object]) {
        return;
    }
    
    [self addObject:object];
}

- (void)sortWeakArray {
    NSArray *weaks = @[@"每周一",@"每周二",@"每周三",@"每周四",@"每周五",@"每周六",@"每周日"];
    NSMutableArray *weakArray =[NSMutableArray arrayWithCapacity:0];
    for (NSString *weak in weaks) {
        for (NSString *string in self) {
            if ([weak isEqualToString:string]) {
                [weakArray addObject:weak];
            }
        }
        
    }
    
    [self removeAllObjects];
    [self addObjectsFromArray:weakArray];
}


@end
