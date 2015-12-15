//
//  MapViewCell.m
//  run
//
//  Created by runner on 15/3/6.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "MapViewCell.h"
#import "define.h"
#import "ImageLabel.h"
#import "CustomButton.h"
#import "NSString+Judge.h"
#import "DataModel.h"


@interface MapViewCell ()
{
    CGFloat detailLabel_height;
    CGFloat detaillabel_with;
}
@property (nonatomic, retain) UIImageView *userimageView;

@property (nonatomic, retain) ImageLabel *titleLabel;


@property (nonatomic, retain) NSMutableArray *points;

@property (nonatomic, retain) Activity *model;

@end

@implementation MapViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    
        self.frame = CGRectMake(0, 0, kMainScreenWidth, (kMainScreenHeight-64.0)/3.0*2-80);
        self.backgroundColor = sahara_BackGroundColor;
        
        self.contentView.backgroundColor = sahara_BackGroundColor;

        [self.contentView addSubview:self.backView];
    }
    
    return self;
}

- (void)showDataWithModel:(Activity *)model {
    self.model = model;
    NSString *string = model.file_url;
    
    NSInteger count = 0;
    int user_id = [model.user_id intValue];
    while (user_id) {
        user_id /= 10;
        count ++;
    }
    NSString *fileName = @"";
    if (string.length > 0) {
        NSRange range = [string rangeOfString:@".txt"];
        fileName = [string substringWithRange:NSMakeRange(range.location - 12 - count-1, 12 + count + 1)];
    }
    
    [DATAMODEL readDataFromFile:fileName completion:^(BOOL didFinish, NSArray *array) {
        self.points = [array mutableCopy];
        [self.mapView startUpDateAndShowRuteWithPoints:self.points];
    }];
    
    NSLog(@"%@",fileName);
    
    //self.userimageView.image = [UIImage imageNamed:@"my_icon_man.png"];
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",model.create_time,model.name];
    if ([model.sport isEqualToNumber:@0]) {
        self.titleLabel.image = [UIImage imageNamed:@"record_run.png"];
    }else {
        self.titleLabel.image = [UIImage imageNamed:@"s_raid.png"];
    }
    
    self.distanceLabel.textLabel.text = [NSString stringWithFormat:@"%.2f/公里",[model.total_distance doubleValue]/1000.0];
    self.timeLabel.textLabel.text = [NSString stringWithDoubleTime:[model.total_time doubleValue]];
    self.paceLabl.textLabel.text = [NSString stringWithFormat:@"%@/公里",[NSString stringWithDoubleTime:[model.pace doubleValue]]];
    self.calLabel.textLabel.text = [NSString stringWithFormat:@"%@",model.energy];

    //self.userImageView.image = [UIImage imageNamed:@""];
    self.levelLabel.text = @"3";
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, kMainScreenWidth-10, self.frame.size.height)];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _backView.layer.borderWidth = 1.0;
        _backView.layer.cornerRadius = 8;
        _backView.layer.shadowOffset = CGSizeMake(0, 0.6);
        _backView.clipsToBounds = YES;
        
        
        [_backView addSubview:self.headerView];
        [_backView addSubview:self.mapRecordView];
        [_backView addSubview:self.dataView];
    }
    
    return _backView;
}


- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.backView.frame.size.width, 60)];
        _headerView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:self.userimageView];
        [_headerView addSubview:self.addButton];
        [_headerView addSubview:self.titleLabel];
    }
    
    return _headerView;
}

- (UIView *)mapRecordView {
    if (!_mapRecordView) {
        _mapRecordView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.frame.size.height, self.backView.frame.size.width, self.frame.size.height - 80.0-self.headerView.frame.size.height)];
        
        [_mapRecordView addSubview:self.mapView];
        [_mapRecordView addSubview:self.whiterView];
    }
    
    return _mapRecordView;
}

- (UIView *)dataView {
    if (!_dataView) {
        _dataView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mapRecordView.frame), self.backView.frame.size.width, self.backView.frame.size.height - CGRectGetMaxY(self.mapRecordView.frame))];
        
        _dataView.layer.borderColor = sahara_BackGroundColor.CGColor;
        _dataView.layer.borderWidth = 0.5;
        
        detaillabel_with = (_dataView.frame.size.width - _dataView.frame.size.height) / 2.0;
        detailLabel_height = _dataView.frame.size.height/2.0;
        [_dataView addSubview:self.distanceLabel];
        [_dataView addSubview:self.timeLabel];
        [_dataView addSubview:self.paceLabl];
        [_dataView addSubview:self.calLabel];
        
        [_dataView addSubview:self.levelView];
        [_dataView addSubview:self.levelLabel];
    }
    return _dataView;
}

- (UIImageView *)levelView {
    if (!_levelView) {
        _levelView = [[UIImageView alloc] init];
        _levelView.center = CGPointMake(detaillabel_with*2+detailLabel_height, detailLabel_height);
        _levelView.bounds = CGRectMake(0, 0, 40, 40);
        _levelView.image = [UIImage imageNamed:@"record_level.png"];
    }
    
    return _levelView;
}

- (UILabel *)levelLabel {
    if (!_levelLabel) {
        _levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(detaillabel_with*2, detailLabel_height/2.0*3, detailLabel_height*2, 20)];
        
        _levelLabel.textAlignment = NSTextAlignmentCenter;
        _levelLabel.textColor = NaVBarColor;
    }
    return _levelLabel;
}

