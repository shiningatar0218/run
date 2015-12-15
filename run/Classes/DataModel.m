//
//  DataModel.m
//  run
//
//  Created by 孙 哲恒 on 14/12/9.
//  Copyright (c) 2014年 abc. All rights reserved.
//

#import "DataModel.h"
#import "CoreDataManager.h"
#import "MessageManager.h"
#import "FileManager.h"
#import <math.h>
#import "AppDelegate.h"
#import "UserProfile.h"
#import "User.h"
#import "MessageManager.h"
#import "NSArray+Additions.h"

@interface DataModel()
{
    CGFloat topredis;
    CGFloat topretime;
    CGFloat ftime;
    CGFloat fdis;
    
    NSMutableArray *_contextArray;
}

@end

@implementation DataModel

static DataModel *_gInstance = nil;

+ (DataModel *)getInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _gInstance = [[self alloc] init];
        _gInstance.taskArray = [[NSMutableArray alloc] init];
        _gInstance.activitying = NO;
        _gInstance.isLogin = NO;
        _gInstance.sport = run;
    });
    
    return _gInstance;
}

- (void)saveActivitydata:(CGFloat)time {
    
    [self saveFile:time];
    [self saveActivityToPersistent:time];
    if ([CoreDataManager currentUserId]) {
        [self savelocation:time];
    }
}

- (void)saveFile:(CGFloat)time {
    
    NSLog(@"time---------%.2f",time);
    
    if ((int)round(time) == 5) {
        topredis = [self.activity.total_distance floatValue];
        topretime = time;
        fdis = [self.activity.total_distance floatValue];
        ftime = time;
    }else {
        topredis = [self.activity.total_distance floatValue] - fdis;
        topretime = time - ftime;
        fdis = [self.activity.total_distance floatValue];
        ftime = time;
    }
    
    NSLog(@"topretime-----%.2f",topretime);
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    [array addObject:[NSString stringWithFormat:@"lat:%.6f",self.latitude]];
    [array addObject:[NSString stringWithFormat:@"long:%.6f",self.longitude]];
    [array addObject:[NSString stringWithFormat:@"alt:%.2f",self.altitude]];
    [array addObject:[NSString stringWithFormat:@"topredis:%.2f",ceilf(topredis)]];
    [array addObject:[NSString stringWithFormat:@"topretime:%.f",round(topretime*1000)]];
    [array addObject:[NSString stringWithFormat:@"dis:%.1f",ceilf([self.activity.total_distance floatValue])]];
    [array addObject:[NSString stringWithFormat:@"time:%.f",round(time * 1000)]];
    [array addObject:[NSString stringWithFormat:@"cal:120.0"]];
    
    if ((int)round(time) == 5) {
        if (!_contextArray) {
            _contextArray = [NSMutableArray arrayWithCapacity:0];
        }
        [_contextArray removeAllObjects];
    }
    NSString *context = [array componentsJoinedByString:@";"];
    [_contextArray addObject:context];
    
    NSString *contexts = [_contextArray componentsJoinedByString:@"\n"];
    
    [FileManager write:contexts ToFileWithName:self.activity.file_url Completion:^(BOOL didFinish, id context) {
        if (didFinish) {
            NSLog(@"数据文件%@",context);
        }
    }];
}

- (void)saveActivityToPersistent:(CGFloat)time {
    [CoreDataManager saveDataToPersistentStoreWithEntity:[DataModel getInstance].activity Completion:^(BOOL contextDidSave, NSError *error) {
        if (contextDidSave) {
            NSLog(@"activity save");
        }
    }];
}

- (void)savelocation:(CGFloat)time {
    
    NSString *name = @"Activity/SetPosition";
    NSDictionary *pamra = @{@"user_id": self.activity.user_id,
                            @"longitude": [NSNumber numberWithDouble:self.longitude],
                            @"latitude": [NSNumber numberWithDouble:self.latitude],
                            @"time": [NSNumber numberWithDouble:time],
                            @"distance":[DataModel getInstance].activity.total_distance,
                            @"session_id":self.activity.session_id};
    
    [[MessageManager getInstance] overLocationWithName:name param:pamra completion:^(BOOL sucessful, id objc) {
        if (sucessful) {
            NSString *errString = objc[Error_message];
            if (errString) {
                NSLog(@"%@",errString);
                return;
            }
            NSLog(@"%@",objc);
        }else {
            NSLog(@"SetPosition  failed");
        }
    }];
}

