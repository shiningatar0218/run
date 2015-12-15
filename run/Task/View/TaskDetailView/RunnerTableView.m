//
//  RunnerTableView.m
//  run1.2
//
//  Created by runner on 15/1/16.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "RunnerTableView.h"
#import "MessageManager.h"
#import "RunnerListViewCell.h"
#import "Task.h"
#import "TaskMember.h"
#import "define.h"
#import "DVSwitch.h"
#import "CustomButton.h"

@interface RunnerTableView ()<UITableViewDataSource,UITableViewDelegate>
{
    CGRect listbounds;
    CGRect editViewbounds;
    
    __block CustomButton *markButton;
    __block CustomButton *selectAllButton;
    __block CustomButton *delelateButton;
}

@property (nonatomic, strong) UIView *editView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) Task *taskModel;
@property (nonatomic, assign) BOOL selectAll;

@end

@implementation RunnerTableView

- (instancetype)initWithFrame:(CGRect)frame style:(RunnerListStyle)style task:(Task *)taskModel{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectAll = NO;
        listbounds = self.bounds;
        editViewbounds = CGRectMake(0, listbounds.size.height, self.frame.size.width, self.frame.size.height - listbounds.size.height);

        self.taskModel = taskModel;
        self.runnerListStyle = style;
        [self addSubview:self.runnerListView];
    }
    return self;
}

- (void)reloadData {
    [self.runnerListView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"listCell";
    RunnerListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RunnerListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    if (self.runnerListStyle == RunnerListStyleEdit) {
        cell.textLabel.text = @"";
        markButton = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, 40, cell.frame.size.height) NormalImage:nil selectImage:nil whenTouchUpInside:^(id sender){
            
            if ([markButton.backgroundColor isEqual:NaVBarColor]) {
                [markButton setBackgroundColor:[UIColor whiteColor]];
                self.selectAll = NO;
            }else {
                [markButton setBackgroundColor:NaVBarColor];
            }
        }];
        markButton.center = CGPointMake(self.frame.size.width/4.0/2, cell.frame.size.height/2.0);
        markButton.bounds = CGRectMake(0, 0, iPhone4 ? 20 : 30, iPhone4 ? 20 : 30);
        markButton.layer.borderWidth = 1;
        markButton.layer.borderColor = NaVBarColor.CGColor;
        markButton.layer.cornerRadius = iPhone4 ? 10.0 : 15.0;
    
        if (self.selectAll) {
            [markButton setBackgroundColor:NaVBarColor];
        }else {
            [markButton setBackgroundColor:[UIColor whiteColor]];
        }
        
        [cell addSubview:markButton];
    }
    
    [cell loadDataWithModel:self.dataArray[indexPath.row]];
    
    
    return cell;
}

#pragma mark -- headerView

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return iPhone4 ? 60 : 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, iPhone4 ? 60 : 80)];
    headView.backgroundColor = sahara_BackGroundColor;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headView.frame.size.width, 15)];
    titleLabel.text = @"排行榜";
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    DVSwitch *dvSwitch = [[DVSwitch alloc] initWithStringsArray:@[@"所有人",@"好友"]];
    dvSwitch.frame = CGRectMake(0, titleLabel.frame.size.height+5, headView.frame.size.width,headView.frame.size.height - 2*(titleLabel.frame.size.height+5));
    dvSwitch.cornerRadius = iPhone4 ? 10 : 20;
    dvSwitch.backgroundColor = [UIColor clearColor];
    dvSwitch.sliderColor = NaVBarColor;
    
    
    
    NSArray *array = @[@"排名",@"参加人",@"配速",@"距离"];
    if (self.runnerListStyle == RunnerListStyleEdit) {
        array = @[@"",@"参加人",@"配速",@"距离"];
    }
    
    
    for (int i = 0; i < 4; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0+i*headView.frame.size.width/4.0, CGRectGetMaxY(dvSwitch.frame), 60, headView.frame.size.height - CGRectGetMaxY(dvSwitch.frame))];
        
        label.textColor = sahara_Gray;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = array[i];
        
        [headView addSubview:label];
    }
    
    [headView addSubview:dvSwitch];
    [headView addSubview:titleLabel];
    return headView;
}

#pragma mark -- footerView
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.runnerListStyle == RunnerListStyleEdit ? 40 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    
    //footreView.backgroundColor = [UIColor whiteColor];
    
    selectAllButton = [[CustomButton alloc] initWithFrame:CGRectMake(20, 0, 40, footreView.frame.size.height) Title:@"全选" WhenTouchUpinside:^(id sender){
        NSLog(@"select all");
        self.selectAll = !self.selectAll;
        [tableView reloadData];
    }];
    [selectAllButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [footreView addSubview:selectAllButton];
    
    delelateButton = [[CustomButton alloc] initWithFrame:CGRectMake(footreView.frame.size.width - 60, 0, 40, footreView.frame.size.height) Title:@"删除" WhenTouchUpinside:^(id sender){
        NSLog(@"delelate");
        
    }];
    [delelateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [footreView addSubview:delelateButton];
    
    return footreView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = self.taskModel.userArray;
    }
    
    return _dataArray;
}

- (UITableView *)runnerListView {
    if (!_runnerListView) {
        _runnerListView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _runnerListView.delegate = self;
        _runnerListView.dataSource = self;
        _runnerListView.bounces = NO;
        _runnerListView.alwaysBounceVertical = YES;
       // _runnerListView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_runnerListView registerClass:[RunnerListViewCell class] forCellReuseIdentifier:@"listCell"];
    }
    return _runnerListView;
}

- (void)freeBlock {
    markButton.completion = nil;
    selectAllButton.completion = nil;
    delelateButton.completion = nil;
    
    delelateButton = nil;
    selectAllButton = nil;
    markButton = nil;
}

- (void)dealloc {
    self.taskModel = nil;
    NSLog(@"runner list   release!!!");
}


@end
