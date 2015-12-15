//
//  PersonerCenterViewController.h
//  run1.1
//
//  Created by runner on 14/12/30.
//  Copyright (c) 2014年 runner. All rights reserved.
//

#import "CustomViewController.h"
#import "ProfileView.h"
#import "define.h"

@interface PersonerCenterViewController : UITableViewController

@property (nonatomic, strong) ProfileView *profileView;
@property (nonatomic, strong) UIView *weakView;
@property (nonatomic, strong) UIView *weakEditView;
@property (nonatomic, strong) UIView *monthView;
@property (nonatomic, strong) UITableView *briefTableView;

@property (nonatomic, assign) BOOL enEndit;

@end