- (void)saveActivityToServers:(void(^)(BOOL sucessful))completiom {
    NSString *atfile_url = self.activity.file_url;
    NSString *tofile_url = nil;
    if ([[atfile_url substringWithRange:NSMakeRange(12, 1)] isEqualToString:@"."]) {
        NSString *string = [NSString stringWithFormat:@"%@.txt",[CoreDataManager currentUserId]];
        tofile_url = [atfile_url stringByReplacingOccurrencesOfString:@".txt" withString:string];
    }else {
        tofile_url = atfile_url;
    }
    
    [self renameFilerul:atfile_url tofile:tofile_url];
    
    Activity *activity = self.activity;
    activity.user_id = [CoreDataManager currentUserId];
    activity.session_id = [CoreDataManager currentSessionId];
    activity.file_url = tofile_url;
    activity.sport = [NSNumber numberWithInt:self.sport];
    NSString *name = @"Activity/Add";
    NSMutableDictionary *parma = [NSMutableDictionary dictionaryWithCapacity:0];
    NSArray *array = @[@"session_id",
                       @"user_id_creator",
                       @"activity_description",
                       @"energy",
                       @"file_url",
                       @"name",
                       @"pace",
                       @"sport",
                       @"tag_id_s",
                       @"total_distance",
                       @"total_time",
                       @"user_id",
                       @"create_time"];
    for (NSString *key in array) {
        if ([key isEqualToString:@"activity_description"]) {
            [parma setObject:activity.activity_description forKey:@"description"];
        }else if ([key isEqualToString:@"user_id_creator"]){
            [parma setObject:activity.user_id forKey:@"user_id_creator"];
        }
        else {
            [parma setObject:[activity valueForKey:key] forKey:key];
        }
    }
    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
//    [dic setObject:@"4:30" forKey:@"1"];
//    [dic setObject:@"5:20" forKey:@"0.5"];
    
//    activity.splits = dic;
    
    NSMutableDictionary *split = [activity.splits mutableCopy];
    
    NSArray *keys = [split.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result = [NSArray compareString1:obj1 WithString2:obj2];
        
        return result;
    }];
    
    NSString *objc = split[[keys lastObject]];
    [split removeObjectForKey:[keys lastObject]];
    
    double total_distance = [activity.total_distance doubleValue]/1000.0;
    
    [split setObject:objc forKey:[NSString stringWithFormat:@"%.3f",total_distance-keys.count
                                  +1]];
    
    NSMutableArray *keyArray = [NSMutableArray arrayWithArray:keys];
    [keyArray removeLastObject];
    [keyArray addObject:[NSString stringWithFormat:@"%.3f",total_distance-keys.count
                         +1]];
    
    for (int i = 0; i < keyArray.count; i ++) {
        NSString *key = keyArray[i];
        [parma setObject:key forKey:[NSString stringWithFormat:@"[split][%d][number]",i]];
        [parma setObject:split[key] forKey:[NSString stringWithFormat:@"[split][%d][value]",i]];
    }
    
    [[MessageManager getInstance] overDataWithName:name param:parma completion:^(BOOL sucessful, id objc) {
        if (sucessful) {
            NSString *errString = objc[Error_message];
            if (errString) {
                completiom (NO);
                NSLog(@"%@  \nactivity  保存失败！！！",errString);
                return;
            }
            NSLog(@"%@",objc);
            if (!errString) {
                self.activity.activity_id = [NSNumber numberWithString:objc[@"activity_id"]];
                
                [CoreDataManager saveDataToPersistentStoreWithEntity:self.activity Completion:^(BOOL contextDidSave, NSError *error) {
                    if (contextDidSave) {
                        [self saveFileToServers];
                        completiom (YES);
                    }
                    
                    
                }];
            }
        }else {
            NSLog(@"activity  保存失败！！！");
        }
    }];
}

