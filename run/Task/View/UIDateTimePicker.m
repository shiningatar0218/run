//
//  UIDateTimePicker.m
//  run1.2
//
//  Created by runner on 15/1/15.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "UIDateTimePicker.h"
#import "define.h"
@interface UIDateTimePicker ()
{

}

@property (nonatomic, copy) didClickButton didClickButtonCallback;
@property (nonatomic, strong) UIView *backView;

@end

@implementation UIDateTimePicker

- (instancetype)initWithFrame:(CGRect)frame {
    
    CGRect pFrame = CGRectMake(0, frame.size.height, frame.size.width, 250);
    
    if (self = [super initWithFrame:pFrame]) {
        
        [self addSubview:self.dateTimePicker];
        [self addSubview:self.headView];
    
    }
    return self;
}

- (void)dealloc {
    
    NSLog(@"data picker  release!!");
    
}

//出现
-(void)showPickerInView:(UIView *)view didClickButton:(didClickButton) didClickButtonCallback {
    if (didClickButtonCallback) {
        self.didClickButtonCallback = didClickButtonCallback;
    }
    
    CGFloat contentOffset_y = 0.0;
    
    if ([view isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)view;
        contentOffset_y = tableView.contentOffset.y;
    }

    self.backView.frame = view.bounds;
    self.frame = CGRectMake(0, contentOffset_y+view.frame.size.height+5, view.frame.size.width, 250);
    [view addSubview:self.backView];
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.backView.alpha = 0.3;
        self.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}
//消失
- (void)disMissPicker {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.alpha = 0.0;
        self.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.backView removeFromSuperview];
    }];
}


- (UIDatePicker *)dateTimePicker {
    if (!_dateTimePicker) {
        _dateTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.headView.frame.size.height, self.frame.size.width, self.frame.size.height - self.headView.frame.size.height)];
        _dateTimePicker.datePickerMode = UIDatePickerModeTime;
        _dateTimePicker.backgroundColor = [UIColor whiteColor];
    }
    return _dateTimePicker;
}

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        _headView.backgroundColor = [UIColor cyanColor];
        
        [_headView addSubview:self.sureButton];
        [_headView addSubview:self.cancleButton];
        
    }
    
    return _headView;
}

- (CustomButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[CustomButton alloc] initWithFrame:CGRectMake(self.headView.frame.size.width - 65, 0, 60, 30) Title:@"确定" WhenTouchUpinside:^(id sender){
            self.didClickButtonCallback (self.dateTimePicker.date);
            [self disMissPicker];
        }];
    }
    return _sureButton;
}

- (CustomButton *)cancleButton {
    if (!_cancleButton) {
        _cancleButton = [[CustomButton alloc] initWithFrame:CGRectMake(5, 0, 60, 30) Title:@"取消" WhenTouchUpinside:^(id sender){
            [self disMissPicker];
            
        }];
    }
    return _cancleButton;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.0;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
        
        [_backView addGestureRecognizer:tapGesture];
        
    }
    
    return _backView;
}

- (void)tapView {
    [self disMissPicker];
}

@end