- (DetailLabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [[DetailLabel alloc] initWithFrame:CGRectMake(0, 0, detaillabel_with, detailLabel_height)];
        
        _distanceLabel.detailLabel.text = @"距离";
    }
    
    return _distanceLabel;
}

- (DetailLabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[DetailLabel alloc] initWithFrame:CGRectMake(detaillabel_with, 0, detaillabel_with, detailLabel_height)];
        
        _timeLabel.detailLabel.text = @"时间";
    }
    return _timeLabel;
}

- (DetailLabel *)paceLabl {
    if (!_paceLabl) {
        _paceLabl = [[DetailLabel alloc] initWithFrame:CGRectMake(0, detailLabel_height, detaillabel_with, detailLabel_height)];
        
        _paceLabl.detailLabel.text = @"平均配速";
    }
    return _paceLabl;
}

- (DetailLabel *)calLabel {
    if (!_calLabel) {
        _calLabel = [[DetailLabel alloc] initWithFrame:CGRectMake(detaillabel_with, detailLabel_height, detaillabel_with, detailLabel_height)];
        
        _calLabel.detailLabel.text = @"大卡";
        
    }
    return _calLabel;
}


- (MapView *)mapView {
    if (!_mapView) {
        _mapView = [[MapView alloc] initWithFrame:self.mapRecordView.bounds];
        
        [_mapView addSubview:self.mainScreenButton];
        
    }
    return _mapView;
}

- (UIView *)whiterView {
    if (!_whiterView) {
        _whiterView = [[UIView alloc] initWithFrame:CGRectMake(0, self.mapRecordView.frame.size.height/4*3, self.backView.frame.size.width, self.mapRecordView.frame.size.height/4)];
        _whiterView.backgroundColor = [UIColor whiteColor];
        _whiterView.alpha = 0.75;
        
        CustomButton *praiseButton = [[CustomButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 70, 0, _whiterView.frame.size.height, _whiterView.frame.size.height) NormalImage:@"record_praise_normal.png" selectImage:@"record_praise_press.png" whenTouchUpInside:^(id sender) {
            if ([sender isKindOfClass:[CustomButton class]]) {
                CustomButton *button = sender;
                [button setImage:[UIImage imageNamed:button.selectImage] forState:UIControlStateNormal];
            }
        }];
        
        CustomButton *commentButton = [[CustomButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(praiseButton.frame) - 60, 0, _whiterView.frame.size.height, _whiterView.frame.size.height) NormalImage:@"record_comment_normal.png" selectImage:@"record_comment_press.png" whenTouchUpInside:^(id sender) {
            if ([sender isKindOfClass:[CustomButton class]]) {
                CustomButton *button = sender;
                [button setImage:[UIImage imageNamed:button.selectImage] forState:UIControlStateNormal];
            }
        }];
        
        CustomButton *shareButton = [[CustomButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(commentButton.frame) - 70, 0, _whiterView.frame.size.height, _whiterView.frame.size.height) NormalImage:@"record_share_normal.png" selectImage:@"record_share_press.png" whenTouchUpInside:^(id sender) {
            if ([sender isKindOfClass:[CustomButton class]]) {
                CustomButton *button = sender;
                [button setImage:[UIImage imageNamed:button.selectImage] forState:UIControlStateNormal];
            }
        }];
        
        
        [_whiterView addSubview:praiseButton];
        [_whiterView addSubview:commentButton];
        [_whiterView addSubview:shareButton];
    }
    return _whiterView;
}


- (UIImageView *)userimageView {
    if (!_userimageView) {
        _userimageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        _userimageView.layer.cornerRadius = 20.0;
        _userimageView.clipsToBounds = YES;
        _userimageView.layer.borderColor = [UIColor orangeColor].CGColor;
        _userimageView.layer.borderWidth = 0.5;
        _userimageView.image = [UIImage imageNamed:@"my_icon_man.png"];
    }
    return _userimageView;
}

- (CustomButton *)addButton {
    if (!_addButton) {
        _addButton = [[CustomButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 160, 0, 160, _headerView.frame.size.height) Title:@"加为好友" WhenTouchUpinside:^(id sender) {
            NSLog(@"add friend");

        }];
        [_addButton setImage:[UIImage imageNamed:@"my_icon_add_friend.png"] forState:UIControlStateNormal];
        [_addButton setTintColor:[UIColor grayColor]];
    }
    
    return _addButton;
}

- (ImageLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[ImageLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userimageView.frame), 0, self.frame.size.width - CGRectGetMaxX(self.userimageView.frame) - self.addButton.frame.size.width, _headerView.frame.size.height)];
        _titleLabel.image = [UIImage imageNamed:@"record_run.png"];
        _titleLabel.title = @"";
    }
    return _titleLabel;
}

- (NSMutableArray *)points {
    if (!_points) {
        _points = [NSMutableArray arrayWithCapacity:0];
    }
    return _points;
}

- (CustomButton *)mainScreenButton {
    if (!_mainScreenButton) {
        _mainScreenButton = [[CustomButton alloc] initWithFrame:CGRectMake(self.mapView.frame.size.width - 60, 0, 60, 60) NormalImage:@"record_fit_screen.png" selectImage:@"record_small_creen.png" whenTouchUpInside:^(id sender) {
            [self.delegate mapView:self.mapView WithModel:self.model];
        }];
    }
    
    return _mainScreenButton;
}

- (void)dealloc {
    self.delegate = nil;
    NSLog(@"mapview   release");
}


@end
