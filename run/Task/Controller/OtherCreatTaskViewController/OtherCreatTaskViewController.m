//
//  OtherCreatTaskViewController.m
//  run
//
//  Created by runner on 15/2/10.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "OtherCreatTaskViewController.h"
#import "define.h"
#import "CustomTextField.h"
#import "CustomTextView.h"
#import "CustomSwitch.h"
#import "CustomButton.h"
#import "RulesTableViewController.h"
#import "UIDateTimePicker.h"
#import "MapViewController.h"
#import "ReateTableViewController.h"
#import "NSString+Judge.h"
#import "DoImagePickerController.h"
#import "PhotoScrollerView.h"
#import "TaskTimeCell.h"

#import "DataModel.h"

@interface OtherCreatTaskViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *keys;
@property (nonatomic, retain) NSArray *ruleDSataArray;
@property (nonatomic, retain) NSMutableDictionary *dataDic;
@property (nonatomic, strong) NSMutableArray *repeatWeak;
@property (nonatomic, retain) NSMutableArray *selectPhotos;
@property (nonatomic, strong) NSMutableDictionary *pamar;

@end

@implementation OtherCreatTaskViewController

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"创建任务";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    // Do any additional setup after loading the view.
    self.view = self.tableView;
}

- (void)dealloc {
    NSLog(@"creat task  relsease!!!");
}

//发布任务
- (void)publishTask {
    NSString *name = @"Task/Add";

    [self.pamar setObject:self.ruleDSataArray[0] forKey:@"integration_rule_distance"];
    [self.pamar setObject:self.ruleDSataArray[1] forKey:@"integration_rule_pace"];
    
    [[MessageManager getInstance] overDataWithName:name param:self.pamar completion:^(BOOL sucessful, id objc) {
        if (sucessful) {
            NSLog(@"%@",objc);
            
            NSString *essString = objc[Error_message];
            if (essString) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
                [alertView show];
            }else{
                [self backToPop];
                [self.delegate didCreateTask];
            }
        }
    }];
}

