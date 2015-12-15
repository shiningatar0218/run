//
//  RecordCell.h
//  run
//
//  Created by runner on 15/2/10.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"

@interface RecordCell : UITableViewCell

@property (nonatomic, strong) UIImageView *mapImage;
@property (nonatomic, strong) UIView *whiterView;

- (void)showDataWithModel:(Activity *)model;

@end
