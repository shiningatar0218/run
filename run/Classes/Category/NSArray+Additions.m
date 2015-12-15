//
//  NSArray+Additions.m
//  run
//
//  Created by runner on 15/3/20.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "NSArray+Additions.h"
#import <UIKit/UIKit.h>

@implementation NSArray (Additions)

+ (NSComparisonResult)comparePointValue1:(NSValue *)value1 WithPointValue2:(NSValue *)value2{
    
    CGPoint point1 = [value1 CGPointValue];
    CGPoint point2 = [value2 CGPointValue];
    NSComparisonResult result = [[NSNumber numberWithFloat:point1.y] compare:[NSNumber numberWithFloat:point2.y]];
    
    if (result == NSOrderedAscending) {
        return result;
    }
    
    return result;
}

+ (NSComparisonResult)compareString1:(NSString *)string1 WithString2:(NSString *)string2 {
    
    int number1 = [string1 intValue];
    int number2 = [string2 intValue];
    
    NSComparisonResult result = [[NSNumber numberWithInt:number1] compare:[NSNumber numberWithInt:number2]];
    
    return result;
    
}

@end
