//
//  MessageManager.h
//  test
//
//  Created by jianting zhu on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"


//返回任务列表
//返回成员为Task的NSArray.
#define GotTaskList @"GotTaskList"

@interface MessageManager : NSObject <HttpDelegate>
{
    HttpManager *httpManager;
}
@property (nonatomic,retain)HttpManager *httpManager;

+(MessageManager*)getInstance;

//获取用户任务列表
-(void)requestDataName:(NSString *)name param:(NSDictionary *)param completion:(void(^)(BOOL sucessful, id objc))completion;

-(void)overDataWithName:(NSString *)name param:(NSDictionary *)param completion:(void(^)(BOOL sucessful, id objc))completion;

- (void)overLocationWithName:(NSString *)name param:(NSDictionary *)param completion:(void(^)(BOOL sucessful, id objc))completion;

@end
