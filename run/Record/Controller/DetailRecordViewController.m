//
//  DetailRecordViewController.m
//  run
//
//  Created by runner on 15/3/5.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "DetailRecordViewController.h"
#import "PieceCellTableViewCell.h"
#import "CustomButton.h"
#import "MapViewCell.h"
#import "AnalysisCell.h"
#import "define.h"
#import "ActivitySplit.h"
#import "DataModel.h"

#import "BigMapViewController.h"

@interface DetailRecordViewController ()<UITableViewDataSource,UITableViewDelegate,MapViewCellDelegate>
{
    CustomButton *_activityDetailButton;
    CustomButton *_analysisButton;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataArray;

@property (nonatomic, retain) Activity *model;

@end

@implementation DetailRecordViewController

- (instancetype)initWithModel:(Activity *)model {
    if ([super init]) {
        self.view = self.tableView;
        self.style = activityInfoType;
        self.model = model;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"split release");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.style == activityInfoType) {
        MapViewCell *cell = (MapViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.mainScreenButton.completion = nil;
        cell.addButton.completion = nil;
    }
    
    _activityDetailButton.completion = nil;
    _analysisButton.completion = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.dataArray.count <= 0) {
        [self requestSplit];
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)requestSplit {
    NSString *name = @"Activity/Get";
    NSDictionary *parma = @{@"session_id": DATAMODEL.sessionId,
                            @"user_id": DATAMODEL.userId,
                            @"activity_id": self.model.activity_id,
                            @"need_split": @1};
    
    [[MessageManager getInstance] requestDataName:name param:parma completion:^(BOOL sucessful, id objc) {
        if (sucessful) {
            NSString *errString = objc[Error_message];
            if (errString) {
                NSLog(@"获取分段失败！！！");
            }else {
                NSArray *splits = objc[@"activity"][@"splits"];
                for (NSDictionary *dic in splits) {
                    ActivitySplit *split = [[ActivitySplit alloc] initWithJsonParma:dic];
                    [self.dataArray addObject:split];
                }
                
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            }
        }else {
            NSLog(@"获取分段失败！！！");
        }
        
    }];
}

- (void)mapView:(MapView *)mapView WithModel:(Activity *)model {
    BigMapViewController *mapViewC = [[BigMapViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:mapViewC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdenty = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenty];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdenty];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 1) {
        
        PieceCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"separteCell"];
        if (!cell) {
            cell = [[PieceCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"separteCell"];
        }
        
        [cell showDataWithModel:self.dataArray[indexPath.row]];

        return cell;
    }
    
