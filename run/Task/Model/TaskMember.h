//
//  TaskMember.h
//  run1.2
//
//  Created by runner on 15/1/19.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TaskMember : NSObject

@property (nonatomic, retain) NSString *nick_name;
@property (nonatomic, assign) long long task_id;
@property (nonatomic, assign) long long user_id;
@property (nonatomic, assign) float distance;
@property (nonatomic, retain) NSString *pace;
@property (nonatomic, retain) NSURL *image;


- (id)initWithJsonDictionary:(NSDictionary *)dic;

@end
