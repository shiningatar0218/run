//
//  SaveActivityViewController.m
//  run1.2
//
//  Created by runner on 15/1/4.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "SaveActivityViewController.h"
#import "define.h"
#import "ActivityDetailViewController.h"
#import "MarkButton.h"
#import "DataModel.h"
#import "CoreDataManager.h"
#import "AppDelegate.h"

@interface SaveActivityViewController ()
{
    
    NSMutableArray *_mkButtons;
}

@end

@implementation SaveActivityViewController

@synthesize delegate;

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"储存";
    self.ATDescription.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"继续" style:UIBarButtonItemStylePlain target:self action:@selector(backToPop)];
    
    [self initRouteScrollView];
}

- (void)initRouteScrollView {
    
    _mkButtons = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSArray *titleArray = @[@"湖边",@"空气好",@"郊外",@"海边",@"树林",@"体育场",@"车多",@"人多",@"山上",@"野路",@"公园",@"小区"];
    
    CGFloat mark_button_hight = iPhone4 ? 210/3 :(iPhone6 ? self.scrollView.frame.size.height/3 : 280/3);
    CGFloat mark_button_with = kMainScreenWidth/4;
    
    for (int i = 0; i < 3; i ++) {
        for (int j = 0; j < 4; j ++) {
            MarkButton *routeButton = [[MarkButton alloc] initWithFrame:CGRectMake(j*(mark_button_with), 5+i*(mark_button_hight), mark_button_with ,mark_button_hight) title:titleArray[i*4+j]];
            
            [self.scrollView addSubview:routeButton];
            [_mkButtons addObject:routeButton];
        }
    }
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, mark_button_hight*3)];
}

- (void)backToPop {
    [super backToPop];
    [delegate goingOnActivity:ActivityStart];
}
//保存activity到服务器
- (void)saveActivity {
    DATAMODEL.activitying = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:CutMapPicture object:nil];
    
    [DataModel getInstance].activity.name = self.ATName.text;
    [DataModel getInstance].activity.activity_description = self.ATDescription.text;
    //[DataModel getInstance].activity.create_time =
    if (!DATAMODEL.isLogin) {
        UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UIViewController *bloginVC = [loginStoryboard instantiateViewControllerWithIdentifier:@"nlogin"];
        //[self presentViewController:bloginVC animated:YES completion:nil];
        [[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] setRootViewController:bloginVC];
        return;
    }
    
    DATAMODEL.activity.pace = [NSNumber numberWithDouble:[DATAMODEL.activity.total_time doubleValue]/[DATAMODEL.activity.total_distance doubleValue]*1000.0];
    
    [CoreDataManager saveDataToPersistentStoreWithEntity:[DataModel getInstance].activity Completion:^(BOOL contextDidSave, NSError *error) {
        if (contextDidSave) {
            NSLog(@"save");
        }else {
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    [[DataModel getInstance] saveActivityToServers:^(BOOL sucessful) {
        //[self.navigationController popToRootViewControllerAnimated:NO];
        [self.navigationController popToRootViewControllerAnimated:NO];
        self.hidesBottomBarWhenPushed = NO;
        [delegate didSaveActivity:ActivityStop];
    }];
}

#pragma mark -- UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentView = textField;
    [self autokeyboardHight];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [DataModel getInstance].activity.name = self.ATName.text;
    [DataModel getInstance].activity.activity_description = self.ATDescription.text;
}

#pragma mark -- UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 事件处理
- (IBAction)routeSwitch:(UISwitch *)sender {
    self.scrollView.hidden = !sender.on;
    self.saveButton.hidden = sender.on;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"储存" style:UIBarButtonItemStylePlain target:self action:@selector(saveRoute)];
}

- (IBAction)shareSwitch:(UISwitch *)sender {
}

- (IBAction)clickButton:(UIButton *)sender {
    [self saveActivity];
}

- (void)saveRoute {
    
}
@end
