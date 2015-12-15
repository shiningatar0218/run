//
//  SettingCell.m
//  run1.2
//
//  Created by runner on 15/1/23.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        
        self.backgroundColor = [UIColor lightGrayColor];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
