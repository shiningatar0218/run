//
//  RegisterViewController.h
//  run1.2
//
//  Created by runner on 15/1/21.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "CustomViewController.h"

@interface RegisterViewController : CustomViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *captchaTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *surePasswordTextField;

- (IBAction)register:(id)sender;
@end
