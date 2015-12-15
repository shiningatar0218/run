//
//  QQLoginViewController.h
//  run1.2
//
//  Created by runner on 15/1/22.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "CustomViewController.h"

@interface QQLoginViewController : CustomViewController


@property (weak, nonatomic) IBOutlet UIView *backgrondView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *password;

- (IBAction)login:(id)sender;
@end
