//
//  SettingView.h
//  run
//
//  Created by runner on 15/3/5.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SettingType) {
    SoundServers = 0,
    ShareServers = 1,
    SpeedPKSearvers = 2
};

@interface SettingView : UITableView

@end
