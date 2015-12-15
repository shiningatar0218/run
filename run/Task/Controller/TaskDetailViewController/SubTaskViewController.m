//
//  SubTaskViewController.m
//  run
//
//  Created by runner on 15/2/14.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "SubTaskViewController.h"
#import "define.h"
#import "TaskViewCell.h"

@interface SubTaskViewController ()

@end

@implementation SubTaskViewController

- (instancetype)initWithTaskModel:(Task *)model{
    self = [super init];
    if (self) {
        self.title = @"历史";
        self.taskModel = model;
        self.view = self.tableView;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)dealloc {
    NSLog(@"sub task relseae !!!");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *cellIdenties = @[@"taskCell",@"cell"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenties[indexPath.section]];
    
    if (indexPath.section == 0) {
        if (!cell) {
            cell = [[TaskViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"taskCell"];
        }
        
        [(TaskViewCell *)cell layoutData:self.taskModel];
        
        return cell;
    }
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = @"2014.12.26, 35/100, max 4:20, 9.3km";
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return (iPhone4 ? 320 : 375)/3.0;
    }
    
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count+1;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView.backgroundColor = [UIColor lightGrayColor];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
