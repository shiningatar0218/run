//
//  ActivityDetailViewController.m
//  run1.2
//
//  Created by runner on 15/1/4.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "define.h"
#import "LineView.h"
#import "CustomButton.h"
#import "CoreDataManager.h"
#import "Activity.h"
#import "AppDelegate.h"


@interface ActivityDetailViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    CGFloat _viewHight;
    CGFloat _viewWith;
    NSMutableArray *_titleArray;
    CGFloat _labelWith;
    CGFloat _LabelHight;
    
    UIPickerView *_pickView;
    NSMutableArray *_dataArray;
    NSMutableArray *_timeArray;
    NSMutableArray *_hourArray;
    NSMutableArray *_otherArray;
    NSMutableArray *_tenArray;
    NSInteger _componentCount;
    
    CGFloat _time;
    CGFloat _distance;
    CGFloat _speed;
    
    CGFloat _statusBar_hight;
    CustomButton *_lockButton;
    
    UILabel *_atNameLabel;
    UILabel *_atTypeLabel;
    UILabel *_atMarkLabel;
    UILabel *_timeLabel;
}

@property (nonatomic,retain)UISegmentedControl *segmentedControl;

@end



@implementation ActivityDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"运动";
    _time = 0;
    _distance = 0;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToRoot)];
    
    
    [self.view addSubview:self.segmentedControl];
    [self initData];
    [self initUserInterface];
    [self ActivityInterface];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)initUserInterface {
    
    _statusBar_hight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    _lockButton = [[CustomButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, CGRectGetHeight(self.view.bounds) - 60-_statusBar_hight-self.navigationController.navigationBar.frame.size.height, 40, 40) NormalImage:@"unlocked.png" selectImage:@"locked.png" whenTouchUpInside:^(id sender){
        [self changeLoceState];
    }];
    [self.view addSubview:_lockButton];
    
    NSArray *titleArray = @[@"命名",@"运动",@"标签",@"时间"];
    for (int i = 0 ; i < 4; i ++) {
        
        [self.view addSubview:[LineView LineViewWithFrame:CGRectMake(20, CGRectGetMinY(_lockButton.frame) - 25 - 34*i, self.view.frame.size.width - 30, 1) color:nil]];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMinY(_lockButton.frame) - 25 -34- 34*i, 46, 34)];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [NSString stringWithFormat:@"%@:",titleArray[3-i]];
        
        [self.view addSubview:label];
    }
    _atNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+60, CGRectGetMinY(_lockButton.frame) - 25 -34-34*3, self.view.frame.size.width - 90, 34)];
    _atNameLabel.textAlignment = NSTextAlignmentLeft;
    
    _atTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+60, CGRectGetMinY(_lockButton.frame) - 25 -34-34*2, self.view.frame.size.width - 90, 34)];
    _atTypeLabel.textAlignment = NSTextAlignmentLeft;
    
    _atMarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+60, CGRectGetMinY(_lockButton.frame) - 25 -34-34, self.view.frame.size.width - 90, 34)];
    _atMarkLabel.textAlignment = NSTextAlignmentLeft;
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+60, CGRectGetMinY(_lockButton.frame) - 25 -34, self.view.frame.size.width - 90, 34)];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.view addSubview:_atNameLabel];
    [self.view addSubview:_atTypeLabel];
    [self.view addSubview:_atMarkLabel];
    [self.view addSubview:_timeLabel];
}

- (void)changeLoceState {
    _pickView.userInteractionEnabled = !_pickView.userInteractionEnabled;
    
    if (_pickView.userInteractionEnabled) {
        [_lockButton setImage:[UIImage imageNamed:@"unlocked.png"] forState:UIControlStateNormal];
    }else{
        [_lockButton setImage:[UIImage imageNamed:@"locked.png"] forState:UIControlStateNormal];
    }
    
    
}

- (void)ActivityInterface {

    _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(4, self.segmentedControl.frame.size.height+3, self.view.frame.size.width-8, 160*(iPhone4?0.8:1))];
    _pickView.delegate = self;
    _pickView.dataSource = self;
    _pickView.showsSelectionIndicator = YES;
    _pickView.backgroundColor = RGBACOLOR(221, 221, 221, 0.8);
    _pickView.layer.borderWidth = 1;
    _pickView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:_pickView];
}

