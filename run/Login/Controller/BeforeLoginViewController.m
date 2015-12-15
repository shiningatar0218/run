//
//  BeforeLoginViewController.m
//  run1.2
//
//  Created by runner on 15/1/21.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "BeforeLoginViewController.h"
#import "AppDelegate.h"

@interface BeforeLoginViewController ()

@end

@implementation BeforeLoginViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)toLogView:(id)sender {
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (IBAction)startApp:(id)sender {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] reloadapp];
}


- (void)dealloc {
    NSLog(@"loginView  release");
}

@end
