//
//  NSString+Judge.h
//  run1.2
//
//  Created by runner on 15/1/13.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Judge)

+ (NSString *)judgePersentString:(NSString *)string;
- (NSString *)addPresent;

+ (NSString *)stringWithDoubleTime:(double)time;
+ (NSString *)stringWithDoublePaceTime:(double)time;
@end
