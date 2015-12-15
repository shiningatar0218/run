//
//  PieceWiseView.h
//  run1.2
//
//  Created by runner on 14/12/31.
//  Copyright (c) 2014年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieceWiseView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UILabel *timeLabel;

- (void)freePiece;

@end
