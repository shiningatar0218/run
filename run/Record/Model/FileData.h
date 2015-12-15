//
//  FileData.h
//  run
//
//  Created by runner on 15/3/26.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FileData : NSObject

@property (nonatomic, assign) CGFloat alt;

@property (nonatomic, assign) CGFloat cal;

@property (nonatomic, assign) CGFloat dis;

@property (nonatomic, assign) CGFloat lat;

@property (nonatomic, assign) CGFloat longitude;

@property (nonatomic, assign) CGFloat time;

@property (nonatomic, assign) CGFloat topredis;

@property (nonatomic, assign) CGFloat topretime;

@property (nonatomic, assign) CGFloat pace;

+ (id)FileDataWithModel:(NSDictionary *)dic;

@end
