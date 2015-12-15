//
//  User.h
//  run
//
//  Created by 孙 哲恒 on 14/12/9.
//  Copyright (c) 2014年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Activity.h"
#import "define.h"
#import "UserProfile.h"
#import "UserBrief.h"
#import "UserPrivacy.h"
#import "UserSetting.h"

//某个用户的所有相关数据，包括运动数据，配置数据等。
@interface User : NSManagedObject
//@property (nonatomic,retain) NSMutableArray *activityArray;


@property (nonatomic,retain) NSNumber *user_id;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSNumber *login_type;
@property (nonatomic,retain) NSString *session_id;

//@property (nonatomic,strong) UserProfile *profile;
//@property (nonatomic,strong) UserBrief *brief;
//@property (nonatomic,strong) UserPrivacy *privacy;
//@property (nonatomic,strong) UserSetting *setting;



@end
