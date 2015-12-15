//
//  FileManager.h
//  run
//
//  Created by runner on 15/2/4.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^didCompletion)(BOOL didFinish, id context);

@interface FileManager : NSObject

+(void)createFileWithFileName:(NSString *)name Completion:(didCompletion)completion;
+(void)write:(NSString *)text ToFileWithName:(NSString *)name Completion:(didCompletion)compeltiom;
//移动文件到指定位置
+(void)renameFileName:(NSString *)name toFileName:(NSString *)name_new Completion:(didCompletion)completion;
+ (NSString *)MR_applicationStorageDirectory;

//读取文件内容
+(NSString *)readFileName:(NSString *)name;

//存图片
+(void)saveImage:(UIImage *)image withName:(NSString *)imageName didFinish:(void(^)(BOOL sucessful,NSString *name))callBack;
//读取图片
+(UIImage *)getImage:(NSString *)imageName;

@end
