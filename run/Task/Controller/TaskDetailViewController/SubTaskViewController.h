//
//  SubTaskViewController.h
//  run
//
//  Created by runner on 15/2/14.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "CustomViewController.h"
#import "Task.h"

@interface SubTaskViewController : CustomViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) Task *taskModel;
- (instancetype)initWithTaskModel:(Task *)model;
@end
