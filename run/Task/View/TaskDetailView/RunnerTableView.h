//
//  RunnerTableView.h
//  run1.2
//
//  Created by runner on 15/1/16.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchField.h"
#import "Task.h"

typedef NS_ENUM(NSInteger, RunnerListStyle) {
    RunnerListStyleNormol,
    RunnerListStyleEdit
};

@interface RunnerTableView : UIView

@property (nonatomic, assign) RunnerListStyle runnerListStyle;
@property (nonatomic, strong) UITableView *runnerListView;
@property (nonatomic, strong) SearchField *searchBar;

- (instancetype)initWithFrame:(CGRect)frame style:(RunnerListStyle)style task:(Task *)taskModel;
- (void)reloadData;

- (void)freeBlock;

@end
