//
//  CustomTextField.h
//  FinalWork
//
//  Created by Geforceyu on 14/10/29.
//  Copyright (c) 2014年 rimi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMCalendar.h"

typedef void(^didBeginEditing)(id sender);

typedef NS_ENUM(NSInteger, EditStyle) {
    EditStyleDefault = 0,
    EditStyleCalendar = 1
};


@interface CustomTextField : UIView

@property (nonatomic,assign)EditStyle editStyle;
@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,retain)NSString * textFieldText;
@property (nonatomic,retain)NSString *textFieldText_l;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title titleLenth:(CGFloat)titleLenth endEding:(void(^)(NSString * text))endEding;

-(void)clearText;
-(void)setTFtext:(NSString *)text;

- (void)didBeginEditing:(didBeginEditing )beginEditing;
- (void)didEndEditing:(void(^)(NSString * text))endEding;
- (void)showCalendarInView:(UIView *)view;
@end
