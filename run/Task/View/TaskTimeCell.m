//
//  TaskTimeCell.m
//  run
//
//  Created by runner on 15/2/13.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "TaskTimeCell.h"
#import "UIDateTimePicker.h"
#import "CustomButton.h"
#import "CustomTextField.h"

@implementation TaskTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier inView:(UIView *)view{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        __block UIDateTimePicker *timePicker = [[UIDateTimePicker alloc] initWithFrame:view.bounds];
        
        NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
        [dataFormatter setDateFormat:@"HH:mm"];
        
        CustomButton *endTime = [[CustomButton alloc] initWithFrame:CGRectMake(view.frame.size.width - 70, 0, 70, self.frame.size.height) Title:nil WhenTouchUpinside:^(id sender) {
            
            CustomButton *endButton = sender;
            
            if (!timePicker) {
                timePicker = [[UIDateTimePicker alloc] initWithFrame:view.bounds];
            }
            
            [timePicker showPickerInView:view didClickButton:^(NSDate *timeDate) {
                [endButton setTitle:[dataFormatter stringFromDate:timeDate] forState:UIControlStateNormal];
            }];
        }];
        [endTime setTitle:@"20:30" forState:UIControlStateNormal];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(endTime.frame)-20, 0, 20, self.frame.size.height)];
        label.text = @"至";
        label.textAlignment = NSTextAlignmentCenter;
        CustomButton *startTime = [[CustomButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame)-70, 0, 70, self.frame.size.height) Title:nil WhenTouchUpinside:^(id sender) {
            if (!timePicker) {
                timePicker = [[UIDateTimePicker alloc] initWithFrame:view.bounds];
            }
            CustomButton *startButton = sender;
            [timePicker showPickerInView:view didClickButton:^(NSDate *timeDate) {
                [startButton setTitle:[dataFormatter stringFromDate:timeDate] forState:UIControlStateNormal];
            }];
        }];
        [startTime setTitle:@"19:00" forState:UIControlStateNormal];
        
        [endTime setTintColor:[UIColor lightGrayColor]];
        label.textColor = [UIColor lightGrayColor];
        [startTime setTintColor:[UIColor lightGrayColor]];
        
        [self addSubview:endTime];
        [self addSubview:label];
        [self addSubview:startTime];
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

- (void)dealloc {
    NSLog(@"time cell  release!!!");
}

@end
