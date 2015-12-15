//
//  CustomViewController.h
//  FinalWork
//
//  Created by Geforceyu on 14/10/29.
//  Copyright (c) 2014年 rimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomViewController : UIViewController

@property (nonatomic,assign)CGFloat keyBoardHeight;

@property (nonatomic,assign)BOOL endEditingWhenTouch;
@property (nonatomic,retain)UIView *currentView;
@property (nonatomic,assign)CGSize kbSize;
@property (nonatomic,assign)CGFloat distance;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)autokeyboardHight;


- (IBAction)didEditingChanged:(UITextField *)sender;


- (IBAction)didBeginEditing:(UITextField *)sender;

- (IBAction)didEndEditing:(UITextField *)sender;


- (void)backToPop;


- (void)didloginSucessful;

@end
