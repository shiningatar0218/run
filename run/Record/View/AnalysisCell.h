//
//  AnalysisCell.h
//  run
//
//  Created by runner on 15/3/9.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"

typedef NS_ENUM(int, AnalysisDataType) {
    AltitudeType = 0,
    DataPaceType = 1
};

@interface AnalysisCell : UITableViewCell

- (void)showDataWithModel:(Activity *)model;

@end
