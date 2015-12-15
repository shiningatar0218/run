//
//  EditTaskViewController.m
//  run1.2
//
//  Created by runner on 15/1/19.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "EditTaskViewController.h"
#import "CustomButton.h"
#import "define.h"
#import "MapViewController.h"
#import "TaskTimeCell.h"
#import "LabelTitle.h"
#import "LineView.h"
#import "RunnerTableView.h"

@interface EditTaskViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    CustomButton *_addButton;
    CustomButton *editButton;
    CustomButton *delelateButton;
    LabelTitle *noticeLFiled;
}

@property (nonatomic, assign) NSInteger noticeCount;
@property (nonatomic, strong) Task *taskModel;
@property (nonatomic, strong) UILabel *taskTitle;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, retain) RunnerTableView *runnerListView;

@end

@implementation EditTaskViewController

@synthesize taskModel = _taskModel;

- (instancetype)initWithModel:(Task *)model {
    if (self = [super init]) {
        self.title = @"编辑";
        self.taskModel = model;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.runnerListView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _addButton.completion = nil;
    editButton.completion = nil;
    delelateButton.completion = nil;
    noticeLFiled.didendEditing = nil;
    noticeLFiled.didBeginEditing = nil;
//    _addButton.completion = nil;

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    NSArray *cellArray = @[@"noticeCell",@"addCell",@"addressCell",@"timeCell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellArray[indexPath.section]];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section == 0) {
        
//        cell = [tableView dequeueReusableCellWithIdentifier:cellArray[indexPath.section]];
//        
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"noticeCell"];
//        }
        
        noticeLFiled = [[LabelTitle alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width/3.0*2, 25) title:[NSString stringWithFormat:@"公告%d:",indexPath.row + 1] placeholder:@"关于签到规则和通知"];
        noticeLFiled.tag = 1000;
        [cell addSubview:noticeLFiled];
        noticeLFiled.center = CGPointMake(noticeLFiled.center.x, cell.frame.size.height/2.0);
        
        //noticeLFiled.textField.font = [UIFont systemFontOfSize:12];
        editButton = [[CustomButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(noticeLFiled.frame), 0, cell.frame.size.height, 25) NormalImage:@"task_edit_unpress.png" selectImage:@"task_edit_press.png" whenTouchUpInside:^(id sender){
            [noticeLFiled.textField becomeFirstResponder];
            [sender setImage:[UIImage imageNamed:@"task_edit_press.png"] forState:UIControlStateNormal];
        }];
        editButton.center = CGPointMake(editButton.center.x, cell.frame.size.height/2.0);
        
        delelateButton = [[CustomButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(editButton.frame), 0, cell.frame.size.height, 25) NormalImage:@"button_delete_normal.png" selectImage:@"button_delete_press.png" whenTouchUpInside:^(id sender){
            
            if (self.noticeCount >= 2) {
                self.noticeCount --;
                //[self scrollUpCellHiegt];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                
            }else if (self.noticeCount == 1){
                noticeLFiled.text = @"";
            }
            
            [tableView reloadData];
        }];
        delelateButton.center = CGPointMake(delelateButton.center.x, cell.frame.size.height/2.0);

        [cell addSubview:editButton];
        [cell addSubview:delelateButton];
        
        [noticeLFiled didBeginEditing:^{
            [editButton setImage:[UIImage imageNamed:editButton.selectImage] forState:UIControlStateNormal];
        }];
        
        [noticeLFiled didendEditing:^(NSString *text) {
            [editButton setImage:[UIImage imageNamed:editButton.normalImage] forState:UIControlStateNormal];
        }];
        
        noticeLFiled.textLabel.text = [NSString stringWithFormat:@"公告%ld:",indexPath.row + 1];
        return cell;
    }

    
        cell = [tableView dequeueReusableCellWithIdentifier:cellArray[indexPath.section]];
        
        if (indexPath.section == 1) {
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addCell"];
                tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                _addButton = [[CustomButton alloc] initWithFrame:CGRectMake(20, 0, 40, cell.frame.size.height) Title:@"添加" WhenTouchUpinside:^(id sender){
                    self.noticeCount ++;
                    [tableView reloadData];
                    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.noticeCount - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    
                }];
                
                [cell addSubview:_addButton];
                
            }
            return cell;
        }
        
        if (indexPath.section == 2) {
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"addressCell"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.textLabel.text = @"签到地址";
            
            return cell;
        }
    
        if (indexPath.section == 3) {
            
            if (!cell) {
                cell = [[TaskTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timeCell" inView:self.view];
                
                cell.textLabel.text = @"任务时间";
            }
            return cell;
        }
        return cell;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        MapViewController *mapVC = [[MapViewController alloc] initWithDidGetAddressBlock:^(NSString *address) {
            cell.detailTextLabel.text = address;
            
        }];
        [self.navigationController pushViewController:mapVC animated:YES];
    }else if (indexPath.section == 1){
        self.noticeCount ++;
        [tableView reloadData];
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.noticeCount - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else{
        return;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return nil;
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headerView.frame.size.width-60, headerView.frame.size.height)];
    titleLabel.text = self.taskModel.name;
    headerView.backgroundColor = sahara_Gray;
    
    CustomButton *helpButton = [[CustomButton alloc] initWithFrame:CGRectMake(headerView.frame.size.width - 60, 0, headerView.frame.size.height, headerView.frame.size.height) NormalImage:@"task_help_2.png" selectImage:nil whenTouchUpInside:^(id sender) {
        NSLog(@"help");
    }];
    
    
    
    [headerView addSubview:titleLabel];
    [headerView addSubview:helpButton];
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.noticeCount;
    }
    return 1;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 40.0;
    }
    return 0.1;
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)noticeCount {
    if (_noticeCount == 0) {
        _noticeCount = 1;
    }
    return _noticeCount;
}

- (RunnerTableView *)runnerListView {
    if (!_runnerListView) {
        _runnerListView = [[RunnerTableView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 200) style:RunnerListStyleEdit task:self.taskModel];
    }
    return _runnerListView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44*5) style:UITableViewStyleGrouped];
        //_tableView.rowHeight = 30;
        //_tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView.backgroundColor = [UIColor lightGrayColor];
        _tableView.separatorColor = [UIColor lightGrayColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    return _tableView;
}

- (UILabel *)taskTitle {
    if (!_taskTitle) {
        _taskTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,20)];
        _taskTitle.textAlignment = NSTextAlignmentCenter;
        _taskTitle.font = BOLD_18_FONT;
        _taskTitle.text = self.taskModel.name;
    }
    return _taskTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [self.runnerListView freeBlock];
    self.runnerListView = nil;
    NSLog(@"edit task release!!");
}

@end
