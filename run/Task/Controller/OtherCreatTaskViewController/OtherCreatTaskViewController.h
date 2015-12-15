//
//  OtherCreatTaskViewController.h
//  run
//
//  Created by runner on 15/2/10.
//  Copyright (c) 2015年 runner. All rights reserved.
//


#import "CustomViewController.h"
typedef NS_ENUM(NSInteger, SignSwitch) {
    signSwitch_off = 0,
    signSwitch_on = 1
};

@protocol CreateTaskDelegate <NSObject>

- (void)didCreateTask;

@end

@interface OtherCreatTaskViewController : CustomViewController

@property (nonatomic, assign) id<CreateTaskDelegate> delegate;

@property (strong, nonatomic) NSString *taskName;

@property (strong, nonatomic) NSString *taskDescription;

@property (strong, nonatomic) NSString *taskBeginTime;

@property (strong, nonatomic) NSString *taskEndTime;

@property (strong, nonatomic) NSString *award_name;
@property (strong, nonatomic) NSString *award_pic_1;
@property (assign, nonatomic) NSInteger sing_switch;

@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *stopTime;

@property (strong, nonatomic) NSString *address;

@property (strong, nonatomic) NSString *repeat;
@property (strong, nonatomic) NSString *distanceRule;
@property (strong, nonatomic) NSString *paceRule;
@property (strong, nonatomic) NSString *targetDistance;

@property (assign, nonatomic) BOOL signSwitch;

@end
