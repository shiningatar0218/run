//
//  SaveActivityViewController.h
//  run1.2
//
//  Created by runner on 15/1/4.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "define.h"
@protocol SaveActivityViewControllerDelegate <NSObject>

- (void)goingOnActivity:(ActivityStateType)type;

- (void)didSaveActivity:(ActivityStateType)type;

@end

@interface SaveActivityViewController : CustomViewController<UITextFieldDelegate,UITextViewDelegate>

@property (assign ,nonatomic) id<SaveActivityViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UITextField *ATName;
@property (strong, nonatomic) IBOutlet UITextField *ATType;

@property (strong, nonatomic) IBOutlet UIView *ATMark;

@property (strong, nonatomic) IBOutlet UITextView *ATDescription;
@property (strong, nonatomic) IBOutlet UISwitch *routeSwitch;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)routeSwitch:(UISwitch *)sender;

- (IBAction)shareSwitch:(UISwitch *)sender;
- (IBAction)clickButton:(UIButton *)sender;

- (IBAction)save:(id)sender;


@end
