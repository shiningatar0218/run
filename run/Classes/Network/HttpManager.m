//
//  HttpManager.m
//  test
//
//  Created by jianting zhu on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//

#import "HttpManager.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "DataModel.h"


@implementation HttpManager
@synthesize requestQueue;
@synthesize delegate;
@synthesize authCode;
@synthesize authToken;
@synthesize userId;

#pragma mark - Init

-(void)dealloc
{
    self.userId = nil;
    self.authToken = nil;
    self.authCode = nil;
    self.requestQueue = nil;
    self.completion = nil;
    [super dealloc];
}

//初始化
- (id)initWithDelegate:(id)theDelegate {
    self = [super init];
    if (self) {
        requestQueue = [[ASINetworkQueue alloc] init];
        [requestQueue setDelegate:self];
        [requestQueue setRequestDidFailSelector:@selector(requestFailed:)];
        [requestQueue setRequestDidFinishSelector:@selector(requestFinished:)];
        [requestQueue setRequestWillRedirectSelector:@selector(request:willRedirectToURL:)];
		[requestQueue setShouldCancelAllRequestsOnFailure:NO];
        [requestQueue setShowAccurateProgress:YES];
        self.delegate = theDelegate;
    }
    return self;
}

#pragma mark - Methods
- (void)setGetUserInfo:(ASIHTTPRequest *)request withRequestType:(RequestType)requestType {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:requestType] forKey:USER_INFO_KEY_TYPE];
    [request setUserInfo:dict];
    [dict release];
}

- (void)setPostUserInfo:(ASIFormDataRequest *)request withRequestType:(RequestType)requestType {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:requestType] forKey:USER_INFO_KEY_TYPE];
    [request setUserInfo:dict];
    [dict release];
}

- (NSURL*)generateURL:(NSString*)baseURL params:(NSDictionary*)params {
	if (params) {
		NSMutableArray* pairs = [NSMutableArray array];
		for (NSString* key in params.keyEnumerator) {
			NSString* value = [params objectForKey:key];
			NSString* escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																						  NULL, /* allocator */
																						  (CFStringRef)value,
																						  NULL, /* charactersToLeaveUnescaped */
																						  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																						  kCFStringEncodingUTF8);

            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
			[escaped_value release];
		}
		
		NSString* query = [pairs componentsJoinedByString:@"&"];
		NSString* url = [NSString stringWithFormat:@"%@?%@", baseURL, query];
		return [NSURL URLWithString:url];
	} else {
		return [NSURL URLWithString:baseURL];
	}
}

//提取用户ID
- (NSString *) extractUsernameFromHTTPBody: (NSString *) body {
	if (!body) {
        return nil;
    }
	
	NSArray	*tuples = [body componentsSeparatedByString: @"&"];
	if (tuples.count < 1) {
        return nil;
    }
	
	for (NSString *tuple in tuples) {
		NSArray *keyValueArray = [tuple componentsSeparatedByString: @"="];
		
		if (keyValueArray.count == 2) {
			NSString    *key = [keyValueArray objectAtIndex: 0];
			NSString    *value = [keyValueArray objectAtIndex: 1];
			
			if ([key isEqualToString:@"screen_name"]) return value;
			if ([key isEqualToString:@"user_id"]) return value;
		}
	}
	return nil;
}

#pragma mark - Http Operate

#pragma mark -- 请求数据
- (void)requestDataName:(NSString *)name param:(NSDictionary *)param completion:(void (^)(BOOL, id))completion {
    
    if (completion) {
        self.completion = completion;
    }
    
    NSString *postURL = [NSString stringWithFormat:@"%@%@",SERVER_IP,name];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
    
    for (NSString *key in param.allKeys) {
        [request addPostValue:[NSString stringWithFormat:@"%@",param[key]] forKey:key];
    }
    
    //NSLog(@"request = %@",request);
    request.timeOutSeconds = 10.0;
    [self setPostUserInfo:request withRequestType:TaskGeteList];
    [requestQueue addOperation:request];
    [request release];
}

