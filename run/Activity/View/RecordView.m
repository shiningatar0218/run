//
//  RecordView.m
//  run1.2
//
//  Created by runner on 14/12/31.
//  Copyright (c) 2014年 runner. All rights reserved.
//

#import "RecordView.h"
#import "DataModel.h"
#import "CoreDataManager.h"
#import "FileManager.h"
#import <math.h>
#import <MapKit/MapKit.h>
#import "NSString+Judge.h"

#define START @"activity_start.png"
#define PAUSE @"activity_pause.png"

@interface RecordView ()
{
    CGFloat time;
    BOOL start;
    BOOL reStart;
    NSDate *currenttime;
    NSDate *starttime;
    NSTimeInterval pausetime;
}

@end


@implementation RecordView

- (id)initWithFrame:(CGRect)frame loadNibName:(NSString *)string woner:(id)owner {
    self = [[[NSBundle mainBundle] loadNibNamed:string owner:owner options:nil] lastObject];
    if (self) {
        self.frame = frame;
        time = 0;
        [self.backView addSubview:self.sliderBackView];
        
        [self.pacePK setMinimumTrackImage:[UIImage imageNamed:@"activity_pk_forend.png"] forState:UIControlStateNormal];
        [self.pacePK setMaximumTrackImage:[UIImage imageNamed:@"activity_pk_background.png"] forState:UIControlStateNormal];
        [self.pacePK setThumbImage:[UIImage imageNamed:@"activity_pk_point.png"] forState:UIControlStateNormal];
        self.pacePK.userInteractionEnabled = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeSwitch:) name:SPEED_PK_SWITCH object:nil];
    }
    return self;
}

- (IBAction)didClickButton:(UIButton *)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        
        switch (sender.tag) {
            case 101:
                //开始训练
                
                if (![CLLocationManager locationServicesEnabled]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"GPS不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    
                    [alertView show];
                    break;
                }
                
                if (time == 0) {
                    [DataModel getInstance].activity = [CoreDataManager activityCreart];
                    DATAMODEL.activitying = YES;
                    [FileManager createFileWithFileName:[DataModel getInstance].activity.file_url Completion:^(BOOL didFinish, id context) {
                        if (didFinish) {
                            NSLog(@"%@",context);
                        }
                    }];
                }
                [self.delegate activityDealWithType:ActivityStart];

                break;
                
            case 102:
                //结束训练
                sender.alpha = 0;
                [self stopActivity];
                break;
                
            case 103:
                //暂停训练
                sender.tag = 101;
                [sender setImage:[UIImage imageNamed:START] forState:UIControlStateNormal];
                [self.delegate activityDealWithType:ActivityPause];
                
                break;
            default:
                break;
        }
    }
}

- (void)timeUp {
    if (start) {
        
        if (reStart) {
            starttime = [NSDate dateWithTimeIntervalSinceNow:NSTimeIntervalSince1970];
            reStart = NO;
        }
    }
    currenttime = [NSDate dateWithTimeIntervalSinceNow:NSTimeIntervalSince1970];
    time = currenttime.timeIntervalSinceReferenceDate - starttime.timeIntervalSinceReferenceDate + pausetime;
    [DataModel getInstance].activity.total_time = [NSNumber numberWithDouble:time];
    NSLog(@"%.2f   %.2lf",starttime.timeIntervalSinceReferenceDate,currenttime.timeIntervalSinceReferenceDate);
    //显示时间，速度，距离
    self.timeCount.text = [NSString stringWithDoubleTime:time];
    self.pace.text = [NSString stringWithFormat:@"%.1lf",[[DataModel getInstance].activity.total_distance floatValue]/1000/(time/60/60)];
    self.distance.text = [NSString stringWithFormat:@"%.1f",ceil([[DataModel getInstance].activity.total_distance floatValue])];
    //保存即时数据
    
    if ((int)round(time) != 0 && (int)round(time) % 5 == 0) {
        [[DataModel getInstance] saveActivitydata:time];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"timeUp" object:[NSNumber numberWithDouble:time]];
}


- (void)activityStart {
    [self startActivity];
    self.stopButton.alpha = 1;
    [self.startOrPauseButton setImage:[UIImage imageNamed:PAUSE] forState:UIControlStateNormal];
    self.startOrPauseButton.tag = 103;
}

- (void)activityPause {
    [self pauseActivity];
}

- (void)activityStop {
    [self.timer invalidate];
    _timer = nil;
    [self.startOrPauseButton setImage:[UIImage imageNamed:START] forState:UIControlStateNormal];
    self.startOrPauseButton.tag = 101;
    [self hiddenSliderView];
    pausetime = 0;
    time = 0;
    self.timeCount.text = @"00:00:00";
    self.distance.text = @"0.0";
    self.pace.text = @"0.0";
}


