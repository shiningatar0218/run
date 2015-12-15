//
//  FirstUser.h
//  run
//
//  Created by runner on 15/2/2.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "define.h"

@interface FirstUser : NSObject
@property (nonatomic, assign) LoginType login_type;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) long long user_id;
@end
