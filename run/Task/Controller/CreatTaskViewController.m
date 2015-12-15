//
//  CreatTaskViewController.m
//  run1.2
//
//  Created by runner on 15/1/7.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "CreatTaskViewController.h"
#import "PMCalendar.h"
#import "AwardTableView.h"
#import "ReateTableViewController.h"
#import "DoImagePickerController.h"
#import "RulesTableViewController.h"
#import "NSString+Judge.h"
#import "MapViewController.h"
#import "UIDateTimePicker.h"
#import "MessageManager.h"

@interface CreatTaskViewController ()<UITextViewDelegate,PMCalendarControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,DoImagePickerControllerDelegate>
{
    NSString *_begin_date;
    NSString *_begin_time;
    
    NSString *_end_date;
    NSString *_end_time;
    
    TaskTextType currentType;
    UITapGestureRecognizer *tapGesture;
    
    NSMutableArray *_selectPhotos;
    
    CGFloat switchView_hieght;
}

@property (nonatomic, strong) PMCalendarController *calendar;
@property (nonatomic, strong) AwardTableView *awardTableView;
@property (nonatomic, strong) NSMutableArray *repeatWeak;
@property (nonatomic, strong) AwardTableView *publishTypeList;

@end

@implementation CreatTaskViewController

@synthesize creat_task = _creat_task;

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scrolleView.alwaysBounceVertical = YES;
    self.scrolleView.frame = self.view.bounds;
    self.scrolleView.scrollEnabled = YES;
    self.scrolleView.pagingEnabled = NO;

    self.scrolleView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(self.publishButton.frame) > CGRectGetMaxY(self.view.frame) ? CGRectGetMaxY(self.publishButton.frame)+10 : CGRectGetMaxY(self.view.frame));
}

- (Task *)creat_task {
    if (!_creat_task) {
        _creat_task = [[Task alloc] init];
    }
    return _creat_task;
}

- (NSMutableArray *)repeatWeak {
    if (!_repeatWeak) {
        _repeatWeak = [NSMutableArray arrayWithCapacity:0];
    }
    return _repeatWeak;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建任务";
    switchView_hieght = self.switchView.frame.size.height;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToPop)];
    
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesBegan)];
    [self.scrolleView addGestureRecognizer:tapGesture];
}
#pragma mark -- 结束编辑
- (void)didEndEditing:(UITextField *)sender {
    [super didEndEditing:sender];
    self.scrolleView.userInteractionEnabled = YES;
    switch (sender.tag) {
        case taskName:
            self.creat_task.name = sender.text;
            break;
        case TaskDescription:
            self.creat_task.task_description = sender.text;
            break;
            
        case TaskBeginTime:
            _begin_date = sender.text;
            break;
        case TaskEndTime:
            _end_date = sender.text;
            break;
        case StartTime:
            _begin_time = sender.text;
            break;
        case StopTime:
            _end_time = sender.text;
            break;
        case TargetDistance:
            self.creat_task.target_distance = [self.targetDistance.text floatValue];
            if (![sender.text containsString:@"km"] && sender.text.length > 0) {
                sender.text = [NSString stringWithFormat:@"%@km",sender.text];
            }
            break;
        case DistanceRule:
        {
            self.creat_task.integration_rule_distance = [[NSString judgePersentString:self.distanceRule.text] floatValue]/100.0;
            self.creat_task.integration_rule_pace = 1 - self.creat_task.integration_rule_distance;
            NSString *string = [NSString judgePersentString:self.distanceRule.text];
            sender.text = [string addPresent];
            
            self.paceRule.text = [[NSString stringWithFormat:@"%.0lf",100-[string floatValue]] addPresent];
        }
//            if (![sender.text containsString:@"%"]) {
//                sender.text = [NSString stringWithFormat:@"%@%%",[NSString judgePersentString:self.distanceRule.text]];
//            }
            break;
        case PaceRule:
        {
            self.creat_task.integration_rule_pace = [[NSString judgePersentString:self.paceRule.text] floatValue]/100.0;
            self.creat_task.integration_rule_distance = 1 - self.creat_task.integration_rule_pace;
            NSString *string = [NSString judgePersentString:self.paceRule.text];
            sender.text = [string addPresent];
            self.distanceRule.text = [[NSString stringWithFormat:@"%.0lf",100-[string floatValue]] addPresent];
        }
//            if (![sender.text containsString:@"%"]) {
//                sender.text = [NSString stringWithFormat:@"%@%%",[NSString judgePersentString:self.paceRule.text]];
//            }
            break;
        default:
            break;
    }
    [sender resignFirstResponder];
    
}

