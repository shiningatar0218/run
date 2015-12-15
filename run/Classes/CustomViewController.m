
//
//  CustomViewController.m
//  FinalWork
//
//  Created by Geforceyu on 14/10/29.
//  Copyright (c) 2014年 rimi. All rights reserved.
//

#import "CustomViewController.h"
#import "define.h"

@interface CustomViewController ()

@end

@implementation CustomViewController

@synthesize kbSize = kbSize;
@synthesize distance = distance;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        [backItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIColor whiteColor],NSForegroundColorAttributeName,
                                          [UIColor whiteColor],NSUnderlineColorAttributeName,
                                          nil] forState:UIControlStateNormal];
        self.navigationItem.backBarButtonItem = backItem;
        
        
        self.navigationController.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        //[self.navigationController.navigationBar setTintColor:NaVBarColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didloginSucessful {
    
}

- (void)backToPop {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 适应键盘高度
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.keyBoardHeight = kbSize.height;
    [self autokeyboardHight];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y + distance);
    } completion:^(BOOL finished) {
        distance = 0;
        kbSize = CGSizeZero;
        self.currentView = nil;
    }];
}
- (void)autokeyboardHight {
    if (kbSize.height > 0) {
        distance = CGRectGetMaxY(self.currentView.frame)+kbSize.height - CGRectGetHeight(self.view.frame);
        if (distance > 0) {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.center = CGPointMake(self.view.center.x, self.view.center.y - distance);
            } completion:^(BOOL finished) {
                
            }];
        }else {
            distance = 0;
        }
    }
}

- (IBAction)didEditingChanged:(UITextField *)sender {
    
}

- (IBAction)didBeginEditing:(UITextField *)sender {
    self.currentView = sender;
    [self autokeyboardHight];
}

- (IBAction)didEndEditing:(UITextField *)sender {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_endEditingWhenTouch) {
        [self.view endEditing:YES];
    }
    [self.view endEditing:YES];
}

@end