#pragma mark -- 修改数据
-(void)overDataWithName:(NSString *)name param:(NSDictionary *)param completion:(void(^)(BOOL sucessful, id objc))completion {
    if (completion) {
        self.completion = completion;
    }
    
    NSString *postURL = [NSString stringWithFormat:@"%@%@",SERVER_IP,name];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
    
    for (NSString *key in param.allKeys) {
        [request addPostValue:[NSString stringWithFormat:@"%@",param[key]] forKey:key];
    }
    
    NSLog(@"request = %@",request);
    request.timeOutSeconds = 10.0;
    [self setPostUserInfo:request withRequestType:TaskAdd];
    [requestQueue addOperation:request];
    [request release];

}

-(void)overFileWithName:(NSString *)name param:(NSDictionary *)param completion:(void(^)(BOOL sucessful, id objc))completion {
    if (completion) {
        self.completion = completion;
    }
    
    NSString *postURL = [NSString stringWithFormat:@"%@%@",SERVER_IP,name];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
    
    for (NSString *key in param.allKeys) {
        if ([param[key] isKindOfClass:[NSString class]]) {
            if ([param[key] containsString:@".txt"]) {
                [request setFile:[NSString stringWithFormat:@"%@",param[key]] forKey:key];
            }else {
                [request addPostValue:[NSString stringWithFormat:@"%@",param[key]] forKey:key];
            }
        }else{
            [request addPostValue:[NSString stringWithFormat:@"%@",param[key]] forKey:key];
        }
    }
    
    NSLog(@"request = %@",request);
    request.timeOutSeconds = 10.0;
    [self setPostUserInfo:request withRequestType:TaskAdd];
    [requestQueue addOperation:request];
    [request release];
}


#pragma mark - Operate queue
- (BOOL)isRunning
{
	return ![requestQueue isSuspended];
}

- (void)start
{
	if( [requestQueue isSuspended] )
		[requestQueue go];
}

- (void)pause
{
	[requestQueue setSuspended:YES];
}

- (void)resume
{
	[requestQueue setSuspended:NO];
}

- (void)cancel
{
	[requestQueue cancelAllOperations];
}

#pragma mark - ASINetworkQueueDelegate
//失败
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"requestFailed:%@,%@,",request.responseString,[request.error localizedDescription]);
    self.completion(NO,request.error);
}

//成功
- (void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *userInformation = [request userInfo];
    RequestType requestType = [[userInformation objectForKey:USER_INFO_KEY_TYPE] intValue];
    NSString * responseString = [request responseString];

    NSLog(@"responseString=%@",responseString);
    SBJsonParser    *parser     = [[SBJsonParser alloc] init];    
    id  returnObject = [parser objectWithString:responseString];
    [parser release];
    if ([returnObject isKindOfClass:[NSDictionary class]]) {
        NSString *errorString = [returnObject  objectForKey:@"err_msg"];
        if (errorString != nil && ([errorString isEqualToString:@"auth faild!"] || 
                                   [errorString isEqualToString:@"expired_token"] || 
                                   [errorString isEqualToString:@"invalid_access_token"])) {
            NSLog(@"detected auth faild!");
        }
    }
    
    NSLog(@"returnObject=%@",returnObject);
    NSDictionary *userInfo = nil;
    NSArray *userArr = nil;
    if ([returnObject isKindOfClass:[NSDictionary class]]) {
        userInfo = (NSDictionary*)returnObject;
    }
    else if ([returnObject isKindOfClass:[NSArray class]]) {
        userArr = (NSArray*)returnObject;
    }
    else {
        self.completion(NO,nil);
        return;
    }
    
    
    self.completion(YES,userInfo);
    
        //获取任务列表
//    if (requestType == TaskGeteList) {
//        NSLog(@"TaskGeteList>>>");
//        NSArray         *array        = [userInfo objectForKey:@"tasks"];
//        if (array == nil || [array isEqual:[NSNull null]]) {
//            return;
//        }
//        NSMutableArray  *taskArray = [[NSMutableArray alloc]initWithCapacity:0];
//        for (id item in array) {
//            Task *task = [Task taskWithJsonDictionary:item];
//            [taskArray addObject:task];
//        }
//        
//        if ([delegate respondsToSelector:@selector(didGetTaskList:)]) {
//            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:taskArray,@"tasks", nil];
//            [delegate didGetTaskList:dic];
//        }
//        [taskArray release];
//    }
    
}

//跳转
- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL {
    NSLog(@"request will redirect");
    NSNotification *notification = [NSNotification notificationWithName:RequestFailed object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
