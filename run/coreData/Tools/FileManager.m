//
//  FileManager.m
//  run
//
//  Created by runner on 15/2/4.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "FileManager.h"
#import "CoreData+MagicalRecord.h"
@implementation FileManager

+(void)createFileWithFileName:(NSString *)name Completion:(didCompletion)completion {
    
    //NSLog(@"%@",name);
    
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
    NSString *tempDirectory = [NSTemporaryDirectory() stringByAppendingString:@"/activity"];
    
    [fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/activity",NSTemporaryDirectory()] withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSString *filePath = [tempDirectory stringByAppendingPathComponent:name];
    [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        NSArray *array = [fileManager contentsOfDirectoryAtPath:tempDirectory error:&error];
        if ([array containsObject:name]) {
            completion (YES, name);
        }
        if (error) {
            completion (YES,error);
        }else {
            completion (YES,name);
        }
    }
    
}

+(void)write:(NSString *)text ToFileWithName:(NSString *)name Completion:(didCompletion)compeltiom {
    NSError *error = nil;
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSString *tempDirectory = [NSTemporaryDirectory() stringByAppendingString:@"/activity"];
    NSString *filePath = [tempDirectory stringByAppendingPathComponent:name];
    
    if ([filemanager fileExistsAtPath:filePath]) {
        [text writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            compeltiom (YES, error);
        }else {
            compeltiom (YES, @"写入成功！");
        }
    }else {
        compeltiom (YES, @"文件不存在");
    }
}

+(void)renameFileName:(NSString *)name toFileName:(NSString *)name_new Completion:(didCompletion)completion {
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *tempDirectory = [NSTemporaryDirectory() stringByAppendingString:@"/activity"];
    NSString *atfilePath = [tempDirectory stringByAppendingPathComponent:name];
    
    NSString *libDirectory = [[self MR_applicationStorageDirectory] stringByAppendingString:@"/activity"];
    
    if ([fileManager fileExistsAtPath:[self MR_applicationStorageDirectory]]) {
        NSArray *array = [fileManager contentsOfDirectoryAtPath:[self MR_applicationStorageDirectory] error:&error];
        if (![array containsObject:@"activity"]) {
            [fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/activity",[self MR_applicationStorageDirectory]] withIntermediateDirectories:YES attributes:nil error:&error];
        }
    }
    
    NSString *tofilPath = [libDirectory stringByAppendingPathComponent:name_new];
    if ([fileManager moveItemAtPath:atfilePath toPath:tofilPath error:&error]) {
        NSLog(@"保存到永久");
        completion (YES,error);
    }
}

+(NSString *)readFileName:(NSString *)name {
    NSError *error = nil;
    NSString *libDirectory = [[self MR_applicationStorageDirectory] stringByAppendingString:@"/activity"];
    NSString *filePath = [libDirectory stringByAppendingPathComponent:name];
    
    NSString *textFileString = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@.txt",filePath] encoding:NSUTF8StringEncoding error:&error];
    return textFileString;
}

+(void)saveImage:(UIImage *)image withName:(NSString *)imageName didFinish:(void(^)(BOOL sucessful,NSString *name))callBack {
     NSError *error = nil;
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    BOOL sucessful = [filemanager createDirectoryAtPath:[NSString stringWithFormat:@"%@/activityImages",[self MR_applicationStorageDirectory]]
                            withIntermediateDirectories:YES
                                             attributes:nil
                                                  error:&error];

    NSString *path = [[self MR_applicationStorageDirectory] stringByAppendingString:@"/activityImages"];
    NSString *imagePath = [path stringByAppendingPathComponent:imageName];
    
    if (!sucessful) {
        callBack (YES, @"activityImages文件创建不成功！！！");
    }
    
    BOOL result = [UIImagePNGRepresentation(image) writeToFile:imagePath options:NSDataWritingAtomic error:&error];
    
    if (result) {
        callBack (YES, imagePath);
    }else {
        callBack (NO, [error localizedDescription]);
    }
    
}

+(UIImage *)getImage:(NSString *)imageName {
    NSError *error = nil;
    NSString *path = [[self MR_applicationStorageDirectory] stringByAppendingString:@"/activityImages"];
    
    NSString *imagePath = [path stringByAppendingPathComponent:imageName];
    NSURL *imageUrl = [NSURL URLWithString:imagePath];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    
    return image;
}












+ (NSString *)MR_applicationStorageDirectory
{
    NSString *applicationName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(NSString *)kCFBundleNameKey];
    return [[self MR_directory:NSLibraryDirectory] stringByAppendingPathComponent:applicationName];
}

+ (NSString *) MR_directory:(int) type
{
    return [NSSearchPathForDirectoriesInDomains(type, NSUserDomainMask, YES) lastObject];
}

@end
