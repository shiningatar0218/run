//
//  PieceCellTableViewCell.h
//  run1.2
//
//  Created by runner on 15/1/6.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivitySplit.h"

@interface PieceCellTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *pieceLabel;
@property (nonatomic, retain) UILabel *totalTimeLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UIProgressView *paceProgress;

- (void)showDataWithModel:(ActivitySplit *)model;

@end
