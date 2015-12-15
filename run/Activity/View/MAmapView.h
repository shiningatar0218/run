//
//  MAmapView.h
//  run
//
//  Created by runner on 15/3/24.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAmapView : UIView

- (void)startUpDate;
- (void)buildMap;
- (void)freaMap;
- (void)beginingActivity;
- (void)paseActivity;
- (void)startUpDateAndShowRuteWithPoints:(NSArray *)points;

@end
