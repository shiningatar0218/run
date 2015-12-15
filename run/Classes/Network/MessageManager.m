//
//  WeiBoMessageManager.m
//  test
//
//  Created by jianting zhu on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//

#import "MessageManager.h"



static MessageManager * instance=nil;

@implementation MessageManager
@synthesize httpManager;

#pragma mark - Init

- (id)init {
    self = [super init];
    if (self) {
        httpManager = [[HttpManager alloc] initWithDelegate:self];
        [httpManager start];
    }
    return self;
}

+(MessageManager*)getInstance
{
    @synchronized(self) {
        if (instance==nil) {
            instance=[[MessageManager alloc] init];
        }
    }
    return instance;
}

- (BOOL)isNeedToRefreshTheToken
{
    return false;
}

#pragma mark - Http Methods
//根据微博消息ID返回某条微博消息的评论列表

- (void)requestDataName:(NSString *)name param:(NSDictionary *)param completion:(void (^)(BOOL, id))completion {
    [httpManager requestDataName:name param:param completion:^(BOOL sucessful, id objc) {
        completion(sucessful,objc);
    }];
}

-(void)overDataWithName:(NSString *)name param:(NSDictionary *)param completion:(void(^)(BOOL sucessful, id objc))completion{
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *objecs = [NSMutableArray arrayWithCapacity:0];
    for (NSString *key in param.allKeys) {
        
        if ([key isEqualToString:@"user_id"]) {
            [keys addObject:key];
        }else if ([key isEqualToString:@"session_id"]){
            [keys addObject:key];
        }else if ([key containsString:@"model"]){
            [keys addObject:key];
        }else if ([key containsString:@"split"]){
            [keys addObject:[NSString stringWithFormat:@"model%@",key]];
        }
        else {
            [keys addObject:[NSString stringWithFormat:@"model[%@]",key]];
        }
        [objecs addObject:param[key]];
    }
    NSMutableDictionary *param_new = [NSMutableDictionary dictionaryWithObjects:objecs forKeys:keys];
    
    if ([name isEqualToString:@"Activity/SetGps"]) {
        [httpManager overFileWithName:name param:param completion:^(BOOL sucessful, id objc) {
            completion(sucessful,objc);
        }];
    }else{
        [httpManager overDataWithName:name param:param_new completion:^(BOOL sucessful, id objc) {
            completion(sucessful,objc);
        }];
    }
}

- (void)overLocationWithName:(NSString *)name param:(NSDictionary *)param completion:(void(^)(BOOL sucessful, id objc))completion {
    [httpManager overDataWithName:name param:param completion:^(BOOL sucessful, id objc) {
        completion(sucessful,objc);
    }];
}

#pragma mark - WeiBoHttpDelegate

//根据微博消息ID返回某条微博消息的评论列表
-(void)didGetTaskList:(NSDictionary *)taskInfo
{
    NSNotification *notification = [NSNotification notificationWithName:GotTaskList object:taskInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