#pragma mark -- 地点，重复，奖品图片

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 2 && indexPath.section != 1) {
        return;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.textLabel.text isEqualToString:@"奖品图片"]) {
        [self openActipnSheet];
    }
    
    if ([cell.textLabel.text isEqualToString:@"签到地点"]) {
        MapViewController *mapVC = [[MapViewController alloc] initWithDidGetAddressBlock:^(NSString *address) {
            cell.detailTextLabel.text = address;
            self.address = address;
            [self.pamar setObject:address forKey:@"sign_address"];
        }];
        [self.navigationController pushViewController:mapVC animated:YES];
    }
    
    if ([cell.textLabel.text isEqualToString:@"重复"]) {
        ReateTableViewController *repeatVC = [[ReateTableViewController alloc] initWithSelectWeak:self.repeatWeak Didselected:^(NSMutableArray *selectWeak) {
            self.repeatWeak = selectWeak;
            cell.detailTextLabel.text = [selectWeak componentsJoinedByString:@"、"];
            [self.pamar setObject:cell.detailTextLabel.text forKey:@"repeat_day"];
        }];
        [self.navigationController pushViewController:repeatVC animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdenty = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenty];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenty];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *key = self.keys[indexPath.section];
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                cell.imageView.image = [UIImage imageNamed:@"task_icon.png"];
                cell.textLabel.text = @"任务名：";
                cell.textLabel.textColor = NaVBarColor;
                
                CustomTextField *nameTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3, 0, self.view.frame.size.width/2, cell.frame.size.height) title:nil titleLenth:0 endEding:^(NSString *text) {
                    NSLog( @"%@",text);
                    [self.pamar setObject:text forKey:@"name"];
                }];
                nameTextField.textFieldText = [self.pamar objectForKey:@"name"];
                [nameTextField didBeginEditing:^(id sender) {
                    
                }];
                
                [cell addSubview:nameTextField];
                return cell;
            }else {
                UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, 35)];
                desLabel.text = @"任务描述（70字以内）";
                CustomTextView *descriptionTextView = [[CustomTextView alloc] initWithFrame:CGRectMake(10, 35, self.view.frame.size.width-20, 60) endEditing:^(NSString *text) {
                    [self.pamar setObject:text forKey:@"description"];
                }];
                descriptionTextView.textView.text = [self.pamar objectForKey:@"description"];
                
                descriptionTextView.textView.font = SYSTEM_14_FONT;
                [cell addSubview:desLabel];
                [cell addSubview:descriptionTextView];
                return cell;
            }
        }
            break;
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell_award"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell_award"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_date"];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell_date"];
                    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [self setTaskDateForCell:cell];
                }
                return cell;
            }
            NSArray *array = self.dataDic[key];
            cell.textLabel.text = array[indexPath.row];
            
            return cell;
        }
            break;
            
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell_switch"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell_switch"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            NSMutableArray *array = self.dataDic[key];
            NSArray *removeArray = @[@"每次任务时间",@"签到地点"];
            cell.textLabel.text = array[indexPath.row];
            //cell.detailTextLabel.text = @"月尽天明";
            
            if (indexPath.row == 0) {
                cell.textLabel.text = @"签到";
                cell.detailTextLabel.text = @"签到时间是任务开始执行后的30分钟内";
                cell.detailTextLabel.font = SYSTEM_12_FONT;
                cell.detailTextLabel.textColor = [UIColor lightGrayColor];
                cell.accessoryView = [[CustomSwitch alloc] initWithValueChanged:^(BOOL on) {
                    if (on) {
                        
                        [self.pamar setObject:@1 forKey:@"system_sign_switch"];
                        
                        [array insertObject:removeArray[0] atIndex:1];
                        [array insertObject:removeArray[1] atIndex:2];
                        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2],[NSIndexPath indexPathForRow:2 inSection:2]] withRowAnimation:UITableViewRowAnimationBottom];
                        
                    }else {
                        
                        [self.pamar setObject:@0 forKey:@"system_sign_switch"];
                        
                        [array removeObjectsInArray:removeArray];
                        [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2],[NSIndexPath indexPathForRow:2 inSection:2]] withRowAnimation:UITableViewRowAnimationTop];
                    }
                    
                }];
                return cell;
            }
            
            if ([cell.textLabel.text isEqualToString:@"签到地点"]) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_address"];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell_address"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                cell.textLabel.text = array[indexPath.row];
                
                return cell;
            }
            
            if ([cell.textLabel.text isEqualToString:@"每次任务时间"]) {
                
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_time"];
                if (!cell) {
                    cell = [[TaskTimeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell_time" inView:self.view];
                }
                cell.textLabel.text = array[indexPath.row];
                return cell;
            }
            
            if (indexPath.row == array.count - 1) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                CustomTextField *target_distance = [[CustomTextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-10, cell.frame.size.height) title:nil titleLenth:0.0 endEding:^(NSString *text) {
                    
                }];
                target_distance.textField.textAlignment = NSTextAlignmentRight;
                target_distance.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                [target_distance didBeginEditing:^(id sender) {
                    if ([target_distance.textField.text containsString:@"km"]) {
                        target_distance.textField.text = [target_distance.textField.text stringByReplacingOccurrencesOfString:@"km" withString:@""];
                    }
                }];
                [target_distance didEndEditing:^(NSString *text) {
                    target_distance.textField.text = [NSString stringWithFormat:@"%@km",text];
                    [self.pamar setObject:target_distance.textField.text forKey:@"sign_address"];
                }];
                [cell addSubview:target_distance];
                return cell;
            }
            return cell;
            
        }
            break;
            
        case 3:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell_rule"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell_rule"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryView = [[CustomButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-30, 0, 30, 30) NormalImage:@"task_help.png" selectImage:@"task_help.png" whenTouchUpInside:^(id sender) {
                    RulesTableViewController *rulesVC = [[RulesTableViewController alloc] init];
                    [self.navigationController pushViewController:rulesVC animated:YES];
                }];
                
                CustomTextField *ruleTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height) title:nil titleLenth:0.0 endEding:^(NSString *text) {
                    
                }];
                ruleTextField.textField.textAlignment = NSTextAlignmentRight;
                ruleTextField.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                ruleTextField.textField.textColor = [UIColor clearColor];
                [ruleTextField didBeginEditing:^(id sender) {
                    if ([ruleTextField.textField.text containsString:@"%"]) {
                        ruleTextField.textField.text = [ruleTextField.textField.text stringByReplacingOccurrencesOfString:@"%" withString:@""];
                    }
                    [ruleTextField clearText];
                }];
                [ruleTextField didEndEditing:^(NSString *text) {
                    
                    NSMutableArray *ruleArray = [NSMutableArray arrayWithObjects:@"rule", nil];
                    [ruleArray insertObject:[NSString judgePersentString:text] atIndex:indexPath.row];
                    [ruleArray removeObject:@"rule"];
                    [ruleArray insertObject:[NSString stringWithFormat:@"%.1f",100 - [[NSString judgePersentString:text] floatValue]] atIndex:(1-indexPath.row)];
                    self.ruleDSataArray = ruleArray;
                    ruleTextField.textField.text = [NSString stringWithFormat:@"%@%%",text];
                    [tableView reloadData];
                }];
                [cell addSubview:ruleTextField];
            }
            
            NSArray *array = self.dataDic[key];
            cell.textLabel.text = array[indexPath.row];
            NSString *detailText = self.ruleDSataArray[indexPath.row];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%%",detailText];
            return cell;
        }
            break;
            
        case 4:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell_public"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell_rule"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = @"发布范围";
            cell.detailTextLabel.text = @"公开";
            
            return cell;
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)setTaskDateForCell:(UITableViewCell *)cell {
    CustomTextField *begin_time_TextField = [[CustomTextField alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width/2-10, cell.frame.size.height) title:@"开始日期" titleLenth:60.0 endEding:^(NSString *text) {
        NSLog(@"%@",text);
        [self.pamar setObject:text forKey:@"begin_time"];
    }];
    CustomTextField *end_time_TextField = [[CustomTextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2-10, cell.frame.size.height) title:@"结束日期" titleLenth:60.0 endEding:^(NSString *text) {
        [self.pamar setObject:text forKey:@"end_time"];
    }];
    
    [begin_time_TextField didBeginEditing:^(id sender) {
        if ([sender isKindOfClass:[CustomTextField class]]) {
            CustomTextField *view = sender;
            [view showCalendarInView:self.view];
            
        }
    }];
    
    [end_time_TextField didBeginEditing:^(id sender) {
        if ([sender isKindOfClass:[CustomTextField class]]) {
            CustomTextField *view = sender;
            [view showCalendarInView:self.view];
        }
    }];
    
    begin_time_TextField.editStyle = EditStyleCalendar;
    end_time_TextField.editStyle = EditStyleCalendar;
    [cell addSubview:begin_time_TextField];
    [cell addSubview:end_time_TextField];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        //显示奖品图片
        if (self.selectPhotos.count > 0) {
            PhotoScrollerView *photoFooterView = [[PhotoScrollerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80) ImageData:self.selectPhotos];
            return photoFooterView;
        }else {
            return nil;
        }
    }
    
    if (section != self.keys.count - 1) {
        return nil;
    }
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    
    CustomButton *addButton = [[CustomButton alloc] initWithFrame:CGRectMake(10, 10, footerView.frame.size.width-20, 60) Title:@"发布" WhenTouchUpinside:^(id sender) {
        NSLog(@"click!");
        [self publishTask];
    }];
    [addButton setBackgroundImage:[UIImage imageNamed:@"task_button_add.png"] forState:UIControlStateNormal];
    [addButton setBackgroundImage:[UIImage imageNamed:@"task_button_add.png"] forState:UIControlStateHighlighted];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerView addSubview:addButton];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 1 && self.selectPhotos.count > 0) {
        return 80.0;
    }
    
    if (section == self.keys.count - 1) {
        return 80.0;
    }
    return 0.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 100.0;
    }
    return 44.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataDic[self.keys[section]] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 5.0;
    }
    return 10.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return @"积分规则";
    }
    return nil;
}



