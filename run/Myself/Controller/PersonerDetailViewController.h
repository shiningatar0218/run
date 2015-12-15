//
//  PersonerDetailViewController.h
//  run1.2
//
//  Created by runner on 15/1/26.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "CustomViewController.h"
#import "define.h"

@interface PersonerDetailViewController : CustomViewController

@property (nonatomic, assign) SelfDetailType type;
- (instancetype)initWithStyle:(SelfDetailType )type;

@end
