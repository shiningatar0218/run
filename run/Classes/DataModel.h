//
//  DataModel.h
//  run
//
//  Created by 孙 哲恒 on 14/12/9.
//  Copyright (c) 2014年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionaryAdditions.h"
#import "Task.h"
#import "FirstUser.h"
#import "Activity.h"


// 总的数据入口，包括用户相关的数据，系统相关的全局数据等。
@interface DataModel : NSObject

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *sessionId;

@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, strong) FirstUser *mainUser;
@property (nonatomic, retain) NSMutableArray *taskArray;
@property (nonatomic, retain) Activity *activity;
@property (nonatomic, assign) SportType sport;

@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double altitude;

@property (nonatomic, assign) BOOL activitying;

+ (DataModel *)getInstance;
//location
- (void)saveActivitydata:(CGFloat)time;
//activity
- (void)saveActivityToServers:(void(^)(BOOL sucessful))completiom;
//退出登录
- (void)logoutFromServers;

//登陆
- (void)loginAppWithPama:(NSDictionary *)pama completion:(void(^)(BOOL sucessful, id objc))completion;

//保存运动数据文件
- (void)saveFileToServers;
//保存profile保存
- (void)saveUserProfileWithPama:(NSDictionary *)pama Completion:(void(^)(BOOL isSave))completion;
//修改profile
- (void)updateUserProfileWithPama:(NSMutableDictionary *)parma Completion:(void(^)(BOOL sucessful))completion;
//获取activity list
- (void)requestActivityWithParma:(NSDictionary *)parma Completion:(void(^)(BOOL sucessful, id objc))completion;

//解析文件数据
- (void)readDataFromFile:(NSString *)name completion:(void(^)(BOOL didFinish, NSArray *array))completion;
//保存截取的地图图片
-(void)cutMapImage:(UIImage *)image;

//读取图片
- (UIImage *)setActivityImage:(NSString *)name;
@end