#pragma mark -- actionSheet----图片选取
- (void)openActipnSheet {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择相片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机中选择", nil];
    [sheet addButtonWithTitle:@"拍照"];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            //从相册中选择
            [self openPhoto];
            break;
        case 1:
            //取消
            break;
            
        case 2:
            //拍照
            break;
        default:
            break;
    }
}
#pragma mark -- 打开相册
- (void)openPhoto {
    DoImagePickerController *pickerController = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
    pickerController.delegate = self;
    
    pickerController.nResultType = DO_PICKER_RESULT_ASSET;
    pickerController.nMaxCount = 100;
    
    pickerController.nColumnCount = 2;
    
    [self presentViewController:pickerController animated:YES completion:^{
        
    }];
}

#pragma mark -- <DoImagePickerControllerDelegate>
- (void)didCancelDoImagePickerController {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.selectPhotos removeAllObjects];
    for (int i = 0; i < aSelected.count; i++) {
        [self.selectPhotos addObject:[ASSETHELPER getImageFromAsset:aSelected[i] type:ASSET_PHOTO_SCREEN_SIZE]];
    }
    [self.tableView reloadData];
    [ASSETHELPER clearData];
}
#pragma mark -- property--
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        //_tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView.backgroundColor = [UIColor lightGrayColor];
    }
    return _tableView;
}

