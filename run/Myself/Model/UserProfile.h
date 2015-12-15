//
//  UserProfile.h
//  run1.2
//
//  Created by runner on 15/1/21.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "define.h"

typedef NS_ENUM(NSInteger, GenderType) {
    GenderTypeNone = 0,
    Man = 1,
    Woman = 2
};

@interface UserProfile : NSManagedObject

@property (nonatomic, retain) NSString *user_id;
@property (nonatomic, retain) NSString *nick;
@property (nonatomic, retain) NSString *level;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *image;

@property (nonatomic, retain) NSString *email;

@property (nonatomic, retain) NSString *birthday;
@property (nonatomic, retain) NSString *city_id;
@property (nonatomic, retain) NSString *family_name;
@property (nonatomic, retain) NSString *first_name;
@property (nonatomic, retain) NSString *main_sport;
@property (nonatomic, retain) NSString *weight;
@property (nonatomic, retain) NSString *street;

+ (void)initWithJsonDictionary:(NSDictionary *)dic enty:(UserProfile *)enty;

@end
