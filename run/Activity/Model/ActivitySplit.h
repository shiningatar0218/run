//
//  ActivitySplit.h
//  run1.2
//
//  Created by runner on 15/1/28.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivitySplit : NSObject

@property (nonatomic, assign) long long activity_id;
@property (nonatomic, assign) float number;//第几公里，最后的可能出现小数
@property (nonatomic, assign) float value;//该公里对应的配速

- (id)initWithJsonParma:(NSDictionary *)dic;

@end
