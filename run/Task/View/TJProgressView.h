//
//  TJProgressView.h
//  run1.2
//
//  Created by runner on 15/1/7.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJProgressView : UIView

@property (nonatomic, retain) UIProgressView *progress;
@property (nonatomic, retain) UILabel *progressLabel;

- (id)initWithFrame:(CGRect)frame;

@end
