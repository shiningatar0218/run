//
//  CustomTextField.m
//  FinalWork
//
//  Created by Geforceyu on 14/10/29.
//  Copyright (c) 2014年 rimi. All rights reserved.
//

#import "CustomTextField.h"

@interface CustomTextField()<UITextFieldDelegate,PMCalendarControllerDelegate>
{
   
}
@property (nonatomic,copy)didBeginEditing beginEditing;
@property (nonatomic,strong)void(^endEding)(NSString * text);
@property (nonatomic, strong) PMCalendarController *calendar;
@end


@implementation CustomTextField

- (id)initWithFrame:(CGRect)frame title:(NSString *)title titleLenth:(CGFloat)titleLenth endEding:(void(^)(NSString * text))endEding
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (endEding) {
            self.endEding = endEding;
        }
        _textFieldText = [NSString string];
//        self.layer.borderWidth = 1;
        //标题
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, titleLenth, CGRectGetHeight(frame))];
        //titleLabel.textColor = [UIColor colorWithWhite:0.65 alpha:1];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = title;
        [self addSubview:titleLabel];
        
        //输入框
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(titleLenth+10, 0, CGRectGetWidth(frame)-titleLenth-10, CGRectGetHeight(frame))];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.delegate = self;
        _textField.font = [UIFont systemFontOfSize:18];
        _textField.returnKeyType = UIReturnKeyDone;
//        _textField.borderStyle = UITextBorderStyleBezel;
        [self addSubview:_textField];
        
    }
    return self;
}
-(void)clearText
{
    _textField.text = @"";
}
-(void)setTFtext:(NSString *)text
{
    _textField.text = text;

}

- (void)setTextFieldText:(NSString *)textFieldText {
    _textField.text = textFieldText;
}

- (void)didBeginEditing:(didBeginEditing )beginEditing {
    if (beginEditing) {
        self.beginEditing = beginEditing;
    }
}

- (void)didEndEditing:(void(^)(NSString * text))endEding {
    if (endEding) {
        self.endEding = endEding;
    }
}

#pragma mark --UITextFieldViewdelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.editStyle == EditStyleCalendar) {
        [textField resignFirstResponder];
        
    }
    self.beginEditing (self);
}

#pragma mark -- PMCalendar
- (void)showCalendarInView:(UIView *)view
{
    _calendar = [[PMCalendarController alloc] init];
    _calendar.delegate = self;
    _calendar.mondayFirstDayOfWeek = YES;
    [self.calendar presentCalendarFromView:self.superview InView:view permittedArrowDirections:PMCalendarArrowDirectionAny animated:YES];
}

- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod {
    
    self.textFieldText = [NSString stringWithFormat:@"%@",[newPeriod.startDate dateStringWithFormat:@"dd/MM/yyyy"]];
    self.textFieldText_l = [NSString stringWithFormat:@"%@",[newPeriod.endDate dateStringWithFormat:@"dd/MM/yyyy"]];
    
    //self.creat_task.begin_time = newPeriod.startDate;
}

- (void)calendarControllerDidDismissCalendar:(PMCalendarController *)calendarController {
    self.endEding (_textField.text);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _textFieldText = textField.text;
    if (_endEding) {
        _endEding(textField.text);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    _textFieldText = textField.text;
    return YES;
}

@end
