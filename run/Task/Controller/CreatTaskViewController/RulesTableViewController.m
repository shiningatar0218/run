//
//  RulesTableViewController.m
//  run1.2
//
//  Created by runner on 15/1/13.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "RulesTableViewController.h"

@interface RulesTableViewController ()
{
    CGFloat _cell_height;
}

@property (nonatomic, retain) NSMutableArray *titleArray;
@property (nonatomic, retain) NSMutableArray *textArray;

@end

@implementation RulesTableViewController

- (instancetype)init {
    if (self == [super init]) {
        self.title = @"解释";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _cell_height = 20.0;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    
    headerView.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, headerView.frame.size.width-20, headerView.frame.size.height)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    if (section == 0) {
        titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    titleLabel.text = [self.titleArray objectAtIndex:section];
    
    [headerView addSubview:titleLabel];
    
    return headerView;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping|NSLineBreakByTruncatingTail;
    }
    cell.textLabel.text = self.textArray[indexPath.section];
    
    CGRect autoRect = [cell.textLabel.text boundingRectWithSize:CGSizeMake(cell.frame.size.width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: cell.textLabel.font} context:nil];
    
    cell.textLabel.bounds = autoRect;
    _cell_height = autoRect.size.height;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cell_height+20;
}


-(NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithArray:@[@"任务内积分规则",@"距离",@"配速",@"年龄和体重"]];
    }
    return _titleArray;
}

- (NSMutableArray *)textArray {
    if (!_textArray) {
        _textArray = [NSMutableArray arrayWithArray:@[@"任务内积分由跑者的年龄、体重指数以及参加任务产生的距离、配速各项得分组成，每项占比由系统管理员设定，每次任务执行满分100分，如果有超过设定目标的任务执行，则按撒哈拉算法会有溢出得分。",@"系统管理员需设定距离目标，每次任务执行，会以该距离目标作为满分。超过该目标有附加分。未达到该距离目标，则以完成的比例来计算本次得分值。",@"配速和跑的距离相关。撒哈拉独有的算法将根据跑友跑步的距离及对应的标准配速，来测算每次任务执行的配速得分。",@"年龄对积分有较大影响。任务积分应除以相应年龄指数。\n体重指数(BMI)对积分规则不同。体重指数对应任务积分的体重系数，任务积分应除以相应体重系数。"]];
    }
    
    return _textArray;
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
