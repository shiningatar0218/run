//
//  CreatTaskViewController.h
//  run1.2
//
//  Created by runner on 15/1/7.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "CustomViewController.h"
#import "Task.h"

typedef NS_ENUM(int, TaskTextType) {
    taskName = 3100,
    TaskDescription = 3101,
    
    TaskBeginTime = 3102,
    TaskEndTime = 3103,
    
    StopTime = 3105,
    StartTime = 3104,
    
    TargetDistance = 3106,
    
    DistanceRule = 3107,
    PaceRule = 3108
};

typedef NS_ENUM(int, ButtonType) {
    AwardName = 3201,
    AwardPicture = 3202,
    TaskAddress = 3203,
    TaskRepeat = 3204,
    TaskRule = 3205,
    TaskPublishType = 3206,
    TaskPublish = 3207
};

@interface CreatTaskViewController : CustomViewController

@property (nonatomic, retain)Task *creat_task;
//@property (strong, nonatomic) IBOutlet UIView *switchView;
//
//@property (strong, nonatomic) IBOutlet UIView *otherView;
//
//
//
//@property (strong, nonatomic) IBOutlet UIScrollView *scrolleView;
//
//@property (strong, nonatomic) IBOutlet UITextField *taskName;
//
//@property (strong, nonatomic) IBOutlet UITextView *taskDescription;
//
//@property (strong, nonatomic) IBOutlet UITextField *taskBeginTime;
//
//@property (strong, nonatomic) IBOutlet UITextField *taskEndTime;
//@property (strong, nonatomic) IBOutlet UITextField *startTime;
//@property (strong, nonatomic) IBOutlet UITextField *stopTime;
//
//@property (strong, nonatomic) IBOutlet UILabel *address;
//
//@property (strong, nonatomic) IBOutlet UILabel *repeat;
//@property (strong, nonatomic) IBOutlet UITextField *distanceRule;
//@property (strong, nonatomic) IBOutlet UITextField *paceRule;
//
//@property (strong, nonatomic) IBOutlet UITextField *targetDistance;
//@property (strong, nonatomic) IBOutlet UIButton *awardButton;
//@property (strong, nonatomic) IBOutlet UIButton *publishTypeButton;
//
//@property (strong, nonatomic) IBOutlet UIButton *publishButton;
//- (IBAction)didClickSwitch:(UISwitch *)sender;
- (IBAction)awardSelected:(UIButton *)sender;

- (IBAction)selectedPublishType:(UIButton *)sender;

- (IBAction)publishTask:(UIButton *)sender;


- (IBAction)integrationRule:(UIButton *)sender;


@end