#pragma mark -- 开始编辑
- (void)didBeginEditing:(UITextField *)sender {
    [super didBeginEditing:sender];
    
    if ([sender.text containsString:@"km"]) {
        
    }
    
    UIDateTimePicker *timePicker = [[UIDateTimePicker alloc] initWithFrame:self.view.bounds];
    
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"HH:mm"];
    
    currentType = (TaskTextType)sender.tag;
    switch (sender.tag) {
        case TaskBeginTime:
            [sender resignFirstResponder];
            [self showCalendar:sender];
            break;
        case TaskEndTime:
            [sender resignFirstResponder];
            [self showCalendar:sender];
            break;
        case StartTime:
        {
            [sender resignFirstResponder];
            [timePicker showPickerInView:self.view didClickButton:^(NSDate *timeDate) {
                sender.text = [dataFormatter stringFromDate:timeDate];
            }];
        }
            break;
        case StopTime:
        {
            [sender resignFirstResponder];
            [timePicker showPickerInView:self.view didClickButton:^(NSDate *timeDate) {
                sender.text = [dataFormatter stringFromDate:timeDate];
            }];
        }
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark -- PMCalendar
- (void)showCalendar:(id)sender
{
    [sender resignFirstResponder];
    _calendar = [[PMCalendarController alloc] init];
    _calendar.delegate = self;
    _calendar.mondayFirstDayOfWeek = YES;
    [self.calendar presentCalendarFromView:sender permittedArrowDirections:PMCalendarArrowDirectionAny animated:YES];
    [self.scrolleView removeGestureRecognizer:tapGesture];
}

- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod {
    if (currentType == TaskBeginTime) {
        self.taskBeginTime.text = [NSString stringWithFormat:@"%@",[newPeriod.startDate dateStringWithFormat:@"dd/MM/yyyy"]];
        self.taskEndTime.text = [NSString stringWithFormat:@"%@",[newPeriod.endDate dateStringWithFormat:@"dd/MM/yyyy"]];
        
        //self.creat_task.begin_time = newPeriod.startDate;

    }else{
        self.taskEndTime.text = [NSString stringWithFormat:@"%@",[newPeriod.startDate dateStringWithFormat:@"dd/MM/yyyy"]];
    }
    
    //self.creat_task.end_time = newPeriod.endDate;
    
    self.creat_task.end_time = self.taskEndTime.text;
    self.creat_task.begin_time = self.taskBeginTime.text;
}

- (void)calendarControllerDidDismissCalendar:(PMCalendarController *)calendarController {
    [self.scrolleView endEditing:YES];
    [self.scrolleView addGestureRecognizer:tapGesture];
}

#pragma mark -- UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (range.length <= 70) {
        if ([text isEqualToString:@"\n"]) {
            return NO;
        }
        self.taskDescription.text = textView.text;
        self.creat_task.task_description = self.taskDescription.text;
        return YES;
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField endEditing:YES];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
//    [self.taskBeginTime becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -- Button点击事件处理
//签到事件
- (IBAction)didClickSwitch:(UISwitch *)sender {
    __block CGRect toFrame = self.switchView.frame;
    if (sender.on) {
        toFrame.size.height = switchView_hieght;
        [UIView animateWithDuration:0.1 animations:^{
            self.switchView.frame = toFrame;
            self.otherView.transform = CGAffineTransformMakeTranslation(self.otherView.frame.origin.x, 0);
        } completion:^(BOOL finished) {
            self.switchView.hidden = NO;
        }];
    }else {
        toFrame.size.height = 0;
        [UIView animateWithDuration:0.1 animations:^{
            self.switchView.frame = toFrame;
            self.otherView.transform = CGAffineTransformMakeTranslation(self.otherView.frame.origin.x, -switchView_hieght);
        } completion:^(BOOL finished) {
            self.switchView.hidden = YES;
        }];
    }
}
//选择奖品
- (IBAction)awardSelected:(UIButton *)sender {
    switch (sender.tag) {
        case AwardName:
            if (self.awardTableView.isShow) {
                [_awardTableView didDismissTableView];
            }else {
                
                [self.awardTableView showTableViewWithFrame:sender.frame inView:self.view didSelectCell:^(NSString *text, id objc) {
                    
                    [self.awardButton setTitle:text forState:UIControlStateNormal];
                    self.creat_task.award_name = text;
                }];
            }
        
            break;
           
        case AwardPicture:
            [self openActipnSheet];//---------选择相片
            break;
        default:
            break;
    }
}
//选择publish范围
- (IBAction)selectedPublishType:(UIButton *)sender {
    
    if (self.publishTypeList.isShow) {
        [self.publishTypeList didDismissTableView];
    }else{
        CGRect frame = CGRectMake(self.otherView.frame.origin.x + self.publishTypeButton.frame.origin.x, self.otherView.frame.origin.y+self.publishTypeButton.frame.origin.y, self.publishTypeButton.frame.size.width, self.publishTypeButton.frame.size.height);
        [self.publishTypeList showTableViewWithFrame:frame inView:self.view didSelectCell:^(NSString *text, id objc) {
            
        }];
    }
    
}
//发布任务
- (IBAction)publishTask:(UIButton *)sender {
//    
//    NSString *name = @"Task/Add";
//    
//    NSArray *keys = @[@"user_id_creator",@"name",@"description",@"begin_time",@"end_time",@"award_name",@"target_distance",@"integration_rule_distance",@"integration_rule_pace"];
//    NSArray *objects = @[@1,
//                         self.creat_task.name,
//                         self.creat_task.task_description,
//                         self.creat_task.begin_time,
//                         self.creat_task.end_time,
//                         self.creat_task.award_name,
//                         self.targetDistance.text,
//                         self.distanceRule.text,
//                         self.paceRule.text];
//    
//    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
//    
//    [[MessageManager getInstance] overDataWithName:name param:param completion:^(BOOL sucessful, id objc) {
//        if (sucessful) {
//            NSLog(@"%@",objc);
//            
//            [self backToPop];
//        }
//    }];
}
//地点，重复，积分规则介绍
- (IBAction)integrationRule:(UIButton *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    switch (sender.tag) {
        case TaskAddress:
        {
            MapViewController *mapVC = [[MapViewController alloc] initWithDidGetAddressBlock:^(NSString *address) {
                self.address.text = address;
            }];
            [self.navigationController pushViewController:mapVC animated:YES];
        }
            break;
        
        case TaskRepeat:
        {
            
            ReateTableViewController *repeatVC = [[ReateTableViewController alloc] initWithSelectWeak:self.repeatWeak Didselected:^(NSMutableArray *selectWeak) {
                self.repeatWeak = selectWeak;
                self.repeat.text = [selectWeak componentsJoinedByString:@"、"];
            }];
            [self.navigationController pushViewController:repeatVC animated:YES];
        }
            
            
            break;
        case TaskRule:
        {
            
            RulesTableViewController *rulesVC = [[RulesTableViewController alloc] init];
            [self.navigationController pushViewController:rulesVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (AwardTableView *)awardTableView {
    if (!_awardTableView) {
        _awardTableView = [[AwardTableView alloc] initWithFrame:self.awardButton.frame style:UITableViewStylePlain];
    }
    return _awardTableView;
}

- (AwardTableView *)publishTypeList {
    
    if (!_publishTypeList) {
        
        CGRect frame = CGRectMake(self.otherView.frame.origin.x + self.publishTypeButton.frame.origin.x, self.otherView.frame.origin.y+self.publishTypeButton.frame.origin.y, self.publishTypeButton.frame.size.width, self.publishTypeButton.frame.size.height);
        NSArray *dataArray = @[@"我的好友",@"群组1",@"群组2"];
        _publishTypeList = [[AwardTableView alloc] initWithFrame:frame style:UITableViewStylePlain dataSrouce:dataArray];
    }
    
    return _publishTypeList;
}

- (void)touchesBegan {
    [super touchesBegan:nil withEvent:nil];
    [self.scrolleView endEditing:YES];
}

#pragma mark -- actionSheet----图片选取
- (void)openActipnSheet {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择相片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
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
    pickerController.nMaxCount = 2;
    
    pickerController.nColumnCount = 3;
    
    [self presentViewController:pickerController animated:YES completion:^{
        
    }];
    
}

#pragma mark -- <DoImagePickerControllerDelegate>
- (void)didCancelDoImagePickerController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    [self dismissViewControllerAnimated:YES completion:nil];
    _selectPhotos = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < aSelected.count; i++) {
        [_selectPhotos addObject:[ASSETHELPER getImageFromAsset:aSelected[i] type:ASSET_PHOTO_SCREEN_SIZE]];
    }
    
    [ASSETHELPER clearData];
}

@end
