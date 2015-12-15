//
//  TaskViewCell.m
//  run
//
//  Created by runner on 15/2/14.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "TaskViewCell.h"
#import "LineView.h"
#import "define.h"
@interface TaskViewCell ()
{
    CGFloat left_with;
    CGFloat cell_height;
}

@end

@implementation TaskViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        left_with = (iPhone4 ? 320 : 375)/3.0;
        cell_height = left_with;
        
        self.frame = CGRectMake(0, 0, kMainScreenWidth, left_with);
        
        [self addSubview:self.nameLabel];
        [self addSubview:self.task_description];
        [self addSubview:self.distanceProgress];
        [self addSubview:self.timeLabel];
        
        [self addSubview:[LineView LineViewWithFrame:CGRectMake(0, MaxY(self.distanceProgress)+5, self.frame.size.width, 1) color:[UIColor lightGrayColor]]];
        
        [self addSubview:[LineView LineViewWithFrame:CGRectMake(self.frame.size.width/3*2, MaxY(self.distanceProgress)+5, 1, cell_height - MaxY(self.distanceProgress)-5) color:[UIColor lightGrayColor]]];
        
        [self addSubview:[LineView LineViewWithFrame:CGRectMake(self.frame.size.width/3,MaxY(self.distanceProgress)+5, 1, cell_height - MaxY(self.distanceProgress)-5) color:[UIColor lightGrayColor]]];
        
        [self addSubview:self.task_num_Label];
        [self addSubview:self.end_timeLabel];
        
        [self addSubview:self.backImageView];
        [self addSubview:self.helpButton];
    }
    return self;
}

#pragma mark -- 数据处理
- (void)layoutData:(Task *)taskModel{
    self.nameLabel.text = taskModel.name;
    self.task_description.text = taskModel.task_description;
    self.distanceProgress.progressLabel.text = @"5km";
    self.distanceProgress.progress.progress = 0.3;
    
    self.end_timeLabel.text = @"剩余20天";
    self.task_num_Label.text = @"1,546/12,596";
    self.task_distance_Label.text = [NSString stringWithFormat:@"%fkm\n总距离",taskModel.target_distance];
    self.time_startLabel.text = @"12月";
}

- (CustomButton *)helpButton {
    if (!_helpButton) {
        _helpButton = [[CustomButton alloc] initWithFrame:CGRectMake(self.frame.size.width-50, 10, 40, 40) NormalImage:@"task_help_2.png" selectImage:nil whenTouchUpInside:^(id sender) {
            NSLog(@"help");
        }];
    }
    return _helpButton;
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"task_icon_time.png"]];
        _backImageView.center = CGPointMake(left_with/2, (left_with- self.end_timeLabel.frame.size.height)/2);
        _backImageView.bounds = CGRectMake(0, 0, left_with-self.end_timeLabel.frame.size.height-10, left_with-self.end_timeLabel.frame.size.height-10);
        [_backImageView addSubview:self.time_startLabel];
    }
    return _backImageView;
}

- (UILabel *)time_startLabel {
    if (!_time_startLabel) {
        _time_startLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 26, self.backImageView.frame.size.width, self.backImageView.frame.size.height/2-20)];
        _time_startLabel.font = BOLD_16_FONT;
        _time_startLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _time_startLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(left_with, 10, self.frame.size.width - left_with, 20)];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = NaVBarColor;
        _nameLabel.font = [UIFont boldSystemFontOfSize:iPhone4?16:18];
        
    }
    return _nameLabel;
}

- (LabelTitle *)task_description {
    if (!_task_description) {
        _task_description = [[LabelTitle alloc] initWithFrame:CGRectMake(left_with, CGRectGetMaxY(self.nameLabel.frame), self.frame.size.width - left_with, 20) title:@"任务：" text:nil textColor:nil];
    }
    return _task_description;
}

- (TJProgressView *)distanceProgress {
    if (!_distanceProgress) {
        _distanceProgress = [[TJProgressView alloc] initWithFrame:CGRectMake(left_with, CGRectGetMaxY(self.task_description.frame)+10*(iPhone4 ? 0.8:1), 200*(iPhone6 ? 1 : WIDTH_SCALE), 30*(iPhone4 ? 0.8:1))];
        if (iPhone4) {
            _distanceProgress.progressLabel.font = [UIFont systemFontOfSize:12];
        }
    }
    return _distanceProgress;
}

- (UILabel *)end_timeLabel {
    if (!_end_timeLabel) {
        _end_timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(self.distanceProgress)+5, self.frame.size.width/3, cell_height - MaxY(self.distanceProgress)-5)];
        
        _end_timeLabel.textAlignment = NSTextAlignmentCenter;
        if (iPhone4) {
            _end_timeLabel.font = [UIFont systemFontOfSize:12];
        }
    }
    return _end_timeLabel;
}

- (UILabel *)task_num_Label {
    if (!_task_num_Label) {
        _task_num_Label = [[UILabel alloc] initWithFrame:CGRectMake(self.end_timeLabel.frame.size.width, MinY(self.end_timeLabel), self.frame.size.width/3, self.end_timeLabel.frame.size.height)];
        _task_num_Label.textAlignment = NSTextAlignmentCenter;
        if (iPhone4) {
            _task_num_Label.font = [UIFont systemFontOfSize:12];
        }
    }
    return _task_num_Label;
}

- (UILabel *)task_distance_Label {
    if (!_task_distance_Label) {
        _task_distance_Label = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.task_num_Label), MinY(self.end_timeLabel), self.frame.size.width/3, self.end_timeLabel.frame.size.height)];
        _task_distance_Label.textAlignment = NSTextAlignmentCenter;
        if (iPhone4) {
            _task_distance_Label.font = [UIFont systemFontOfSize:12];
        }
    }
    
    return _task_distance_Label;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
