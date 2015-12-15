//
//  ActivityViewController.h
//  run1.2
//
//  Created by runner on 14/12/31.
//  Copyright (c) 2014年 runner. All rights reserved.
//

#import "CustomViewController.h"
#import "define.h"

@interface ActivityViewController : CustomViewController
- (void)dealWithActivity:(ActivityStateType)type;
- (void)saveActivity;
@end
