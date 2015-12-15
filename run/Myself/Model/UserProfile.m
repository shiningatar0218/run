//
//  UserProfile.m
//  run1.2
//
//  Created by runner on 15/1/21.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "UserProfile.h"
#import "NSDictionaryAdditions.h"


@implementation UserProfile

@dynamic nick;
@dynamic level;
@dynamic gender;
@dynamic image;
@dynamic user_id;
@dynamic email;
@dynamic phone;

@dynamic birthday;
@dynamic city_id;
@dynamic family_name;
@dynamic first_name;
@dynamic main_sport;
@dynamic weight;
@dynamic street;

+ (void)initWithJsonDictionary:(NSDictionary *)dic enty:(UserProfile *)enty {
    enty.user_id = [dic getStringValueForKey:@"user_id" defaultValue:@""];
    enty.nick = [dic getStringValueForKey:@"nick" defaultValue:@"李美美"];
    enty.phone = [dic getStringValueForKey:@"phone" defaultValue:@"12345678910"];
    enty.level = [dic getStringValueForKey:@"level" defaultValue:0];
    enty.gender = [dic getStringValueForKey:@"gender" defaultValue:0];
    enty.image = [dic getStringValueForKey:@"image" defaultValue:@"my_icon_woman.png"];
    enty.email = [dic getStringValueForKey:@"email" defaultValue:@"123456qq.com"];
    
    enty.birthday = [dic getStringValueForKey:@"birthday" defaultValue:@"1993-02-18"];
    enty.city_id = [dic getStringValueForKey:@"city_id" defaultValue:@"成都"];
    enty.family_name = [dic getStringValueForKey:@"family_name" defaultValue:@"x"];
    enty.first_name = [dic getStringValueForKey:@"first_name" defaultValue:@"x"];
    enty.weight = [dic getStringValueForKey:@"weight" defaultValue:@"60"];
    enty.street = [dic getStringValueForKey:@"street" defaultValue:@"金沙公园"];
}

@end
