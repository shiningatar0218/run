//
//  MapViewCell.h
//  run
//
//  Created by runner on 15/3/6.
//  Copyright (c) 2015年 runner. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "DetailLabel.h"
#import "MapView.h"
#import "Activity.h"
#import "CustomButton.h"

@protocol MapViewCellDelegate <NSObject>

- (void)mapView:(MapView *)mapView WithModel:(Activity *)model;

@end

@interface MapViewCell : UITableViewCell

@property (nonatomic, assign) id<MapViewCellDelegate> delegate;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, retain) UIView *mapRecordView;
@property (nonatomic, retain) MapView *mapView;
@property (nonatomic, retain) UIView *whiterView;

@property (nonatomic, retain) UIView *dataView;
@property (nonatomic, retain) DetailLabel *distanceLabel;
@property (nonatomic, retain) DetailLabel *timeLabel;
@property (nonatomic, retain) DetailLabel *paceLabl;
@property (nonatomic, retain) DetailLabel *calLabel;

@property (nonatomic, retain) UIImageView *levelView;
@property (nonatomic, retain) UILabel *levelLabel;

@property (nonatomic, copy) CustomButton *addButton;
@property (nonatomic, copy) CustomButton *mainScreenButton;

- (void)showDataWithModel:(Activity *)model;

@end
