//
//  AwardTableView.m
//  run1.2
//
//  Created by runner on 15/1/12.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "AwardTableView.h"

@implementation AwardTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    CGRect tFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMaxY(frame), CGRectGetWidth(frame), 0);
    self = [super initWithFrame:tFrame style:style];
    if (self) {
        self.cellHight = frame.size.height;
        self.delegate = self;
        self.dataSource = self;
        //self.backgroundColor = [UIColor lightGrayColor];
        self.backgroundColor = [UIColor redColor];
        self.isShow = NO;
        NSArray *array = @[@"sahara快干衣"];
        self.dataArray = [NSMutableArray arrayWithArray:array];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataSrouce:(NSArray *)dataArray{
    
    CGRect tFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMaxY(frame), CGRectGetWidth(frame), 0);
    
    self = [super initWithFrame:tFrame style:style];
    if (self) {
        self.cellHight = frame.size.height;
        self.delegate = self;
        self.dataSource = self;
        self.bounces = NO;
        self.isShow = NO;
        self.dataArray = [NSMutableArray arrayWithArray:dataArray];
    }
    return self;
}

- (CGFloat)cellHight {
    return _cellHight;
}

- (void)showTableViewWithFrame:(CGRect)frame inView:(UIView *)view didSelectCell:(didSelectBlock)didSelectCallback {
    
    if (didSelectCallback) {
        self.didSelectCallback = didSelectCallback;
    }
    
    self.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMaxY(frame), CGRectGetWidth(frame), 0);
    [view addSubview:self];
    [self reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect awardRect = self.frame;
        awardRect.size.height = frame.size.height*(self.dataArray.count <= 4 ? self.dataArray.count : 4);
        self.frame = awardRect;
    } completion:^(BOOL finished) {
        self.isShow = YES;
    }];
}

- (void)didDismissTableView {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect awardRect = self.frame;
        awardRect.size.height = 0;
        self.frame = awardRect;
    } completion:^(BOOL finished) {
        self.isShow = NO;
        [self removeFromSuperview];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.didSelectCallback(self.dataArray[indexPath.row],self.dataArray);
    [self.awardDelegate didSelectedCell:self.dataArray[indexPath.row]];
    [self didDismissTableView];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.cellHight;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseIdentifier = @"awardCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.backgroundColor = [UIColor cyanColor];
    cell.textLabel.center = CGPointMake(cell.frame.size.width/2, cell.frame.size.height/2);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
    
}

@end
