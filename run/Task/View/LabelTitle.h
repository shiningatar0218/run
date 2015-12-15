//
//  LabelTitle.h
//  太平之家1.1
//
//  Created by rimi on 14/12/17.
//  Copyright (c) 2014年 rimi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EndEdit)(NSString *text);
typedef void(^BeginEdit)();
@interface LabelTitle : UIView
@property (nonatomic, copy) EndEdit didendEditing;
@property (nonatomic, copy) BeginEdit didBeginEditing;
@property (nonatomic,retain)NSString *text;
@property (nonatomic,retain)UIFont *font;
@property (nonatomic,retain)NSString *title;

@property (nonatomic,retain)UITextField *textField;
@property (nonatomic, strong) UILabel *textLabel;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title text:(NSString *)text textColor:(UIColor *)color;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title placeholder:(NSString *)text;

- (void)didendEditing:(EndEdit)didendEditing;

- (void)didBeginEditing:(BeginEdit)didBeginEditing;
@end
