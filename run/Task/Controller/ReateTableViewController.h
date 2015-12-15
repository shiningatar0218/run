//
//  ReateTableViewController.h
//  run1.2
//
//  Created by runner on 15/1/12.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReateTableViewController : UITableViewController

@property (nonatomic, strong) void(^completion)(NSMutableArray *selectWeak);

- (instancetype)initWithSelectWeak:(NSMutableArray *)selectWeak Didselected:(void (^)(NSMutableArray *selectWeak))completion;


@end
