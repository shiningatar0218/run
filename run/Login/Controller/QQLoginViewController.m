//
//  QQLoginViewController.m
//  run1.2
//
//  Created by runner on 15/1/22.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "QQLoginViewController.h"
#import "MessageManager.h"
#import "AppDelegate.h"

@interface QQLoginViewController ()<UITextFieldDelegate>

@end

@implementation QQLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.backgrondView.layer.borderWidth = 1;
    self.backgrondView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.backgrondView.layer.cornerRadius = self.backgrondView.frame.size.height/3.0;
    
    
    self.bottomView.layer.borderWidth = 1;
    self.bottomView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.bottomView.layer.cornerRadius = self.backgrondView.frame.size.height/3.0;
    
}


#pragma mark -- UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] reloadapp];
    
}
@end
