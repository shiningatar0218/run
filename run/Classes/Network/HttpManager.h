//
//  WeiBoHttpManager.h
//  test
//
//  Created by jianting zhu on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "StringUtil.h"
#import "NSStringAdditions.h"

#define SERVER_IP                   @"http://www.scxmc.com/run/index.php?r=/"
//#define SERVER_IP                   @"http://192.167.1.200/run/index.php?r=/"

#define USER_INFO_KEY_TYPE          @"requestType"
#define USER_OBJECT                 @"USER_OBJECT"
#define RequestFailed               @"RequestFailed"

typedef enum {
    TaskGeteList = 0,               //获取任务列表
    TaskAdd = 1,                        //添加任务
}RequestType;

@class ASINetworkQueue;
@class Status;
@class User;


//Delegate
@protocol HttpDelegate <NSObject>

@optional

//根据任务列表
-(void)didGetTaskList:(NSDictionary *)taskInfo;


@end

@interface HttpManager : NSObject
{
    ASINetworkQueue *requestQueue;
    id<HttpDelegate> delegate;
    
    NSString *authCode;
    NSString *authToken;
    NSString *userId;
}

@property (nonatomic,retain) ASINetworkQueue *requestQueue;
@property (nonatomic,assign) id<HttpDelegate> delegate;
@property (nonatomic,copy) NSString *authCode;
@property (nonatomic,copy) NSString *authToken;
@property (nonatomic,copy) NSString *userId;

@property (nonatomic,copy) void(^completion)(BOOL sucessful, id objc);

- (id)initWithDelegate:(id)theDelegate;

- (BOOL)isRunning;
- (void)start;
- (void)pause;
- (void)resume;
- (void)cancel;



//获取用户任务列表
-(void)requestDataName:(NSString *)name param:(NSDictionary *)param completion:(void(^)(BOOL sucessful, id objc))completion;

-(void)overDataWithName:(NSString *)name param:(NSDictionary *)param completion:(void(^)(BOOL sucessful, id objc))completion;

-(void)overFileWithName:(NSString *)name param:(NSDictionary *)param completion:(void(^)(BOOL sucessful, id objc))completion;

@end
