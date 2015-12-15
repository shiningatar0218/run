//
//  CoreDataManager.h
//  run
//
//  Created by runner on 15/1/29.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Activity.h"

@interface CoreDataManager : NSManagedObject

+ (NSNumber *)currentUserId;
+ (NSString *)currentSessionId;
//创建一个本地的activity,收集activity的数据
+ (Activity *)activityCreart;

+ (void)saveDataToPersistentStoreWithEntity:(id)entity Completion:(void(^)(BOOL contextDidSave, NSError *error))completion;
+ (void)lookDataFromCoreDataStoreWithEntity:(id)entity Order:(NSString *)string Completion:(void(^)(NSArray *array))completion;
@end
