//
//  SettingViewController.m
//  run1.1
//
//  Created by runner on 14/12/30.
//  Copyright (c) 2014年 runner. All rights reserved.
//

#import "SettingViewController.h"
#import "ShareTableViewController.h"
#import "define.h"
#import "AppDelegate.h"
#import "DataModel.h"
#import "CoreDataManager.h"
#import "CustomButton.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *keys;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = self.tableView;
    
}


- (void)didChangeValue:(UISwitch *)sender {
    if (sender.tag == 7005) {
        //自动暂停
    }
    
    if (sender.tag == 7006) {
        //运动时常亮
        [[UIApplication sharedApplication] setIdleTimerDisabled:sender.on];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.keys[indexPath.row] isEqualToString:@"share"]) {
        
        self.hidesBottomBarWhenPushed = YES;
        ShareTableViewController *shareTVC = [[ShareTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        shareTVC.title = self.dataArray[indexPath.section];
        [self.navigationController pushViewController:shareTVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80.0)];
    
    CustomButton *logoutButton = [[CustomButton alloc] initWithFrame:footerView.bounds Title:@"退出" WhenTouchUpinside:^(id sender) {
        
        [[DataModel getInstance] logoutFromServers];
        
    }];
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"task_button_add.png"] forState:UIControlStateNormal];
    [logoutButton setCenter:CGPointMake(footerView.frame.size.width/2.0, footerView.frame.size.height/2.0)];
    [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  
    [logoutButton setBounds:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    [footerView addSubview:logoutButton];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdety = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdety];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdety];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = @"公里";
    }
    
    if (indexPath.row == 5 || indexPath.row == 6) {
        UISwitch *autoSwitch = [[UISwitch alloc] init];
        [autoSwitch addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
        autoSwitch.onTintColor = NaVBarColor;
        autoSwitch.on = NO;
        autoSwitch.tag = 7000+indexPath.row;
        cell.accessoryView = autoSwitch;
    }
    
    if (indexPath.row == self.dataArray.count - 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.center = CGPointMake(cell.frame.size.width/2.0, cell.textLabel.center.y);
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
        
        [_dataArray addObject:@"链接到其他服务器"];
        [_dataArray addObject:@"长度单位"];
        [_dataArray addObject:@"辅助设备"];
        [_dataArray addObject:@"语音播报"];
        [_dataArray addObject:@"消息通知"];
        [_dataArray addObject:@"自动暂停"];
        [_dataArray addObject:@"运动时屏幕常亮"];
        [_dataArray addObject:@"隐私"];
        [_dataArray addObject:@"网络设置"];
        //[_dataArray addObject:@"退出登陆"];
    }
    return _dataArray;
}

- (NSMutableArray *)keys {
    if (!_keys) {
        _keys = [NSMutableArray arrayWithObjects:@"contect_to_otherSevers",
                 @"length_unit",
                 @"other_device",
                 @"activity_sound_switch",
                 @"message_notification",
                 @"auto_pause_switch",
                 @"screen_on_switch",
                 @"share",
                 @"internet_setting",
                 nil];
    }
    return _keys;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
