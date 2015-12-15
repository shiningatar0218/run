//
//  PaceView.m
//  run
//
//  Created by runner on 15/3/9.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "PaceView.h"
#import "define.h"
#import "UUChart.h"

@interface PaceView ()<UUChartDataSource>
{
    
}

@property (nonatomic, retain) UUChart *chartView;
@property (nonatomic, retain) NSMutableArray *dataArray;

@end

@implementation PaceView

@synthesize chartView = _chartView;

- (instancetype)initWithFrame:(CGRect)frame ChartData:(NSArray *)dataArray {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.dataArray = [dataArray mutableCopy];
        
        [self.chartView showInView:self];
        
    }
    
    return self;
}

#pragma mark -- UUChartDataSource
- (NSArray *)UUChart_xLableArray:(UUChart *)chart {
    
    if (self.dataArray.count > 1) {
        return [self.dataArray firstObject];
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < 40; i ++) {
        [array addObject:[NSString stringWithFormat:@"%d",i+1]];
    }
    
    return array;
}

- (NSArray *)UUChart_yValueArray:(UUChart *)chart {
    
    if (self.dataArray.count > 0) {
        return @[[self.dataArray lastObject]];
    }
    
    return @[@[@"14",@"45",@"33",@"44",@"19",@"34",@"22",@"36",@"26",@"0",@"39",@"27",@"45",@"25",@"30",@"12",@"16",@"0",@"40",@"34",@"14",@"45",@"33",@"44",@"19",@"34",@"22",@"36",@"26",@"0",@"39",@"27",@"45",@"25",@"30",@"12",@"16",@"0",@"40",@"34"]];
    
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
    return CGRangeMake(45, 0);
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


- (UUChart *)chartView {
    if (!_chartView) {
        _chartView = [[UUChart alloc] initwithUUChartDataFrame:CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height-20) withSource:self withStyle:UUChartLineStyle];
    }
    return _chartView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}


@end
