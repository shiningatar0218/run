//
//  PieceCellTableViewCell.m
//  run1.2
//
//  Created by runner on 15/1/6.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "PieceCellTableViewCell.h"
#import "define.h"
#import "NSString+Judge.h"

@implementation PieceCellTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addSubview:self.pieceLabel];
        [self addSubview:self.paceProgress];
        [self addSubview:self.totalTimeLabel];
        [self addSubview:self.timeLabel];
        
        
    }
    return self;
}

- (void)showDataWithModel:(ActivitySplit *)model {
    self.paceProgress.progress = model.value/(PACE*60);
    self.pieceLabel.text = [NSString stringWithFormat:@"%.f",model.number];
    self.timeLabel.text = [NSString stringWithDoublePaceTime:model.value];
    
    if (model.number < 1.0) {
        self.paceProgress.progress = model.value/model.number/(PACE*60);
    }
}

- (UILabel *)pieceLabel {
    if (!_pieceLabel) {
        _pieceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 20, self.frame.size.height)];
        _pieceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _pieceLabel;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.pieceLabel.frame), 0, 90, self.frame.size.height)];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    
    return _totalTimeLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.totalTimeLabel.frame), 0, 60, self.frame.size.height)];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UIProgressView *)paceProgress {
    if (!_paceProgress) {
        _paceProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.pieceLabel.frame)+2, 0, kMainScreenWidth - 20 - CGRectGetMaxX(self.pieceLabel.frame), self.frame.size.height)];
        
        _paceProgress.center = CGPointMake(_paceProgress.center.x, self.frame.size.height/2);
        _paceProgress.progressViewStyle = UIProgressViewStyleBar;
        _paceProgress.progress = 0.5;
        _paceProgress.backgroundColor = [UIColor lightGrayColor];
        _paceProgress.tintColor = sahara_color;
        _paceProgress.transform = CGAffineTransformMakeScale(1.0f, 10.0f);
        
        _paceProgress.clipsToBounds = YES;
        _paceProgress.layer.borderWidth = 0.1;
        _paceProgress.layer.borderColor = sahara_color.CGColor;
        _paceProgress.layer.shadowRadius = 3;
        _paceProgress.layer.shadowOffset = CGSizeMake(-2.0, -2.0);
        
        _paceProgress.layer.cornerRadius = 5;
    }
    return _paceProgress;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    NSLog(@"speiece  release!!!");
}

@end
