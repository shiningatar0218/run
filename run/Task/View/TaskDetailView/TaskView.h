//
//  TaskView.h
//  run1.2
//
//  Created by runner on 15/1/16.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJProgressView.h"
#import "LabelTitle.h"
#import "Task.h"
#import "CustomButton.h"

@interface TaskView : UIView


//---------数据属性
@property (nonatomic, retain) UIImageView *backImageView;
@property (nonatomic, retain) UILabel *time_startLabel;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) LabelTitle *task_description;
@property (nonatomic, retain) TJProgressView *distanceProgress;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *end_timeLabel;
@property (nonatomic, retain) UILabel *sahara_Label;
@property (nonatomic, retain) UILabel *task_num_Label;

@property (nonatomic, retain) UILabel *task_distance_Label;


@property (nonatomic, retain)CustomButton *helpButton;

- (void)layoutData:(Task *)taskModel;

@end
