//
//  ShareTableViewController.m
//  run1.2
//
//  Created by runner on 15/1/27.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "ShareTableViewController.h"
#import "ShareSettingTableViewController.h"
#import "define.h"

@interface ShareTableViewController ()
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *keys;
@end

@implementation ShareTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didChangeValue:(UISwitch *)sender
{
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        return;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    ShareSettingTableViewController *shareSettingTVC = [[ShareSettingTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    NSString *key = self.keys[indexPath.section];
    shareSettingTVC.title = [self.dataDic[key] firstObject];
    
    [self.navigationController pushViewController:shareSettingTVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.titleArray[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataDic[self.keys[section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdenty = @"shareCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenty];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdenty];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 1) {
        UISwitch *description_switch = [[UISwitch alloc] init];
        [description_switch addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
        description_switch.onTintColor = NaVBarColor;
        cell.accessoryView = description_switch;
    }
    NSString *key = self.keys[indexPath.section];
    cell.textLabel.text = [self.dataDic[key] objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSMutableDictionary *)dataDic {
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
        [_dataDic setObject:@[@"不让他(她)看到我的运动记录",@"描述公开"] forKey:self.keys[0]];
        [_dataDic setObject:@[@"不让他(她)看到我参加的任务"] forKey:self.keys[1]];
        [_dataDic setObject:@[@"不让他(她)看到我参加的群组"] forKey:self.keys[2]];
        [_dataDic setObject:@[@"不让他(她)看到我的好友"] forKey:self.keys[3]];
    }
    return _dataDic;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"运动",@"任务",@"群组",@"好友"];
    }
    return _titleArray;
}

- (NSArray *)keys {
    if (!_keys) {
        _keys = @[@"activity_share_switch",@"task_share_switch",@"friend_share_switch",@"group_share_switch"];
    }
    return _keys;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
