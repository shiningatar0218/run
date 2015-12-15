//
//  PieceWiseView.m
//  run1.2
//
//  Created by runner on 14/12/31.
//  Copyright (c) 2014年 runner. All rights reserved.
//



#import "PieceWiseView.h"
#import "PieceCellTableViewCell.h"
#import "define.h"
#import "DataModel.h"
#import "NSString+Judge.h"

@interface PieceWiseView ()
{
    double formerTime;
    
    NSInteger count;
}
@property (nonatomic, retain) NSMutableArray *pieceArray;
@property (nonatomic, retain) NSMutableArray *paceArray;

@property (nonatomic, retain) NSMutableDictionary *paceDic;

@end

@implementation PieceWiseView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeUp:) name:@"timeUp" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(reloadData) name:@"reload" object:nil];
        
        self.tableView.frame = self.bounds;
        [self addSubview:self.tableView];
        //[self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    }
    return self;
}

- (void)freePiece {
    _pieceArray = nil;
    _paceArray = nil;
    _dataArray = nil;
    self.timeLabel.text = @"00:00:00";
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.tableView name:@"reload" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"timeUp" object:nil];
}

- (void)timeUp:(NSNotification *)sender {
    self.timeLabel.text = [NSString stringWithDoubleTime:[sender.object doubleValue]];
    
//    if ([[DataModel getInstance].activity.total_distance intValue] < 1000 && formerTime != 0) {
//        count = 1;
//    }
    
    int distanceCount = [[DataModel getInstance].activity.total_distance intValue]/1000;
    double total_distance = [DATAMODEL.activity.total_distance doubleValue]/1000.0;
    formerTime = 0.0;
    if (self.pieceArray.count>= 2) {
        
        NSInteger index = self.pieceArray.count - 2;
        
        formerTime = [self.pieceArray[index] doubleValue];
    }
    if (distanceCount >= self.paceArray.count) {
        [self.pieceArray addObject:sender.object];
        double paceTime = [sender.object doubleValue] - formerTime;
        [self.dataArray addObject:[NSNumber numberWithDouble:paceTime]];
        double pace = paceTime/(PACE*60);
        if (total_distance > 0) {
            pace = pace/(total_distance/1000.0-self.dataArray.count+1);
        }else {
            pace = 0.0;
        }
        
        [self.paceArray addObject:[NSNumber numberWithDouble:pace]];

        [self.tableView reloadData];
    }else {
        self.pieceArray[distanceCount] = sender.object;
        double paceTime = [sender.object doubleValue] - formerTime;
        self.dataArray[distanceCount] = [NSNumber numberWithDouble:paceTime];
        double pace = paceTime/(PACE*60);
        
        if (total_distance > 0) {
            pace = pace/(total_distance - self.dataArray.count+1);
        }else {
            pace = 1.0;
        }
        
        self.paceArray[distanceCount] = [NSNumber numberWithDouble:pace];
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.paceArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }

}

#pragma mark -- tableViewdelegate&DataSourceDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.paceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdenty = @"cell";
    
    PieceCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenty];
    if (!cell) {
        cell = [[PieceCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenty];
    }
    cell.pieceLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    cell.timeLabel.text = [NSString stringWithDoublePaceTime:[self.dataArray[indexPath.row] doubleValue]];
    cell.totalTimeLabel.text = [NSString stringWithDoubleTime:[self.pieceArray[indexPath.row] doubleValue]];
    cell.paceProgress.progress = [self.paceArray[indexPath.row] floatValue];
    
    [self.paceDic setObject:self.dataArray[indexPath.row] forKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
    
    DATAMODEL.activity.splits = self.paceDic;
    
    return cell;
}
#pragma mark -- 头部标题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 60*(iPhone4?0.8:1))];
    headerView.backgroundColor = [UIColor whiteColor];
    
    [headerView addSubview:self.timeLabel];
    UIImageView *imageView_route = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_split_distance.png"]];
    imageView_route.frame = CGRectMake(10, self.timeLabel.frame.size.height, imageView_route.image.size.width, imageView_route.image.size.width);
    
    UILabel *label_route = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView_route.frame), self.timeLabel.frame.size.height, 30, imageView_route.frame.size.height)];
    label_route.textColor = [UIColor lightGrayColor];
    label_route.textAlignment = NSTextAlignmentLeft;
    label_route.text = @"公里段";
    label_route.font = BOLD_10_FONT;
    
    UIImageView *imageView_totalTime = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_split_time"]];
    imageView_totalTime.frame = CGRectMake(CGRectGetMaxX(label_route.frame), self.timeLabel.frame.size.height, imageView_totalTime.image.size.width, imageView_totalTime.image.size.height);
    UILabel *label_totalTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView_totalTime.frame), self.timeLabel.frame.size.height, 30, imageView_totalTime.frame.size.height)];
    label_totalTime.textColor = [UIColor lightGrayColor];
    label_totalTime.textAlignment = NSTextAlignmentLeft;
    label_totalTime.text = @"时间";
    label_totalTime.font = BOLD_10_FONT;
    
    UIImageView *imageView_time = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_split_pace"]];
    imageView_time.frame = CGRectMake(CGRectGetMaxX(label_totalTime.frame), self.timeLabel.frame.size.height, imageView_time.image.size.width, imageView_time.image.size.height);
    UILabel *label_time = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView_time.frame), self.timeLabel.frame.size.height, 30, imageView_time.frame.size.height)];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0*(iPhone4?0.8:1);
}

- (NSMutableArray *)pieceArray {
    if (!_pieceArray) {
        _pieceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _pieceArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}

- (NSMutableArray *)paceArray {
    if (!_paceArray) {
        _paceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _paceArray;
}

- (NSMutableDictionary *)paceDic {
    if (!_paceDic) {
        _paceDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    
    return _paceDic;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //_tableView.rowHeight = 64.0;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 30*(iPhone4?0.8:1))];
        _timeLabel.text = @"00:00:00";
        _timeLabel.font = BOLD_16_FONT;
        //_timeLabel.font = FONT(@"Helvetica-BoldOblique", 16);
    }
    return _timeLabel;
}


@end
