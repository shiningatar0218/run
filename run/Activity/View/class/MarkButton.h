//
//  MarkButton.h
//  run1.2
//
//  Created by runner on 15/1/6.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarkButton : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) UIButton *markButton;
@property (nonatomic, strong) UILabel *titleLabel;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;

@end