- (void)logoutFromServers {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    NSString *name = @"User/Logout";
    NSMutableDictionary *pamara = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if ([CoreDataManager currentSessionId]) {
        [pamara setObject:[CoreDataManager currentUserId] forKey:@"user_id"];
        [pamara setObject:[CoreDataManager currentSessionId] forKey:@"session_id"];
    }
    [[MessageManager getInstance] requestDataName:name param:pamara completion:^(BOOL sucessful, id objc) {
        if (sucessful) {
            NSString *errString = [objc objectForKey:@"err_msg"];
            if (!errString) {
                self.isLogin = NO;
                [user setObject:nil forKey:Login_Message];
                UIViewController *bloginVC = [loginStoryboard instantiateViewControllerWithIdentifier:@"nlogin"];
                //[self presentViewController:bloginVC animated:YES completion:nil];
                [[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] setRootViewController:bloginVC];
            }else {
                NSLog(@"%@",errString);
                [user setObject:nil forKey:Login_Message];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您未登录" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                [alertView show];
                UIViewController *bloginVC = [loginStoryboard instantiateViewControllerWithIdentifier:@"nlogin"];
                //[self presentViewController:bloginVC animated:YES completion:nil];
                [[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] setRootViewController:bloginVC];
            }
        }
    }];
}

- (void)saveFileToServers {
    
    NSString *filePath = [[FileManager MR_applicationStorageDirectory] stringByAppendingString:@"/activity"];
    
    NSString *name = @"Activity/SetGps";
    NSDictionary *param = @{@"session_id": self.activity.session_id,
                            @"user_id": self.activity.user_id,
                            @"activity_id": self.activity.activity_id,
                            @"file":[NSString stringWithFormat:@"%@/%@",filePath,self.activity.file_url]};
    [[MessageManager getInstance] overDataWithName:name param:param completion:^(BOOL sucessful, id objc) {
        if (sucessful) {
            NSLog(@"文件上传成功%@",objc);
        }else {
            NSLog(@"文件上传失败！！！");
        }
    }];
    
}

- (void)renameFilerul:(NSString *)atfile tofile:(NSString *)tofile {
    [FileManager renameFileName:atfile toFileName:tofile Completion:^(BOOL didFinish, id context) {
        
    }];
}

- (NSNumber *)userId {
    if (!_userId) {
        _userId = [CoreDataManager currentUserId];
    }
    return _userId;
}

- (NSString *)sessionId {
    if (!_sessionId) {
        _sessionId = [CoreDataManager currentSessionId];
    }
    return _sessionId;
}

//保存个人信息设置
- (void)saveUserProfileWithPama:(NSDictionary *)pama Completion:(void(^)(BOOL isSave))completion
{
    UserProfile *profile = nil;
    
    NSArray *array = [User MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"user_id IN %@",@[pama[@"user_id"]]]];
    
    profile = [array lastObject];
    if (array.count == 0) {
        profile = [UserProfile MR_createEntity];
        [UserProfile initWithJsonDictionary:pama enty:profile];
    }
    
    NSManagedObjectContext *context = profile.managedObjectContext;
    [context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        if (contextDidSave) {
            completion (YES);
            NSLog(@"save profile!");
        }else{
            NSLog(@"%@",[error localizedDescription]);
            completion (NO);
        }
    }];
}

#pragma mark -- 修改个人信息
- (void)updateUserProfileWithPama:(NSMutableDictionary *)parma Completion:(void(^)(BOOL sucessful))completion {
    NSString *name = @"User/ChangeProfile";
    
    [parma setObject:DATAMODEL.userId forKey:@"user_id"];
    [parma setObject:DATAMODEL.sessionId forKey:@"session_id"];
    [parma setObject:DATAMODEL.userId forKey:@"model[user_id]"];
    [[MessageManager getInstance] overDataWithName:name param:parma completion:^(BOOL sucessful, id objc) {
        if (sucessful) {
            NSString *errstring = objc[@"err_msg"];
            
            if (errstring) {
                NSLog(@"个人信息修改失败");
                completion (NO);
            }else {
                NSLog(@"个人信息修改失败");
                completion (YES);
            }
        }else {
            NSLog(@"个人信息修改失败");
        }
    }];
}