- (void)initData {
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    _hourArray = [[NSMutableArray alloc] initWithCapacity:0];
    _timeArray = [NSMutableArray arrayWithCapacity:0];
    _otherArray = [[NSMutableArray alloc] initWithCapacity:0];
    _tenArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < 60; i++) {
        [_timeArray addObject:[NSNumber numberWithInt:i]];
        if (i <= 24) {
            [_hourArray addObject:[NSNumber numberWithInt:i]];
        }
        if (i < 10) {
            [_tenArray addObject:[NSNumber numberWithInt:i]];
        }
    }
    [_otherArray addObject:_hourArray];
    [_otherArray addObject:_tenArray];
    [_otherArray addObject:[NSArray arrayWithObject:@"公里"]];
    [_dataArray addObject:_hourArray];
    [_dataArray addObject:_timeArray];
    [_dataArray addObject:_timeArray];
    _titleArray = [[NSMutableArray alloc] initWithObjects:@"小时",@"分钟",@"秒", nil];
}

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"时间",@"距离",@"配速"]];
        [_segmentedControl setFrame:CGRectMake(0, 0, self.view.frame.size.width, 30*(iPhone4?0.8:1))];
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl addTarget:self action:@selector(didSelectSegmentItems:) forControlEvents:UIControlEventValueChanged];
        _segmentedControl.selected = YES;
    }
    return _segmentedControl;
}

- (void)didSelectSegmentItems:(UISegmentedControl *)sender {
    NSLog(@"%lf",_time);
    NSLog(@"%lf",_distance);
    CGFloat time = 0;
    CGFloat distance = 0;
    switch (sender.selectedSegmentIndex) {
        case 0:
            time = _time > 0 ? _time : 0;
            if (time > 0) {
                [_pickView selectRow:(int)time inComponent:0 animated:YES];
                [_pickView selectRow:(int)((time-(int)time)*10) inComponent:1 animated:YES];
            }
            break;
        case 1:
            //距离
            distance = _distance > 0 ? _distance : 0;
            if (distance > 0) {
                [_pickView selectRow:(int)distance inComponent:0 animated:YES];
                [_pickView selectRow:(int)((distance-(int)distance)*10) inComponent:1 animated:YES];
            }
            [_otherArray removeLastObject];
            [_otherArray addObject:[NSArray arrayWithObjects:@"公里", nil]];
            break;
        case 2:
            //配速
            [_otherArray removeLastObject];
            [_otherArray addObject:[NSArray arrayWithObjects:@"km/h", nil]];
    
            break;
        default:
            break;
    }
    [_pickView reloadAllComponents];
    if (sender.selectedSegmentIndex == 2) {
        _speed = _distance/_time;
        if (_speed > 0) {
            [_pickView selectRow:(int)_speed inComponent:0 animated:YES];
            [_pickView selectRow:(int)((_speed-(int)_speed)*10) inComponent:1 animated:YES];
        }
    }
}

#pragma mark-- UIPickViewDelegate 
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (self.segmentedControl.selectedSegmentIndex != 0) {
        return [_otherArray[component] count];
    }
    return [_dataArray[component] count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.segmentedControl.selectedSegmentIndex != 0) {
        return [NSString stringWithFormat:@"%@",_otherArray[component][row]];
    }
    return [NSString stringWithFormat:@"%@ %@",_dataArray[component][row],_titleArray[component]];
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        switch (component) {
            case 0:
                _time = [_dataArray[component][row] floatValue];
                break;
            case 1:
                _time += [_dataArray[component][row] intValue]/60.0;
            case 2:
                _time += [_dataArray[component][row] intValue]/60.0/60.0;
            default:
                break;
        }
    }
    else if (self.segmentedControl.selectedSegmentIndex == 1) {
        switch (component) {
            case 0:
                _distance = [_otherArray[component][row] floatValue];
                break;
            case 1:
                _distance += [_otherArray[component][row] intValue]/10.0;
            default:
                break;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
