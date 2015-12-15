//
//  AnalysisCell.m
//  run
//
//  Created by runner on 15/3/9.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "AnalysisCell.h"
#import "CustomButton.h"
#import "define.h"
#import "AltitudeView.h"
#import "PaceView.h"
#import "LabelTitle.h"
#import "FileDataModel.h"

@interface AnalysisCell ()
{
    CGFloat button_Height;
    
    FileDataModel *_fileModel;
}
@property (nonatomic, retain) CustomButton *leftButton;
@property (nonatomic, retain) CustomButton *rightButton;
@property (nonatomic, retain) UIView *lineView;

@property (nonatomic, retain) AltitudeView *altitudeView;
@property (nonatomic, retain) PaceView *paceView;

@property (nonatomic, retain) LabelTitle *leftLabel;
@property (nonatomic, retain) LabelTitle *rightLabel;

@property (nonatomic, assign) AnalysisDataType type;

@end

@implementation AnalysisCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.type = AltitudeType;
        button_Height = 40.0;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.frame = CGRectMake(0, 0, kMainScreenWidth, (kMainScreenHeight-64.0)/3.0*2-80);
        
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        [self addSubview:[LineView LineViewWithFrame:CGRectMake(0, self.leftButton.frame.size.height, self.frame.size.width, 2) color:sahara_BackGroundColor]];
        [self addSubview:self.lineView];
        
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
    }
    return self;
}

- (void)showDataWithModel:(Activity *)model {
    
    _fileModel = [[FileDataModel alloc] init];
    
    [_fileModel getFileDataModelWith:model];
    
    __weak AnalysisCell *weakSelf = self;
    __block CGFloat buttonHeight = buttonHeight;
    
    [_fileModel setBlockWithReturnBlock:^(id returnValue) {
        
        switch (weakSelf.type) {
            case DataPaceType:
                weakSelf.paceView = [[PaceView alloc] initWithFrame:CGRectMake(0, 40, weakSelf.frame.size.width, weakSelf.frame.size.height - 40*2) ChartData:returnValue];
                break;
             
            case AltitudeType:
                weakSelf.altitudeView = [[AltitudeView alloc] initWithFrame:CGRectMake(0, 40, weakSelf.frame.size.width, weakSelf.frame.size.height - 40*2) ChartData:returnValue];
                
                if (![weakSelf.subviews containsObject:weakSelf.altitudeView]) {
                    [weakSelf addSubview:weakSelf.altitudeView];
                }
                
                break;
            default:
                break;
        }
        
    } WithFailureBlock:^(id failureBlock) {
        
    }];
    
    if (self.type == AltitudeType) {
        [_fileModel getAltitudeData];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (LabelTitle *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[LabelTitle alloc] initWithFrame:CGRectMake(10, self.frame.size.height-button_Height, self.frame.size.width/2.0-10, button_Height) title:@"平均海拔" text:@"25.0m" textColor:nil];
        
    }
    
    return _leftLabel;
}

- (LabelTitle *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[LabelTitle alloc] initWithFrame:CGRectMake(self.frame.size.width/2.0+10, self.frame.size.height-button_Height, self.frame.size.width/2.0-10, button_Height) title:@"最高海拔" text:@"45m" textColor:nil];
    }
    
    return _rightLabel;
}

- (AltitudeView *)altitudeView {
    if (!_altitudeView) {
        _altitudeView = [[AltitudeView alloc] initWithFrame:CGRectMake(0, button_Height, self.frame.size.width, self.frame.size.height - button_Height*2) ChartData:nil];
    }
    
    return _altitudeView;
}

- (PaceView *)paceView {
    if (!_paceView) {
        _paceView = [[PaceView alloc] initWithFrame:CGRectMake(0, button_Height, self.frame.size.width, self.frame.size.height - button_Height*2) ChartData:nil];
    }
    return _paceView;
}

- (CustomButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2.0, 40) Title:@"海拔" WhenTouchUpinside:^(id sender) {
            CustomButton *button = sender;
            
            [UIView animateWithDuration:0.2 animations:^{
                [button setTitleColor:sahara_color forState:UIControlStateNormal];
                self.lineView.center = CGPointMake(button.center.x, self.lineView.center.y);
                [_rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            } completion:^(BOOL finished) {
                
                if (![self.subviews containsObject:self.altitudeView]) {
                    [self addSubview:self.altitudeView];
                }
                
                if ([self.subviews containsObject:self.paceView]) {
                    [self.paceView removeFromSuperview];
                }
                
                self.leftLabel.title = @"平均海拔";
                self.rightLabel.title = @"最高海拔";
            }];
            self.type = AltitudeType;
        }];
        
        [_leftButton setTitleColor:sahara_color forState:UIControlStateNormal];
    }
    return _leftButton;
}

- (CustomButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[CustomButton alloc] initWithFrame:CGRectMake(_leftButton.frame.size.width, 0, self.frame.size.width/2.0, 40) Title:@"配速" WhenTouchUpinside:^(id sender) {
            
            [UIView animateWithDuration:0.2 animations:^{
                CustomButton *button = sender;
                [button setTitleColor:sahara_color forState:UIControlStateNormal];
                self.lineView.center = CGPointMake(button.center.x, self.lineView.center.y);
                [_leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            } completion:^(BOOL finished) {
                if (![self.subviews containsObject:self.paceView]) {
                    [self addSubview:self.paceView];
                }
                
                if ([self.subviews containsObject:self.altitudeView]) {
                    [self.altitudeView removeFromSuperview];
                }
                self.leftLabel.title = @"平均配速";
                self.rightLabel.title = @"最快配速";
            }];
            self.type = DataPaceType;
            [_fileModel getPaceData];
            
        }];
        [_rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    return _rightButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.leftButton.frame.size.height-3, self.frame.size.width/2.0, 3)];
        
        _lineView.center = CGPointMake(_leftButton.frame.size.width/2.0, _lineView.center.y);
        _lineView.backgroundColor = sahara_color;
    }
    return _lineView;
}


- (void)dealloc {
    NSLog(@"AnalysisCell  release!!");
}

@end
