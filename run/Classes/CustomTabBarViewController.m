//
//  CustomTabBarViewController.m
//  FinalWork
//
//  Created by Geforceyu on 14/10/29.
//  Copyright (c) 2014年 rimi. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import "define.h"
#import "CustomNavigationViewController.h"
#import "ActivityViewController.h"
#import "TaskViewController.h"
#import "PersonerCenterViewController.h"
#import "PathFindingViewController.h"
#import "SettingViewController.h"
#import "ReportViewController.h"

@interface CustomTabBarViewController ()

@end

@implementation CustomTabBarViewController

-(id)init
{
    self = [super init];
    if(self){
        ActivityViewController *activityVC = [[ActivityViewController alloc] init];
        ReportViewController *reportVC = [[ReportViewController alloc] init];
        TaskViewController *taskVC = [[TaskViewController alloc] init];
        PersonerCenterViewController *personerCVC = [[PersonerCenterViewController alloc] init];
        PathFindingViewController *pathFiningVC = [[PathFindingViewController alloc] init];
        SettingViewController *settingVC = [[SettingViewController alloc] init];
        
        activityVC.title = @"运动";
        reportVC.title = @"记录";
        taskVC.title = @"任务";
        personerCVC.title = @"我";
        pathFiningVC.title = @"探路";
        settingVC.title = @"设置";
        
        CustomNavigationViewController *activityNav = [[CustomNavigationViewController alloc] initWithRootViewController:activityVC];
        CustomNavigationViewController *reportNav = [[CustomNavigationViewController alloc] initWithRootViewController:reportVC];
        CustomNavigationViewController *taskNav = [[CustomNavigationViewController alloc] initWithRootViewController:taskVC];
        CustomNavigationViewController *personerCNav = [[CustomNavigationViewController alloc] initWithRootViewController:personerCVC];
        CustomNavigationViewController *pathFiningNav = [[CustomNavigationViewController alloc] initWithRootViewController:pathFiningVC];
        CustomNavigationViewController *settingNav= [[CustomNavigationViewController alloc] initWithRootViewController:settingVC];
    
        self.viewControllers = @[activityNav,reportNav,taskNav,personerCNav,pathFiningNav,settingNav];
        self.tabBar.translucent = YES;
        [self setHidesBottomBarWhenPushed:YES];
        //设置tabbaritem图片
        NSArray *imageName = @[@"_activity.png",@"_record.png",@"_task.png",@"_myself.png",@"_more.png"];
        NSArray *selectImageName = @[@"s_activity.png",@"s_record.png",@"s_task.png",@"s_myself.png",@"s_more.png"];
        for (int i = 0; i < self.tabBar.items.count; i ++) {
            UITabBarItem *barItem = self.tabBar.items[i];
            barItem.image = [[UIImage imageNamed:imageName[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            barItem.selectedImage = [[UIImage imageNamed:selectImageName[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        
        
        UITabBarItem *moreItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"_more.png"] selectedImage:[UIImage imageNamed:@"s_more.png"]];
        moreItem.selectedImage = [[UIImage imageNamed:@"s_more.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        moreItem.image = [[UIImage imageNamed:@"_more.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        moreItem.title = @"更多";
        self.moreNavigationController.tabBarItem = moreItem;
        self.moreNavigationController.navigationBar.translucent = NO;
        
        //设置字体和颜色
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor],NSForegroundColorAttributeName, nil];
        
        [[UITabBarItem appearance] setTitleTextAttributes:attributes forState:UIControlStateSelected];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor lightGrayColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
        //tabbbr颜色
        [[UITabBar appearance] setBackgroundColor:RGBCOLOR(236, 236, 236)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}




@end
