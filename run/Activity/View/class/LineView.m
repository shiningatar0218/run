//
//  LineView.m
//  run1.2
//
//  Created by runner on 15/1/5.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "LineView.h"

@implementation LineView

+(id)LineViewWithFrame:(CGRect)frame color:(UIColor *)color{
    UIView *lineView = [[UIView alloc] initWithFrame:frame];
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    if (color) {
        lineView.backgroundColor = color;
    }
    
    return lineView;
}

@end
