//
//  TaskDetailViewController.m
//  run1.2
//
//  Created by runner on 15/1/16.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "define.h"
#import "TaskView.h"
#import "MessageManager.h"
#import "TaskMember.h"
#import "TSPopoverController.h"
#import "TSActionSheet.h"
#import "EditTaskViewController.h"
#import "SubTaskViewController.h"

@interface TaskDetailViewController ()

@property (nonatomic, strong) Task *taskModel;

@property (nonatomic, strong) TaskView *taskView;
@property (nonatomic, strong) AdScrollView *adScrollView;
@property (nonatomic, strong) RunnerTableView *runnerTableView;

@property (nonatomic, assign) UserType userType;
@end

@implementation TaskDetailViewController

- (id)initWithUserType:(UserType)user task:(Task *)taskModel{
    if (self = [super init]) {
        self.title = @"详情";
        
        self.userType = user;
        self.taskModel = taskModel;
        [self.view addSubview:self.taskView];
        [self.view addSubview:self.adScrollView];
        [self.view addSubview:self.runnerTableView];

    }
    return self;
}

- (void)requestTaskDetail {
    
    Task *task = self.taskModel;
    
    if (!task.userArray) {
        NSString *name = @"Task/GetMemberList";
        
        NSDictionary *param = @{@"sid": DATAMODEL.sessionId,
                                @"user_id":DATAMODEL.userId,
                                @"task_id":[NSNumber numberWithLongLong:task.task_id],
                                @"is_friend":@"0"};
        
        [[MessageManager getInstance] requestDataName:name param:param completion:^(BOOL sucessful, id objc) {
            if (sucessful) {
                NSLog(@"%@",objc);
                if ([objc isKindOfClass:[NSDictionary class]]) {
                    
                    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
                    
                    for (NSDictionary *dic in objc[@"members"]) {
                        TaskMember *taskMember = [[TaskMember alloc] initWithJsonDictionary:dic];
                        [array addObject:taskMember];
                    }
                    
                    task.userArray = [NSMutableArray arrayWithArray:array];
                    [self.runnerTableView reloadData];
                }
            }
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadTaskData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToPop)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(editOrshare:forEvent:)];
    
}

- (void)editOrshare:(id)sender forEvent:(UIEvent *)event {
    TSActionSheet *actionSheet = [[TSActionSheet alloc] initWithTitle:nil];
    
    actionSheet.bounds = CGRectMake(0, 0, 60, 80);
    [actionSheet addButtonWithTitle:@"分享" block:^{
        
    }];
    [actionSheet addButtonWithTitle:@"编辑" block:^{
        EditTaskViewController *editTaskVC =[[EditTaskViewController alloc] initWithModel:self.taskModel];
        
        [self.navigationController pushViewController:editTaskVC animated:YES];
    }];
    
    [actionSheet addButtonWithTitle:@"实时" block:^{
        
    }];
    
    [actionSheet addButtonWithTitle:@"历史" block:^{
        SubTaskViewController *subTaskList = [[SubTaskViewController alloc] initWithTaskModel:self.taskModel];
        
        [self.navigationController pushViewController:subTaskList animated:YES];
    }];

    actionSheet.cornerRadius = 0;
    
    [actionSheet showWithTouch:event];
}

- (void)loadTaskData {
    [self.taskView layoutData:self.taskModel];
    [self requestTaskDetail];
}

- (RunnerTableView *)runnerTableView {
    if (!_runnerTableView) {
        _runnerTableView = [[RunnerTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.adScrollView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.adScrollView.frame)) style:RunnerListStyleNormol task:self.taskModel];
    }
    return _runnerTableView;
}

- (TaskView *)taskView {
    if (!_taskView) {
        _taskView = [[TaskView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (iPhone4 ? 320 : 375)/3.0)];
    }
    
    return _taskView;
}

- (AdScrollView *)adScrollView {
    if (!_adScrollView) {
        _adScrollView = [[AdScrollView alloc] initWithFrame:CGRectMake(0, self.taskView.frame.size.height, self.view.frame.size.width, self.taskView.frame.size.height+25)];
    }
    
    return _adScrollView;
}

- (void)dealloc {

    NSLog(@"task detaile  release!!");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
