//
//  ProfileChangeViewController.h
//  run1.2
//
//  Created by runner on 15/1/23.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "CustomViewController.h"

@interface ProfileChangeViewController : CustomViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end
