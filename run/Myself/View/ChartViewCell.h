//
//  chartViewCell.h
//  run1.2
//
//  Created by runner on 15/1/23.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUChart.h"
#import "CustomButton.h"

@protocol ChartViewCellDelegate <NSObject>
@optional
- (void)ChartViewCellDidBeginEdit:(BOOL)show_edit;

@end

@interface ChartViewCell : UITableViewCell

@property (nonatomic, strong) UUChart *chartView;
@property (nonatomic, assign) UUChartStyle chartStyle;

@property (nonatomic, assign) BOOL show_edit;

@property (nonatomic, strong) CustomButton *editButton;

@property (nonatomic, assign) id<ChartViewCellDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame UUCharStyle:(UUChartStyle)style;






@end
