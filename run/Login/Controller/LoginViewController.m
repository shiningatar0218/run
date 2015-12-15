//
//  LoginViewController.m
//  run
//
//  Created by runner on 15/2/2.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "LoginViewController.h"
#import "define.h"
#import "AppDelegate.h"
#import "User.h"
#import "DataModel.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)loginButton:(id)sender;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nameTextField.layer.borderColor = [UIColor redColor].CGColor;
    self.nameTextField.layer.shadowColor = [UIColor redColor].CGColor;
    self.nameTextField.layer.shadowOpacity = 0.8;
    self.nameTextField.layer.shadowOffset = CGSizeMake(0, 1);
    self.nameTextField.layer.borderWidth = 0.0;
    
    self.passwordTextField.layer.borderColor = [UIColor redColor].CGColor;
    self.passwordTextField.layer.shadowColor = [UIColor redColor].CGColor;
    self.passwordTextField.layer.shadowOpacity = 0.8;
    self.passwordTextField.layer.shadowOffset = CGSizeMake(0, 1);
    self.passwordTextField.layer.borderWidth = 0.0;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Start_Login object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.layer.borderWidth = 0.0;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        return NO;
    }
    
    return YES;
}

- (IBAction)loginButton:(id)sender {
    
    NSMutableDictionary *pamara = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [pamara setObject:self.nameTextField.text forKey:@"name"];
    [pamara setObject:self.passwordTextField.text forKey:@"password"];
    [pamara setObject:@0 forKey:@"login_type"];
    
    [self loginApp:pamara];
}

- (void)loginApp:(NSMutableDictionary *)pamara {
    NSString *name = @"User/Login";
    [[MessageManager getInstance] requestDataName:name param:pamara completion:^(BOOL sucessful, id objc) {
        if (sucessful) {
            
            NSString *errString = objc[@"err_msg"];
            if (errString) {
                if ([objc[@"err_code"] longValue] == 1000) {
                    self.nameTextField.layer.borderWidth = 1.0;
                }else if ([objc[@"err_code"] longValue] == 1001){
                    self.passwordTextField.layer.borderWidth = 1.0;
                }
                
                return;
            }
            DATAMODEL.isLogin = YES;
            NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:pamara forKey:Login_Message];
            NSDictionary *dic = objc[@"user"];
            
            NSArray *array = [User MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"name IN %@",@[dic[@"name"]]]];
            
            if (array.count == 0) {
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
                
                [DATAMODEL saveUserProfileWithPama:objc[@"user"][@"profile"] Completion:^(BOOL isSave) {
                    if (isSave) {
                        NSLog(@"profile  save");
                    }
                }];
                
            }else {
                User *user = [array firstObject];
                user.session_id = objc[@"session_id"];
                
                NSManagedObjectContext *context = user.managedObjectContext;
                [context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
                    if (contextDidSave) {
                        NSLog(@"save");
                    }
                }];
            }
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] reloadapp];
        }

        
            
    }];
}
@end