- (void)startActivity {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeUp) userInfo:nil repeats:YES];
    }
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    [_timer setFireDate:[NSDate date]];
    start = YES;
    reStart = YES;
    [self didStartActivity];
}

- (void)pauseActivity {
    
    start = NO;
    [_timer setFireDate:[NSDate distantFuture]];
    
    pausetime = pausetime + [NSDate dateWithTimeIntervalSinceNow:NSTimeIntervalSince1970].timeIntervalSinceReferenceDate - starttime.timeIntervalSinceReferenceDate;
    
}

- (void)stopActivity {
    [self pauseActivity];
    [self.delegate saveActivity];
}

- (void)timeToZero {
    self.timeCount.text = [NSString stringWithFormat:@"00:00:00"];
}

#pragma mark -- 控制显示PK
- (void)didChangeSwitch:(NSNotification *)sender {
    self.pacePK.hidden = ![[sender.userInfo objectForKey:SPEED_PK_SWITCH] boolValue];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SPEED_PK_SWITCH object:nil];
}

















- (void)getCurrentDate {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:NSTimeIntervalSince1970];
    
    NSLog(@"%f",date.timeIntervalSince1970);
}

#pragma mark -- 滑动解锁
-(void)didStartActivity {
    self.sliderBackView.alpha = 1.0;
    self.sliderView.center = self.lockButton.center;
    [self moveToFront];
}

- (UIView *)sliderBackView {
    if (!_sliderBackView) {
        _sliderBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth - 20, 40)];
        _sliderBackView.center = CGPointMake(_sliderBackView.center.x, self.startOrPauseButton.center.y);
        _sliderBackView.alpha = 0.0;
        _sliderBackView.clipsToBounds = YES;
        
        _sliderBackView.layer.borderWidth = 1.0;
        _sliderBackView.layer.cornerRadius = 20.0;
        _sliderBackView.backgroundColor = [UIColor whiteColor];
        [_sliderBackView addSubview:self.lockButton];
        
        [_sliderBackView addSubview:self.sliderView];
    }
    
    return _sliderBackView;
}

- (CustomButton *)lockButton {
    if (!_lockButton) {
        _lockButton = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, 60, self.sliderBackView.frame.size.height) NormalImage:@"unlocked.png" selectImage:nil whenTouchUpInside:^(id sender){
            
            [UIView animateWithDuration:0.3 animations:^{
                self.sliderView.center = _lockButton.center;
            } completion:^(BOOL finished) {
                [self moveToFront];
            }];
        }];
    }
    
    return _lockButton;
}

- (UIView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[UIView alloc] initWithFrame:self.lockButton.bounds];
        _sliderView.backgroundColor = [UIColor orangeColor];
        
        _sliderView.layer.borderWidth = 1;
        _sliderView.layer.cornerRadius = 20.0;
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidingView:)];
        
        
        [_sliderView addGestureRecognizer:panGesture];
        
        
    }
    
    return _sliderView;
}

- (void)slidingView:(UIPanGestureRecognizer *)sender {
    
    static CGPoint startpoint;
    if (sender.state == UIGestureRecognizerStateBegan) {
        startpoint = self.sliderView.center;
    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:self.sliderBackView];
        
        self.sliderView.center = CGPointMake(startpoint.x + translation.x, startpoint.y);
    }else if (sender.state == UIGestureRecognizerStateEnded){
        
        if (startpoint.x == self.lockButton.center.x) {
            if (CGRectGetMaxX(self.sliderView.frame) < CGRectGetWidth(self.sliderBackView.frame)) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.sliderView.center = startpoint;
                } completion:^(BOOL finished) {
                    
                }];
            }else {
                [self moveToBack];
                self.sliderView.center = CGPointMake(self.sliderBackView.frame.size.width-self.sliderView.frame.size.width/2, self.sliderView.center.y);
            }
        }else {
            if (CGRectGetMinX(self.sliderView.frame) > 2) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.sliderView.center = startpoint;
                } completion:^(BOOL finished) {
                    
                }];
            }else {
                [self moveToFront];
                self.sliderView.center = self.lockButton.center;
            }

        }
        
        startpoint = CGPointZero;
        
    }
    
}
//锁
- (void)moveToFront {
    [self.backView bringSubviewToFront:self.sliderBackView];
    self.startOrPauseButton.enabled = NO;
    self.stopButton.enabled = NO;
}
//开锁
- (void)moveToBack {
    [self.backView sendSubviewToBack:self.sliderBackView];
    self.startOrPauseButton.enabled = YES;
    self.stopButton.enabled = YES;
}

- (void)hiddenSliderView {
    self.sliderBackView.alpha = 0.0;
}

@end
