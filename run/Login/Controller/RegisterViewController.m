//
//  RegisterViewController.m
//  run1.2
//
//  Created by runner on 15/1/21.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "RegisterViewController.h"
#import "define.h"
#import "User.h"
#import "DataModel.h"
#import "AppDelegate.h"

@interface RegisterViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    NSMutableDictionary *pamara;
}

@end

@implementation RegisterViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    pamara = [NSMutableDictionary dictionaryWithCapacity:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        return NO;
    }
    
    return YES;
}

- (IBAction)register:(id)sender {
    NSString *name = @"User/Register";
    
    pamara = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [pamara setObject:self.nameTextField.text forKey:@"name"];
    [pamara setObject:self.passwordTextField.text forKey:@"password"];
    [pamara setObject:@"0" forKey:@"login_type"];
    
    [[MessageManager getInstance] overDataWithName:name param:pamara completion:^(BOOL sucessful, id objc) {
        if (sucessful) {
            NSString *errString = [objc objectForKey:@"err_msg"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            if (!errString) {
                [alertView show];
            }else {
                alertView.message = errString;
                [alertView show];
            }
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if ([alertView.message isEqualToString:@"注册成功"]) {
        [self loginApp];
    }

}

- (void)loginApp {
    NSString *name = @"User/Login";
    [[MessageManager getInstance] requestDataName:name param:pamara completion:^(BOOL sucessful, id objc) {
        if (sucessful) {
            
            NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:pamara forKey:Login_Message];
            NSDictionary *dic = objc[@"user"];
            
            NSString *errString = objc[@"err_msg"];
            
            if (errString) {
                return;
            }
            
           
            DATAMODEL.isLogin = YES;
            User *user = [User MR_createEntity];
            user.name = dic[@"name"];
            user.login_type = [NSNumber numberWithString:dic[@"login_type"]];
            user.user_id = [NSNumber numberWithString:dic[@"user_id"]];
            user.session_id = objc[@"session_id"];
            
            NSManagedObjectContext *context = user.managedObjectContext;
            [context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
                if (contextDidSave) {
                    NSLog(@"save");
                }
            }];
            
            [DATAMODEL saveUserProfileWithPama:dic[@"profile"] Completion:^(BOOL isSave) {
                if (isSave) {
                    NSLog(@"profile  save");
                }
            }];
            
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] reloadapp];
        }
    }];

}
@end
