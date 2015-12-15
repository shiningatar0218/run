//
//  RecordView.h
//  run1.2
//
//  Created by runner on 14/12/31.
//  Copyright (c) 2014年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "define.h"

@protocol RecordDelegate <NSObject>

-(void)saveActivity;

- (void)activityDealWithType:(ActivityStateType)type;

@end

@interface RecordView : UIView

@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *timeCount;
@property (strong, nonatomic) IBOutlet UILabel *distance;
@property (strong, nonatomic) IBOutlet UILabel *pace;
@property (strong, nonatomic) IBOutlet UISlider *pacePK;

@property (strong) NSTimer *timer;
@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) id<RecordDelegate> delegate;

- (IBAction)didClickButton:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UIButton *startOrPauseButton;


@property (nonatomic, strong) UIView *sliderBackView;

@property (nonatomic, strong) CustomButton *lockButton;

@property (nonatomic, strong) UIView *sliderView;


- (id)initWithFrame:(CGRect)frame loadNibName:(NSString *)string woner:(id)owner;
- (void)timeToZero;
- (void)startActivity;
- (void)hiddenSliderView;

- (void)activityStart;
- (void)activityPause;
- (void)activityStop;

@end
