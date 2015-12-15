//
//  PersonerCenterViewController.m
//  run1.1
//
//  Created by runner on 14/12/30.
//  Copyright (c) 2014年 runner. All rights reserved.
//

#import "PersonerCenterViewController.h"
#import "define.h"
#import "ChartViewCell.h"
#import "LabelTitle.h"
#import "EditCell.h"
#import "SettingCell.h"
#import "ProfileChangeViewController.h"
#import "PersonerDetailViewController.h"

@interface PersonerCenterViewController ()<ChartViewCellDelegate>
{
    CGFloat profile_Height;
    CGFloat weak_Height;
    CGFloat month_Height;
    CGFloat brief_Height;
    
    NSInteger editCount;
}

@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation PersonerCenterViewController

- (instancetype)init {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        editCount = 0;
        self.enEndit = YES;
        self.tableView.tableHeaderView.backgroundColor = sahara_Gray;
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        [backItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIColor whiteColor],NSForegroundColorAttributeName,
                                          [UIColor whiteColor],NSUnderlineColorAttributeName,
                                          nil] forState:UIControlStateNormal];
        self.navigationItem.backBarButtonItem = backItem;
        
        
        self.navigationController.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    profile_Height = self.view.frame.size.height/4.0;
    weak_Height = profile_Height;
    month_Height = profile_Height;
    brief_Height = profile_Height;
    [self layoutData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self layoutData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorColor = [UIColor clearColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editProfile)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem.backBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.backBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor whiteColor],NSForegroundColorAttributeName,
                                                                  [UIColor whiteColor],NSUnderlineColorAttributeName,
                                                                   nil] forState:UIControlStateNormal];
}
//数据跟新
- (void)layoutData {
    [self.profileView reLoadData];
    [self.tableView reloadData];
}


- (void)editProfile {
    self.hidesBottomBarWhenPushed = YES;
    ProfileChangeViewController *profileCVC = [[ProfileChangeViewController alloc] init];
    [self.navigationController pushViewController:profileCVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        self.hidesBottomBarWhenPushed = YES;
        
        PersonerDetailViewController *personerDVC = [[PersonerDetailViewController alloc] initWithStyle:indexPath.row];
        [self.navigationController pushViewController:personerDVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *identyArray = @[@"barCell",@"lineCell",@"cell"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identyArray[indexPath.section]];
    
    if (indexPath.section <= 1 && indexPath.row == 0) {
        if (!cell) {
            cell = [[ChartViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, weak_Height) UUCharStyle:indexPath.section == 0 ? UUChartBarStyle:UUChartLineStyle];
            
            ((ChartViewCell *)cell).editButton.hidden = !self.enEndit;
            ((ChartViewCell *)cell).delegate = self;
        }
        
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 1){
        if (!cell) {
            cell = [[SettingCell alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width, self.view.frame.size.height - 2*profile_Height)];
        }
        
        return cell;
    }
    else {
        if (!cell) {
            cell = [[EditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            tableView.separatorColor = [UIColor lightGrayColor];
         
        }
        
        ((EditCell *)cell).titleLabel.title = [NSString stringWithFormat:@"%@ ",self.dataArray[indexPath.row]];
    }
    
    return cell;
}


//个人信息
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.profileView;
    }
    
    return nil;
}
//section高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return profile_Height;
    }
    return 5.0;
}


//row高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return 44.0;
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        return self.view.frame.size.height - 2*profile_Height;
    }
    
    return profile_Height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return self.dataArray.count;
    }
    if (section == 0) {
        return 1+editCount;
    }
    
    return 1;
}

- (void)ChartViewCellDidBeginEdit:(BOOL)show_edit {
    if (editCount == 0) {
        editCount = 1;
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:editCount inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        
    }else if (editCount == 1) {
        editCount = 0;
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    }
}

- (ProfileView *)profileView {
    if (!_profileView) {
        _profileView = [[ProfileView alloc] initWithFrame:CGRectMake(2, 0, self.view.frame.size.width-4, profile_Height)];
//        _profileView.layer.borderWidth = 1;
//        _profileView.layer.borderColor = layColor;
//        _profileView.backgroundColor = BackGroundColor;
//        _profileView.alpha = CurrentAlpha;
        //_profileView.backgroundColor = [UIColor yellowColor];
    }
    return _profileView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"运动",@"统计",@"群组",@"路线"];
    }
    
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