    if (indexPath.section == 0) {
        
        if (self.style == activityInfoType) {
            MapViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mapCell"];
            if (!cell) {
                cell = [[MapViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mapCell"];
                cell.delegate = self;
            }
            
            [cell showDataWithModel:self.model];
            return cell;
        }else {
            if (self.style == analysisType) {
                AnalysisCell *cell = [tableView dequeueReusableCellWithIdentifier:@"analysisCell"];
                if (!cell) {
                    cell = [[AnalysisCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"analysisCell"];
                }
                
                [cell showDataWithModel:self.model];
                return cell;
            }
        }
    }

    cell.imageView.image = [UIImage imageNamed:@"record_break_record.png"];
    cell.textLabel.textColor = NaVBarColor;
    cell.detailTextLabel.textColor = NaVBarColor;
    cell.textLabel.text = @"2公里";
    cell.detailTextLabel.text = @"超过之前记录2分钟";
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 60*(iPhone4?0.8:1))];
    if (section == 0) {
        headerView.backgroundColor = sahara_BackGroundColor;
        return headerView;
    }
    
    if (section == 2) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headerView.frame.size.width, 30)];
        headerView.frame = CGRectMake(0, 0, kMainScreenHeight, 30);
        label.text = @"破记录";
        
        [headerView addSubview:label];
        return headerView;
    }
    
    
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView_route = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_split_distance.png"]];
    imageView_route.frame = CGRectMake(10, 10, imageView_route.image.size.width, imageView_route.image.size.width);
    
    UILabel *label_route = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView_route.frame), 10, 30, imageView_route.frame.size.height)];
    label_route.textColor = [UIColor lightGrayColor];
    label_route.textAlignment = NSTextAlignmentLeft;
    label_route.text = @"公里段";
    label_route.font = BOLD_10_FONT;
    
    UIImageView *imageView_totalTime = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_split_time"]];
    imageView_totalTime.frame = CGRectMake(CGRectGetMaxX(label_route.frame), 10, imageView_totalTime.image.size.width, imageView_totalTime.image.size.height);
    UILabel *label_totalTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView_totalTime.frame), 10, 30, imageView_totalTime.frame.size.height)];
    label_totalTime.textColor = [UIColor lightGrayColor];
    label_totalTime.textAlignment = NSTextAlignmentLeft;
    label_totalTime.text = @"时间";
    label_totalTime.font = BOLD_10_FONT;
    
    UIImageView *imageView_time = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_split_pace"]];
    imageView_time.frame = CGRectMake(CGRectGetMaxX(label_totalTime.frame), 10, imageView_time.image.size.width, imageView_time.image.size.height);
    UILabel *label_time = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView_time.frame), 10, 30, imageView_time.frame.size.height)];
    label_time.textColor = [UIColor lightGrayColor];
    label_time.textAlignment = NSTextAlignmentLeft;
    label_time.text = @"配速";
    label_time.font = BOLD_10_FONT;
    
    [headerView addSubview:imageView_route];
    [headerView addSubview:label_route];
    [headerView addSubview:imageView_totalTime];
    [headerView addSubview:label_totalTime];
    [headerView addSubview:imageView_time];
    [headerView addSubview:label_time];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1 || section == 2) {
        return nil;
    }
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    footerView.backgroundColor = sahara_BackGroundColor;
    
    _activityDetailButton = [[CustomButton alloc] initWithFrame:CGRectMake(kMainScreenWidth/2.0-60, 10, 25, 20) NormalImage:@"record_activitydetail_unselect.png" selectImage:@"record_activitydetail_select.png" whenTouchUpInside:^(id sender) {
        self.style = activityInfoType;
        [self showType:self.style];
    }];
   [_activityDetailButton setImage:[UIImage imageNamed:_activityDetailButton.selectImage] forState:UIControlStateNormal];
    _analysisButton = [[CustomButton alloc] initWithFrame:CGRectMake(kMainScreenWidth/2.0+60, 10, 25, 20) NormalImage:@"record_zhexian_unselect.png" selectImage:@"record_zhexian_select.png" whenTouchUpInside:^(id sender) {
        self.style = analysisType;
        [self showType:self.style];
    }];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, footerView.frame.size.height-40, 120, 40)];
    label.text = @"配速刨视图";
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor grayColor];
    
    [footerView addSubview:label];
    [footerView addSubview:_activityDetailButton];
    [footerView addSubview:_analysisButton];
    
    return footerView;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        //return 3;
        return self.dataArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return (kMainScreenHeight-64.0)/3.0*2-80;
    }
    
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 80.0;
    }
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 5.0;
    }
    if (section == 2) {
        return 30.0;
    }
    return 60*(iPhone4?0.8:1);
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        //_tableView.backgroundColor = [UIColor whiteColor];
        _tableView.backgroundView.backgroundColor = sahara_BackGroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];

    }
    return _dataArray;
}

- (void)showType:(DataType)type {
    if (type == activityInfoType) {
        [_activityDetailButton setImage:[UIImage imageNamed:_activityDetailButton.selectImage] forState:UIControlStateNormal];
        [_analysisButton setImage:[UIImage imageNamed:_analysisButton.normalImage] forState:UIControlStateNormal];
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
        
    }else {
        [_activityDetailButton setImage:[UIImage imageNamed:_activityDetailButton.normalImage] forState:UIControlStateNormal];
        
        [_analysisButton setImage:[UIImage imageNamed:_analysisButton.selectImage] forState:UIControlStateNormal];
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
