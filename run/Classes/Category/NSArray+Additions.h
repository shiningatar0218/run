//
//  NSArray+Additions.h
//  run
//
//  Created by runner on 15/3/20.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Additions)

+ (NSComparisonResult)comparePointValue1:(NSValue *)value1 WithPointValue2:(NSValue *)value2;

+ (NSComparisonResult)compareString1:(NSString *)string1 WithString2:(NSString *)string2;

@end
