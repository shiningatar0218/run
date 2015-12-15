//
//  NSString+Judge.m
//  run1.2
//
//  Created by runner on 15/1/13.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "NSString+Judge.h"

@implementation NSString (Judge)

+ (NSString *)judgePersentString:(NSString *)string {
    NSString *resultString = string;
    
    float number = [string floatValue];
    if (number < 1) {
        resultString = [NSString stringWithFormat:@"%.0lf",number*100];
    }
    return resultString;
}

- (NSString *)addPresent {
    
    NSString *string = self;
    
    if (![self containsString:@"%"]) {
        string = [NSString stringWithFormat:@"%@%%",self];
    }
    return string;
}

+ (NSString *)stringWithDoubleTime:(double)time {
    NSString *h_time = (int)round(time)/60/60 < 10 ? [NSString stringWithFormat:@"0%d",(int)round(time)/60/60] : [NSString stringWithFormat:@"%d",(int)round(time)/60/60];
    
    NSString *m_time = (int)round(time)/60%60 < 10 ? [NSString stringWithFormat:@"0%d",(int)round(time)/60%60] : [NSString stringWithFormat:@"%d",(int)round(time)/60%60];
    
    NSString *s_time = (int)round(time)%60 < 10 ? [NSString stringWithFormat:@"0%d",(int)round(time)%60] : [NSString stringWithFormat:@"%d",(int)round(time)%60];
    return [NSString stringWithFormat:@"%@:%@:%@",h_time,m_time,s_time];
}

+ (NSString *)stringWithDoublePaceTime:(double)time {
    NSString *m_time = (int)round(time)/60%60 < 10 ? [NSString stringWithFormat:@"0%d",(int)round(time)/60%60] : [NSString stringWithFormat:@"%d",(int)round(time)/60%60];
    
    NSString *s_time = (int)round(time)%60 < 10 ? [NSString stringWithFormat:@"0%d",(int)round(time)%60] : [NSString stringWithFormat:@"%d",(int)round(time)%60];
    return [NSString stringWithFormat:@"%@:%@",m_time,s_time];
}

@end
