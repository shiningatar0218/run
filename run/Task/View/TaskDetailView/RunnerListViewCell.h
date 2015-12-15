//
//  RunnerListViewCell.h
//  run1.2
//
//  Created by runner on 15/1/16.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskMember.h"

@interface RunnerListViewCell : UITableViewCell
- (void)loadDataWithModel:(TaskMember *)model;
@end
