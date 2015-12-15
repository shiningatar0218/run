//
//  ReportViewController.m
//  run1.2
//
//  Created by runner on 15/1/6.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "ReportViewController.h"
#import "ImageLabel.h"
#import "define.h"
#import "CustomButton.h"
#import "RecordCell.h"
#import "DetailRecordViewController.h"
#import "DataModel.h"
#import "MJRefresh.h"

#define ActivitysNumber @3

@interface ReportViewController ()<UITableViewDataSource,UITableViewDelegate>
{

}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataArray;


@end

@implementation ReportViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.dataArray.count <= 0) {
        [self requestActivityData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)showDataWith:(Activity *)model {
    
}

- (void)dealloc {
    NSLog(@" record release!!! ");
}

- (void)requestActivityData {
    
    NSDictionary *parma = @{@"session_id": DATAMODEL.sessionId,
                            @"user_id":DATAMODEL.userId,
                            @"start_id":@0,
                            @"direction":@1,
                            @"num":ActivitysNumber};
    
    [DATAMODEL requestActivityWithParma:parma Completion:^(BOOL sucessful, id objc) {
        if (sucessful) {
            NSLog(@"%@",objc);
            NSMutableArray *activityList = [[NSMutableArray alloc] initWithCapacity:0];
            
            for (id item in objc) {
                
                if (![item isKindOfClass:[NSDictionary class]]) {
                    return;
                }
                Activity *activity = [Activity activityWithJsonDictionary:item];
                [activityList addObject:activity];
            }
            
            self.dataArray = activityList;
            [self.tableView reloadData];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        [self.tableView headerEndRefreshing];
    }];
}

- (void)loadMoreActivityData {
    
    if (self.dataArray.count <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有跟多数据了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [self.tableView footerEndRefreshing];
        return;
    }
    
    NSDictionary *parma = @{@"session_id": DATAMODEL.sessionId,
                            @"user_id":DATAMODEL.userId,
                            @"start_id":[self.dataArray.lastObject activity_id],
                            @"direction":@0,
                            @"num":ActivitysNumber};
    
    [DATAMODEL requestActivityWithParma:parma Completion:^(BOOL sucessful, id objc) {
        if (sucessful) {
            NSLog(@"%@",objc);
            NSMutableArray *activityList = [[NSMutableArray alloc] initWithCapacity:0];
            
            for (id item in objc) {
                
                if (![item isKindOfClass:[NSDictionary class]]) {
                    return;
                }
                Activity *activity = [Activity activityWithJsonDictionary:item];
                [activityList addObject:activity];
                
            }
            
            [self.dataArray addObjectsFromArray:activityList];
            [self.tableView reloadData];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        [self.tableView footerEndRefreshing];
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.automaticallyAdjustsScrollViewInsets = NO;
    self.view = self.tableView;
    
    //下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(requestActivityData)];
    //上拉加载跟多
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreActivityData)];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.hidesBottomBarWhenPushed = YES;
    DetailRecordViewController *detailRecordVC = [[DetailRecordViewController alloc] initWithModel:self.dataArray[indexPath.section]];
    [self.navigationController pushViewController:detailRecordVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    imageView.layer.cornerRadius = 20.0;
    imageView.clipsToBounds = YES;
    imageView.layer.borderColor = [UIColor orangeColor].CGColor;
    imageView.layer.borderWidth = 0.5;
    imageView.image = [UIImage imageNamed:@"my_icon_man.png"];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60, 0, 60, headerView.frame.size.height)];
    timeLabel.textAlignment = NSTextAlignmentCenter;

    ImageLabel *titleLabel = [[ImageLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame), 0, self.view.frame.size.width - CGRectGetMaxX(imageView.frame) - timeLabel.frame.size.width, headerView.frame.size.height)];
    titleLabel.image = [UIImage imageNamed:@"record_run.png"];
    
    if (self.dataArray.count > 0) {
        Activity *activity = self.dataArray[section];
        [self showDataWith:activity];
        titleLabel.title = activity.name;
        titleLabel.text = [NSString stringWithFormat:@"%.3f公里",[activity.total_distance doubleValue]/1000];
        timeLabel.text = activity.create_time;
    }
    
    [headerView addSubview:imageView];
    [headerView addSubview:timeLabel];
    [headerView addSubview:titleLabel];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdenty = @"recordCell";
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenty];
    if (!cell) {
        cell = [[RecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenty];
    }
    
    [cell showDataWithModel:self.dataArray[indexPath.section]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 200.0;
//}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionHeaderHeight = 60.0;
        _tableView.rowHeight = iPhone4 ? 160*0.8 : 160.0;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
