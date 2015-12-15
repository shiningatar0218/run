//
//  TaskViewController.m
//  run1.1
//
//  Created by runner on 14/12/30.
//  Copyright (c) 2014年 runner. All rights reserved.
//

#import "TaskViewController.h"
#import "TaskTableViewCell.h"
#import "define.h"
#import "MessageManager.h"
#import "CreatTaskViewController.h"
#import "TaskDetailViewController.h"
#import "TaskMember.h"
#import "MJRefresh.h"

#import "OtherCreatTaskViewController.h"

#define listNumber @4

@interface TaskViewController ()<UITableViewDataSource,UITableViewDelegate,CreateTaskDelegate>
{
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *taskArray;

@end

@implementation TaskViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    NSLog(@"task release!!!");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.taskArray.count <= 0) {
        [self requestTaskData];
    }
}

- (void)requestTaskData {
    NSString *name = @"Task/GetList";
    NSDictionary *param = @{@"session_id":DATAMODEL.sessionId,
                            @"user_id": DATAMODEL.userId,
                            @"start_id":@0,
                            @"direction":@1,
                            @"num":listNumber};
    
    [[MessageManager getInstance] requestDataName:name param:param completion:^(BOOL sucessful, id objc) {
        if (sucessful) {
            NSLog(@"%@",objc);
            NSMutableArray  *taskArray = [[NSMutableArray alloc]initWithCapacity:0];
            for (id item in objc[@"tasks"]) {
                Task *task = [Task taskWithJsonDictionary:item];
                [taskArray addObject:task];
            }
            self.taskArray = taskArray;
            [self.tableView headerEndRefreshing];
            [self.tableView reloadData];
        }else{
            NSLog(@"%@",objc);
        }
    }];
}

- (void)loadMoreTaskData {
    Task *task = [[Task alloc] init];
    if ([self.taskArray.lastObject isKindOfClass:[Task class]]) {
        task = self.taskArray.lastObject;
    }
    NSString *name = @"Task/GetList";
    NSDictionary *param = @{@"session_id":DATAMODEL.sessionId,
                            @"user_id": DATAMODEL.userId,
                            @"start_id":[NSNumber numberWithLongLong:task.task_id],
                            @"direction":@0,
                            @"num":listNumber};
    
    [[MessageManager getInstance] requestDataName:name param:param completion:^(BOOL sucessful, id objc) {
        if (sucessful) {
            NSLog(@"%@",objc);
            NSMutableArray  *taskArray = [[NSMutableArray alloc]initWithCapacity:0];
            for (id item in objc[@"tasks"]) {
                Task *task = [Task taskWithJsonDictionary:item];
                [taskArray addObject:task];
            }
            [self.taskArray addObjectsFromArray:taskArray];
            [self.tableView footerEndRefreshing];
            [self.tableView reloadData];
        }else{
            NSLog(@"%@",objc);
        }
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = RGBCOLOR(239, 239, 244);
    UIButton *rightBar = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightBar setImage:[UIImage imageNamed:@"record_add_friend.png"] forState:UIControlStateNormal];
    [rightBar addTarget:self action:@selector(addTask) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBar];
    self.view = self.tableView;
    
    //下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(requestTaskData)];
    //上拉加载跟多
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreTaskData)];
    
}
//新建任务
- (void)addTask {
    self.hidesBottomBarWhenPushed = YES;
    OtherCreatTaskViewController *creatTaskVC = [[OtherCreatTaskViewController alloc] init];
    creatTaskVC.delegate = self;
    [self.navigationController pushViewController:creatTaskVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

//删除任务
- (void)deleteTask {
    
}

- (NSMutableArray *)taskArray {
    if (!_taskArray) {
        _taskArray = [DataModel getInstance].taskArray;
    }
    return _taskArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(239, 239, 244);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5);
        [_tableView registerClass:[TaskTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

#pragma mark -- UITableViewDelegate/UITableViewDataSourceDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserType userType = Admin_user;
    Task *task = self.taskArray[indexPath.section];
    
    if (task.user_id_creator != [DATAMODEL.userId longLongValue]) {
        userType = General_user;
    }
    
    TaskDetailViewController * taskDetailVC = [[TaskDetailViewController alloc] initWithUserType:userType task:task];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:taskDetailVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.taskArray.count;
    //return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdenty = @"cell";
    
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenty];
    if (!cell) {
        cell = [[TaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenty];
    }
    if ([self.taskArray[indexPath.section] isKindOfClass:[Task class]]) {
        Task *task = self.taskArray[indexPath.section];
        [cell layoutData:task];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (iPhone4 ? 320 : 375)/3.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return iPhone4 ? 5.0 : 8.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

//配置编辑状态的样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
//编辑状态按钮文字
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
//处理提交编辑时的操作(点击删除，添加时；被动调用的方法)
-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark -- createTaskDelegate

- (void)didCreateTask {
    [self requestTaskData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
