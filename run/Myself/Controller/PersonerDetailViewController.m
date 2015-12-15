//
//  PersonerDetailViewController.m
//  run1.2
//
//  Created by runner on 15/1/26.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "PersonerDetailViewController.h"
#import "CountTableView.h"

@interface PersonerDetailViewController ()

@property (nonatomic,strong) UITableView *countView;

@end

@implementation PersonerDetailViewController

- (instancetype)initWithStyle:(SelfDetailType )type {
    
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.type) {
        case ActivityType:
            self.title = @"运动";
            break;
            
        case CountType:
            self.view = self.countView;
            self.title = @"统计";
            break;
            
        case GroupType:
            self.title = @"群组";
            break;
            
        case RouteType:
            self.title = @"路线";
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareRoute)];
            break;
        default:
            break;
    }
    
}

- (void)shareRoute {
    
}


- (UITableView *)countView {
    if (!_countView) {
        _countView = [[CountTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    }
    return _countView;
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
