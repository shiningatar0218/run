//
//  CoreDataManager.m
//  run
//
//  Created by runner on 15/1/29.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "CoreDataManager.h"
#import "AppDelegate.h"
#import "MagicalRecord.h"
#import "CoreData+MagicalRecord.h"
#import "User.h"

@implementation CoreDataManager

+ (NSNumber *)currentUserId {
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:Login_Message];
    
    if (!dic) {
        return @0;
    }
    NSString *name = dic[@"name"];
    User *user = [User MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"name IN %@",@[name]]];
    if (!user.user_id) {
        return [NSNumber numberWithString:@""];
    }
    return user.user_id;
}

+ (NSString *)currentSessionId {
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:Login_Message];
    
    if (!dic) {
        return @"";
    }
    
    NSString *name = dic[@"name"];
    User *user = [User MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"name IN %@",@[name]]];
    
    if (!user.session_id) {
        return @"22";
    }
    return user.session_id;
}

+ (void)saveDataToPersistentStoreWithEntity:(id)entity Completion:(void(^)(BOOL contextDidSave, NSError *error))completion {
    
    NSManagedObjectContext *context = [entity managedObjectContext];
    [context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        if (contextDidSave) {
            NSLog(@"save");
            completion (YES,error);
        }else {
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
}

+ (void)lookDataFromCoreDataStoreWithEntity:(id)entity Order:(NSString *)string Completion:(void(^)(NSArray *array))completion {
    
    if ([[entity class] isSubclassOfClass:[NSManagedObject class]]) {
        
        NSArray *array = [[entity class] MR_findAllSortedBy:string ascending:YES];
        
        completion(array);
    }
    
}

+ (Activity *)activityCreart {
    Activity *activity = [Activity MR_createEntity];
    
    if ([CoreDataManager currentSessionId]) {
        activity.user_id = [CoreDataManager currentUserId];
        activity.session_id = [CoreDataManager currentSessionId];
    }
    activity.sport = @0;
    activity.activity_description = @"";
    activity.name = @"";
    activity.tag_id_s = @"";
    activity.splits = [NSDictionary dictionary];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"YYYYMMddHHmm"];
    
    //NSLog(@"%@",[dataFormatter stringFromDate:date]);
    NSString *fileurl = [NSString stringWithFormat:@"%@.txt",[dataFormatter stringFromDate:date]];
    activity.file_url = fileurl;
    
    [dataFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    activity.create_time = [NSString stringWithFormat:@"%@",[dataFormatter stringFromDate:date]];
    return activity;
}

//+ (void)creatFile:(NSString *)fileurl {
//    NSError *error;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
//    
//    [fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()] withIntermediateDirectories:YES attributes:nil error:&error];
//    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileurl];
//    
//    NSString *str = @"";
//    
//    [str writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
//    
//    NSLog(@"Documentsdirectory:   %@",[fileManager contentsOfDirectoryAtPath:documentsDirectory error:&error]);
//    NSLog(@"%@",error);
//}

@end
