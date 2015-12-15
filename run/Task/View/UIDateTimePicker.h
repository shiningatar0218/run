//
//  UIDateTimePicker.h
//  run1.2
//
//  Created by runner on 15/1/15.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
typedef void (^didClickButton)(NSDate *timeDate);

@interface UIDateTimePicker : UIView
@property (nonatomic, strong) UIDatePicker *dateTimePicker;
@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) CustomButton *sureButton;
@property (nonatomic, strong) CustomButton *cancleButton;

//出现
-(void)showPickerInView:(UIView *)view didClickButton:(didClickButton) didClickButtonCallback;
- (void)disMissPicker;//消失

@end
