//
//  BigMapViewController.m
//  run
//
//  Created by runner on 15/3/18.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "BigMapViewController.h"
#import "MapView.h"
#import "CustomButton.h"
#import "DataModel.h"

@interface BigMapViewController ()

@property (nonatomic, retain) CustomButton *backButton;

@property (nonatomic, retain) Activity *model;

@property (nonatomic, retain) MapView *mapView;

@property (nonatomic, retain) NSMutableArray *points;

@end

@implementation BigMapViewController

- (instancetype)initWithModel:(Activity *)model {
    if (self = [super init]) {
        self.model = model;
    }
    
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.backButton.completion = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.mapView];
    
    NSString *string = self.model.file_url;
    
    NSInteger count = 0;
    int user_id = [self.model.user_id intValue];
    while (user_id) {
        user_id /= 10;
        count ++;
    }
    NSString *fileName = @"";
    if (string.length > 0) {
        NSRange range = [string rangeOfString:@".txt"];
        fileName = [string substringWithRange:NSMakeRange(range.location - 12 - count-1, 12 + count + 1)];
    }
    
    [DATAMODEL readDataFromFile:fileName completion:^(BOOL didFinish, NSArray *array) {
        self.points = [array mutableCopy];
        [self.mapView startUpDateAndShowRuteWithPoints:self.points];
    }];
}

- (MapView *)mapView {
    if (!_mapView) {
        _mapView = [[MapView alloc] initWithFrame:self.view.bounds];
        
        [_mapView addSubview:self.backButton];
    }
    
    return _mapView;
}

- (CustomButton *)backButton {
    if (_backButton) {
        return _backButton;
    }
    
    _backButton = [[CustomButton alloc] initWithFrame:CGRectMake(_mapView.frame.size.width - 60, 0, 60, 60) NormalImage:@"record_small_screen.png" selectImage:nil whenTouchUpInside:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    return _backButton;
}

- (NSMutableArray *)points {
    if (!_points) {
        _points = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _points;
}

- (void)dealloc {
    _model = nil;
    [_mapView removeFromSuperview];
    _points = nil;
    _backButton = nil;
    NSLog(@"big  map release");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
