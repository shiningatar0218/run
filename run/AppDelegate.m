//
//  AppDelegate.m
//  run
//
//  Created by runner on 15/1/29.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomTabBarViewController.h"
#import "CustomNavigationViewController.h"
#import "define.h"
#import "DataModel.h"
#import "LaunchViewController.h"

static NSString *const kRunStoreName = @"Run.sqlite";

@interface AppDelegate ()
{
    CustomTabBarViewController *tabBarController;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self copyDefaultStoreIfNecessary];
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelVerbose];
    [MagicalRecord setupCoreDataStackWithStoreNamed:kRunStoreName];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    
    tabBarController = [[CustomTabBarViewController alloc] init];
    [tabBarController setNeedsStatusBarAppearanceUpdate];
    tabBarController.view.backgroundColor = [UIColor whiteColor];

    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:Show_Login];
    
    [UINavigationBar appearance].translucent = NO;
    
    LaunchViewController *launchVC = [[LaunchViewController alloc] init];
    [self.window addSubview:launchVC.view];
    self.window.rootViewController = launchVC;
    
    [self didloginSucessful];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)reloadapp {
    [self.window setRootViewController:tabBarController];
}

- (void)didloginSucessful {
    //NSString *name = @"User/Login";
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *pamara = [user objectForKey:Login_Message];
    
    if (pamara) {
        
        [DATAMODEL loginAppWithPama:pamara completion:^(BOOL sucessful, id objc) {
            if (sucessful) {
                [user setObject:[NSNumber numberWithBool:NO] forKey:Show_Login];
                
                NSString *errorString = [objc  objectForKey:@"err_msg"];
                
                BOOL show_login = NO;
                if (errorString) {
                    show_login = YES;
                }
                if (show_login) {
                    
                    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                    
                    UIViewController *bloginVC = [loginStoryboard instantiateViewControllerWithIdentifier:@"nlogin"];
                    self.window.rootViewController = bloginVC;
                    
                }else {
                    [DATAMODEL saveUserProfileWithPama:objc[@"user"][@"profile"] Completion:^(BOOL isSave) {
                        
                    }];
                    DATAMODEL.isLogin = YES;
                    [self.window setRootViewController:tabBarController];
                }
            }else {
                UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                UIViewController *bloginVC = [loginStoryboard instantiateViewControllerWithIdentifier:@"nlogin"];
                self.window.rootViewController = bloginVC;
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登陆失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }];
    }
    else {
        UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        
        UIViewController *bloginVC = [loginStoryboard instantiateViewControllerWithIdentifier:@"nlogin"];
        self.window.rootViewController = bloginVC;
    }
}

- (void) copyDefaultStoreIfNecessary;
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:kRunStoreName];
    
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:[storeURL path]])
    {
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:[kRunStoreName stringByDeletingPathExtension] ofType:[kRunStoreName pathExtension]];
        
        NSLog(@"%@",defaultStorePath);
        
        if (defaultStorePath)
        {
            NSError *error;
            BOOL success = [fileManager copyItemAtPath:defaultStorePath toPath:[storeURL path] error:&error];
            if (!success)
            {
                NSLog(@"Failed to install default recipe store");
            }
        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

@end