- (NSMutableArray *)selectPhotos {
    if (!_selectPhotos) {
        _selectPhotos = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectPhotos;
}

- (NSArray *)keys {
    if (!_keys) {
        _keys = @[@"task_a",@"task_b",@"task_c",@"task_d",@"task_e"];
    }
    return _keys;
}

- (NSMutableDictionary *)dataDic {
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
        NSArray *task_a = @[@1,@2];
        NSMutableArray *task_b = [NSMutableArray arrayWithArray:@[@"0",@"奖品名称",@"奖品图片"]];
        NSMutableArray *task_c = [NSMutableArray arrayWithArray:@[@"签到",@"每次任务时间",@"签到地点",@"重复",@"目标距离"]];
        NSArray *task_d = @[@"距离",@"配速"];
        NSMutableArray *task_e = [NSMutableArray arrayWithArray:@[@"0"]];
        
        [_dataDic setObject:task_a forKey:self.keys[0]];
        [_dataDic setObject:task_b forKey:self.keys[1]];
        [_dataDic setObject:task_c forKey:self.keys[2]];
        [_dataDic setObject:task_d forKey:self.keys[3]];
        [_dataDic setObject:task_e forKey:self.keys[4]];
    }
    return _dataDic;
}

- (NSMutableArray *)repeatWeak {
    if (!_repeatWeak) {
        _repeatWeak = [NSMutableArray arrayWithCapacity:0];
    }
    return _repeatWeak;
}

- (NSArray *)ruleDSataArray {
    if (!_ruleDSataArray) {
        _ruleDSataArray = @[@"50",@"50"];
    }
    return _ruleDSataArray;
}

- (NSMutableDictionary *)pamar {
    if (!_pamar) {
        NSArray *keys = @[@"session_id",@"user_id",@"user_id_creator",@"name",@"description",@"begin_time",@"end_time",@"award_name",@"award_pic_1",@"award_pic_2",@"award_pic_3",@"award_pic_4",@"system_sign_switch",@"system_run_time_begin",@"system_run_time_end",@"sign_address",@"repeat_day",@"target_distance",@"integration_rule_distance",@"integration_rule_pace",@"publish_type",@"notice1",@"notice2",@"publish_value"];
        
        NSArray *objects = @[DATAMODEL.sessionId,DATAMODEL.userId,DATAMODEL.userId,@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@0,@"1",@"1",@"1",@"1",@"1",@"1",@"1",@1,@"1",@"1",@"1"];
        
        _pamar = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    }
    return _pamar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
