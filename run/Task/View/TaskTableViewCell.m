//
//  TaskTableViewCell.m
//  run1.2
//
//  Created by runner on 15/1/7.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "TaskTableViewCell.h"
#import "define.h"

#define TEXT_COLOR [UIColor colorWithRed:225 green:90 blue:0 alpha:1]

@interface TaskTableViewCell ()
{
    CGFloat left_with;
    CGFloat cell_height;
}

@end

@implementation TaskTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
//        self.layer.borderWidth = 1.0;
//        self.layer.borderColor = [UIColor blackColor].CGColor;
//        self.layer.cornerRadius = 20;
//        self.backgroundColor = RGBACOLOR(230, 230, 230, 1);
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.layer.borderWidth = 3;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
//        self.layer.shadowColor = [UIColor grayColor].CGColor;
//        self.layer.shadowOffset = CGSizeMake(0, 5);
        
        left_with = (iPhone4 ? 320 : 375)/3.0;
        cell_height = left_with;
        
        self.frame = CGRectMake(0, 0, kMainScreenWidth, cell_height);
        
        [self addSubview:self.nameLabel];
        [self addSubview:self.task_description];
        [self addSubview:self.distanceProgress];
        [self addSubview:self.timeLabel];
        
        [self addSubview:self.task_num_Label];
        [self addSubview:self.end_timeLabel];
        [self addSubview:[LineView LineViewWithFrame:CGRectMake(self.frame.size.width/2, MaxY(self.distanceProgress)+5, 2, cell_height - MaxY(self.distanceProgress)-5) color:[UIColor whiteColor]]];
//         [self addSubview:[LineView LineViewWithFrame:CGRectMake(0, MaxY(self.distanceProgress)+5, self.frame.size.width, 1) color:[UIColor whiteColor]]];
        [self addSubview:self.backImageView];
        [self addSubview:self.adImageView];
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
    self.time_startLabel.text = @"12月";
    
    if (taskModel.user_id_creator != [DATAMODEL.userId longLongValue]) {
        self.adImageView.hidden = YES;
    }else {
        self.adImageView.hidden = NO;
    }
}

- (UIImageView *)adImageView {
    if (!_adImageView) {
        _adImageView = [[UIImageView alloc] init];
        _adImageView.frame = CGRectMake(self.frame.size.width - 40-10, 0, 40, 45);
        _adImageView.image = [UIImage imageNamed:@"task_administrator.png"];
    }
    return _adImageView;
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
        _end_timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(self.distanceProgress)+5, self.frame.size.width/2, cell_height - MaxY(self.distanceProgress)-5)];
        
        _end_timeLabel.textAlignment = NSTextAlignmentCenter;
        if (iPhone4) {
            _end_timeLabel.font = [UIFont systemFontOfSize:12];
        }
        
        _end_timeLabel.backgroundColor = NaVBarColor;
        _end_timeLabel.textColor = [UIColor whiteColor];
    }
    return _end_timeLabel;
}

- (UILabel *)task_num_Label {
    if (!_task_num_Label) {
        _task_num_Label = [[UILabel alloc] initWithFrame:CGRectMake(self.end_timeLabel.frame.size.width+2, MinY(self.end_timeLabel), self.frame.size.width/2-2, self.end_timeLabel.frame.size.height)];
        _task_num_Label.textAlignment = NSTextAlignmentCenter;
        if (iPhone4) {
            _task_num_Label.font = [UIFont systemFontOfSize:12];
        }
        _task_num_Label.backgroundColor = NaVBarColor;
        _task_num_Label.textColor = [UIColor whiteColor];
        
        [_task_num_Label addSubview:self.memberImageView];
    }
    return _task_num_Label;
}

- (UIImageView *)memberImageView {
    if (!_memberImageView) {
        _memberImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, self.task_num_Label.frame.size.height)];
        _memberImageView.image = [UIImage imageNamed:@"task_members.png"];
    }
    return _memberImageView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
    
    // Configure the view for the selected state
}

//- (UILabel *)nameLabel {
//    if (!_nameLabel) {
//        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(left_with, 10, self.frame.size.width - left_with, 20)];
//        _nameLabel.textAlignment = NSTextAlignmentLeft;
//        _nameLabel.textColor = TEXT_COLOR;
//        _nameLabel.font = [UIFont boldSystemFontOfSize:iPhone4?16:18];
//    }
//    return _nameLabel;
//}
//
//- (LabelTitle *)task_description {
//    if (!_task_description) {
//        _task_description = [[LabelTitle alloc] initWithFrame:CGRectMake(left_with, CGRectGetMaxY(self.nameLabel.frame), self.frame.size.width - left_with, 20) title:@"任务：" text:nil textColor:nil];
//    }
//    return _task_description;
//}
//
//- (TJProgressView *)distanceProgress {
//    if (!_distanceProgress) {
//        _distanceProgress = [[TJProgressView alloc] initWithFrame:CGRectMake(left_with, CGRectGetMaxY(self.task_description.frame)+10*(iPhone4 ? 0.8:1), 200*(iPhone6 ? 1 : WIDTH_SCALE), 30*(iPhone4 ? 0.8:1))];
//        if (iPhone4) {
//            _distanceProgress.progressLabel.font = [UIFont systemFontOfSize:12];
//        }
//    }
//    return _distanceProgress;
//}
//
//- (UILabel *)end_timeLabel {
//    if (!_end_timeLabel) {
//        _end_timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(self.distanceProgress)+5, self.frame.size.width/2, cell_height - MaxY(self.distanceProgress)-5)];
//        
//        _end_timeLabel.textAlignment = NSTextAlignmentCenter;
//        if (iPhone4) {
//            _end_timeLabel.font = [UIFont systemFontOfSize:12];
//        }
//    }
//    return _end_timeLabel;
//}
//
//- (UILabel *)task_num_Label {
//    if (!_task_num_Label) {
//        _task_num_Label = [[UILabel alloc] initWithFrame:CGRectMake(self.end_timeLabel.frame.size.width, MinY(self.end_timeLabel), self.frame.size.width/2, self.end_timeLabel.frame.size.height)];
//        _task_num_Label.textAlignment = NSTextAlignmentCenter;
//        if (iPhone4) {
//            _task_num_Label.font = [UIFont systemFontOfSize:12];
//        }
//    }
//    return _task_num_Label;
//}


@end
