//
//  CountTableView.h
//  run1.2
//
//  Created by runner on 15/1/26.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserStatistics.h"

@interface CountTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UserStatistics *model;

@end
