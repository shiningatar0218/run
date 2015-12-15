//
//  TaskDetailViewController.h
//  run1.2
//
//  Created by runner on 15/1/16.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "CustomViewController.h"
#import "TJProgressView.h"
#import "LabelTitle.h"
#import "DataModel.h"
#import "TaskView.h"
#import "AdScrollView.h"
#import "RunnerTableView.h"

typedef NS_ENUM(int, UserType) {
    Admin_user = 1,
    General_user = 0
};

@interface TaskDetailViewController : CustomViewController
- (id)initWithUserType:(UserType)user task:(Task *)taskModel;

@end
