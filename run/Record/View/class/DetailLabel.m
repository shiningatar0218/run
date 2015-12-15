//
//  DetailLabel.m
//  run
//
//  Created by runner on 15/3/9.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "DetailLabel.h"
#import "define.h"

@interface DetailLabel ()


@end

@implementation DetailLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.borderColor = sahara_BackGroundColor.CGColor;
        self.layer.borderWidth = 0.5;
        
        [self addSubview:self.textLabel];
        [self addSubview:self.detailLabel];
    }
    return self;
}



- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/3.0*2)];
        
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = SYSTEM_18_FONT;
    }
    
    return _textLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.textLabel.frame.size.height,self.frame.size.width, self.frame.size.height - self.textLabel.frame.size.height)];
        
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.font = SYSTEM_12_FONT;
        _detailLabel.textColor = [UIColor lightGrayColor];
    }
    return _detailLabel;
}

@end
