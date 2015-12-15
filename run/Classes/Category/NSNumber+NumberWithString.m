//
//  NSNumber+NumberWithString.m
//  run
//
//  Created by runner on 15/2/2.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "NSNumber+NumberWithString.h"

@implementation NSNumber (NumberWithString)

+ (NSNumber *)numberWithString:(NSString *)string {
    NSInteger number = [string integerValue];
    return [NSNumber numberWithInteger:number];
}


@end