#pragma mark -- 登陆app
- (void)loginAppWithPama:(NSDictionary *)pama completion:(void(^)(BOOL sucessful, id objc))completion {
    
    NSString *name = @"User/Login";
    [[MessageManager getInstance] requestDataName:name param:pama completion:^(BOOL sucessful, id objc) {
        if (sucessful) {
            
            NSString *errString = objc[@"err_msg"];
            if (errString) {
                NSLog(@"登陆失败！！！！");
                completion (sucessful,objc);
                return;
            }
            self.isLogin = YES;
            NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:pama forKey:Login_Message];
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
                User *user = [array lastObject];
                user.session_id = objc[@"session_id"];
                
                NSManagedObjectContext *context = user.managedObjectContext;
                [context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
                    if (contextDidSave) {
                        NSLog(@"save");
                    }
                }];
            }
            
            completion (sucessful, objc);
        }else {
            NSLog(@"登陆失败！！！！");
            completion (NO, objc);
        }
    }];
}

#pragma mark -- 获取activity
- (void)requestActivityWithParma:(NSDictionary *)parma Completion:(void(^)(BOOL sucessful, id objc))completion {
    NSString *name = @"Activity/GetList";
    
    [[MessageManager getInstance] requestDataName:name param:parma completion:^(BOOL sucessful, id objc) {
        if (sucessful) {
            NSString *errString = objc[@"err_msg"];
            if (errString) {
                completion (NO,errString);
            }else{
                completion (YES,objc[@"activitys"]);
            }
        }else {
            completion (NO,objc);
        }
    }];
}

#pragma mark -- 获取解析文件内容
- (void)readDataFromFile:(NSString *)name completion:(void(^)(BOOL didFinish, NSArray *array))completion {
    
    NSString *contentString = [FileManager readFileName:name];
    
    NSArray *lines = [contentString componentsSeparatedByString:@"\n"];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (NSString *context in lines) {
        
        NSMutableDictionary *contextDic = [NSMutableDictionary dictionaryWithCapacity:0];
        
        NSArray *contexts = [context componentsSeparatedByString:@";"];
        
        for (NSString *string in contexts) {
            NSArray *keyAndObject = [string componentsSeparatedByString:@":"];
            
            if (keyAndObject.count > 1) {
                [contextDic setObject:keyAndObject[1] forKey:keyAndObject[0]];
            }
        }
        [array addObject:contextDic];
    }
    completion (YES, array);
}

#pragma mark -- 截取并保存运动路线图

-(void)cutMapImage:(UIImage *)image {
 //-------存图片------------
    
    NSString *imageName = [NSString stringWithFormat:@"%@",self.activity.file_url];
    imageName = [imageName stringByReplacingOccurrencesOfString:@"txt" withString:@"png"];
    if ([[self.activity.file_url substringWithRange:NSMakeRange(12, 1)] isEqualToString:@"."]) {
        NSString *string = [NSString stringWithFormat:@"%@.png",[CoreDataManager currentUserId]];
        imageName = [imageName stringByReplacingOccurrencesOfString:@".png" withString:string];
    }else {
        imageName = [imageName stringByReplacingOccurrencesOfString:@"png" withString:@"png"];
    }
    
    if (!imageName) {
        NSLog(@"图片命名失败！！！");
        return;
    }
    
    [FileManager saveImage:image withName:imageName didFinish:^(BOOL sucessful, NSString *name) {
        if (sucessful) {
            NSLog(@"%@",name);
        }else{
            NSLog(@"error:%@",name);
        }
    }];
}

- (UIImage *)setActivityImage:(NSString *)name {
    return [FileManager getImage:name];
}

@end
