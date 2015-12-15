//
//  MarkButton.m
//  run1.2
//
//  Created by runner on 15/1/6.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "MarkButton.h"
#import "define.h"

@interface MarkButton (){
        
}

@end

CGFloat markButton_hight = 30;
CGFloat markButton_with = 30;

@implementation MarkButton

- (id)initWithFrame:(CGRect)frame title:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.selected = NO;
        
        self.markButton.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/4);
        self.markButton.bounds = CGRectMake(0, 0, markButton_with*(iPhone4?0.8:1), markButton_hight*(iPhone4?0.8:1));
        [self addSubview:self.markButton];
        
        self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.markButton.frame), self.frame.size.width, self.frame.size.height - CGRectGetMaxY(self.markButton.frame));
        self.titleLabel.text = title;
        [self addSubview:self.titleLabel];

        
        
    }
    return self;
}

- (NSString *)title {
    return self.titleLabel.text;
}

#pragma mark -- titleLabel

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _titleLabel;
}

#pragma mark -- markButton
- (UIButton *)markButton {
    if (!_markButton) {
        _markButton = [[UIButton alloc] init];
        _markButton.layer.borderWidth = 1;
        _markButton.layer.borderColor = [UIColor blackColor].CGColor;
        _markButton.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        [_markButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_markButton addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _markButton;
}

- (void)didClickButton:(UIButton *)sender{
    self.selected = !self.selected;
    if (self.selected) {
        [sender setTitle:@"√" forState:UIControlStateNormal];
    }else {
        [sender setTitle:@"" forState:UIControlStateNormal];
    }
}

@end
