//
//  DetailRecordViewController.h
//  run
//
//  Created by runner on 15/3/5.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "CustomViewController.h"
#import "Activity.h"

typedef NS_ENUM(NSInteger, DataType) {
    activityInfoType = 0,
    analysisType = 1
};

@interface DetailRecordViewController : CustomViewController

@property (nonatomic, assign) DataType style;


- (instancetype)initWithModel:(Activity *)model;

@end
