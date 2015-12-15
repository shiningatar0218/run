//
//  AwardTableView.h
//  run1.2
//
//  Created by runner on 15/1/12.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AwardDelegate <NSObject>

- (void)didSelectedCell:(NSString *)text;

@end

typedef void (^didSelectBlock)(NSString *text,id objc);


@interface AwardTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy) didSelectBlock didSelectCallback;

@property (nonatomic,assign) BOOL isShow;
@property (nonatomic,assign) CGFloat cellHight;
@property (nonatomic,retain) NSMutableArray *dataArray;

@property (nonatomic, assign) id<AwardDelegate> awardDelegate;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataSrouce:(NSArray *)dataArray;

- (void)showTableViewWithFrame:(CGRect)frame inView:(UIView *)view didSelectCell:(didSelectBlock)didSelectCallback;
- (void)didDismissTableView;
@end
