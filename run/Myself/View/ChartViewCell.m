//
//  chartViewCell.m
//  run1.2
//
//  Created by runner on 15/1/23.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "ChartViewCell.h"
#import "UUChart.h"
#import "define.h"
#import "CustomButton.h"

@interface ChartViewCell ()<UUChartDataSource> {
    NSIndexPath *path;
}

@end

@implementation ChartViewCell

@synthesize chartView = _chartView;
@synthesize delegate = delegate;
@synthesize editButton = editButton;

- (instancetype)initWithFrame:(CGRect)frame UUCharStyle:(UUChartStyle)style{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.show_edit = NO;
        self.chartStyle = style;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.chartView showInView:self.contentView];
    }
    return self;
}

- (UUChart *)chartView {
    if (!_chartView) {
        _chartView = [[UUChart alloc] initwithUUChartDataFrame:CGRectMake(10, 0, kMainScreenWidth - 60, self.frame.size.height) withSource:self withStyle:self.chartStyle];
        
        if (self.chartStyle == UUChartBarStyle) {
            [self addSubview:self.editButton];
        }
    }
    
    return _chartView;
}

- (CustomButton *)editButton {
    if (!editButton) {
        editButton = [[CustomButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 50, 0, 40, 40) NormalImage:@"engine.png" selectImage:nil whenTouchUpInside:^(id sender){
            self.show_edit = !self.show_edit;
            [delegate ChartViewCellDidBeginEdit:self.show_edit];
        }];
        editButton.center = CGPointMake(editButton.center.x, self.frame.size.height/2.0);
    }
    
    return editButton;
}

#pragma mark -- UUChartDataSource
- (NSArray *)UUChart_xLableArray:(UUChart *)chart {
    if (self.chartStyle == UUChartBarStyle) {
        return @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    }
    
    return @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"];
}

- (NSArray *)UUChart_yValueArray:(UUChart *)chart {
    if (self.chartStyle == UUChartBarStyle) {
        return @[@[@"45",@"25",@"30",@"12",@"16",@"0",@"40"]];
    }else{
        return @[@[@"14",@"45",@"33",@"44",@"19",@"34",@"22",@"36",@"26",@"0",@"39",@"27"]];
    }
}

#pragma mark - @optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[RGBCOLOR(255, 90, 0),UURed,UUBrown];
}
//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    if (self.chartStyle == UUChartBarStyle) {
        return CGRangeMake(45, 0);
    }
    return CGRangeZero;
}

#pragma mark 折线图专享功能
//判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

//判断显示最大最小值
- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index
{
    return YES;
}


@end
