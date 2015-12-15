//
//  ActivitySettingView.m
//  run1.2
//
//  Created by runner on 15/1/5.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "ActivitySettingView.h"
#import "define.h"



@implementation ActivitySettingView

- (id)initWithFrame:(CGRect)frame loadNibName:(NSString *)string woner:(id)owner {
    self = [[[NSBundle mainBundle] loadNibNamed:string owner:owner options:nil] lastObject];
    if (self) {
        self.frame = frame;
        self.backgroundColor = RGBACOLOR(230, 230, 230, 1);
    }
    return self;
}

- (IBAction)SoundSwitch:(UISwitch *)sender {
    
}

- (IBAction)shareSwitch:(UISwitch *)sender {
    
}

- (IBAction)speedPKSwitch:(UISwitch *)sender {
    //[delegate didChangeSwitch:sender];
    [[NSNotificationCenter defaultCenter] postNotificationName:SOUND_SWITCH object:sender userInfo:nil];
}



@end
