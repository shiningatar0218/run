//
//  ActivitySettingView.h
//  run1.2
//
//  Created by runner on 15/1/5.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivitySettingView : UIView

- (id)initWithFrame:(CGRect)frame loadNibName:(NSString *)string woner:(id)owner;

- (IBAction)SoundSwitch:(UISwitch *)sender;
- (IBAction)shareSwitch:(UISwitch *)sender;
- (IBAction)speedPKSwitch:(UISwitch *)sender;
@end
