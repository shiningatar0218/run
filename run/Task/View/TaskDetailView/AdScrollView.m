//
//  AdScrollView.m
//  run1.2
//
//  Created by runner on 15/1/16.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "AdScrollView.h"
#import "define.h"

@interface AdScrollView ()<UIScrollViewDelegate>
{
    NSMutableArray *_adViews;
}

@property (nonatomic, strong) UILabel *noticeLabel;
@property (nonatomic, strong) UIScrollView *adScrollView;

@end

@implementation AdScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.noticeLabel];
        [self addSubview:self.adScrollView];
        
        [self showAd];
    }
    return self;
}



#pragma mark -- 广告

- (void)showAd {
    
    
    self.notice = @"4555654545454544545454ugiugiugkj";
    
    if (!_adViews) {
        _adViews = [NSMutableArray arrayWithCapacity:0];
    }else{
        [_adViews removeAllObjects];
    }
    
    for (int i = 0; i < self.adArray.count; i ++) {
        
        
        UIView *adView = [[UIView alloc] initWithFrame:CGRectMake(i*self.adScrollView.frame.size.width, self.noticeLabel.frame.size.height, self.adScrollView.frame.size.width, self.adScrollView.frame.size.height-self.noticeLabel.frame.size.height)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.adScrollView.frame.size.width/3*2, 0, self.adScrollView.frame.size.width/3-20, self.adScrollView.frame.size.height-self.noticeLabel.frame.size.height)];
        
        UILabel *adLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.adScrollView.frame.size.width/3*2-10, self.adScrollView.frame.size.height-self.noticeLabel.frame.size.height)];
        adLabel.numberOfLines = 0;
        adLabel.textAlignment = NSTextAlignmentLeft;
        
        
        
        adLabel.text = [self.adArray[i] objectForKey:@"ad_text"];
        imageView.image = [UIImage imageNamed:[self.adArray[i] objectForKey:@"ad_pic"]];
        
        
        
        [adView addSubview:imageView];
        [adView addSubview:adLabel];
        
        [self.adScrollView addSubview:adView];
        [_adViews addObject:adView];
    }
    
    [self.adScrollView setContentSize:CGSizeMake(self.adScrollView.frame.size.width*_adViews.count, self.adScrollView.frame.size.height)];
    
}

- (NSMutableArray *)adArray {
    if (!_adArray) {
        _adArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < 3; i++) {
            NSDictionary *dic = @{@"ad_text": @"完成任务，并记录装备信息，将以5折购得sahara 快干衣",
                                  @"ad_pic":@"t-shirt.png"};
            [_adArray addObject:dic];
        }
    }
    return _adArray;
}

- (UIScrollView *)adScrollView {
    if (!_adScrollView) {
        _adScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.noticeLabel.frame.size.height, self.frame.size.width, self.frame.size.height - self.noticeLabel.frame.size.height)];
        _adScrollView.delegate = self;
        _adScrollView.pagingEnabled = YES;
        _adScrollView.bounces = NO;
    }
    return _adScrollView;
}


#pragma mark -- 公告
- (UILabel *)noticeLabel {
    if (!_noticeLabel) {
        _noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        _noticeLabel.font = BOLD_18_FONT;
        _noticeLabel.textAlignment = NSTextAlignmentCenter;
        
        _noticeLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
    return _noticeLabel;
}

- (void)setNotice:(NSString *)notice {
    _notice = notice;
    [self setNoticeLabelText:_notice];
}

//设置公告信息
- (void)setNoticeLabelText:(NSString *)text {
    self.noticeLabel.text = text;
    CGRect withRect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.noticeLabel.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine|
    NSStringDrawingUsesLineFragmentOrigin|
    NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.noticeLabel.font} context:nil];
    self.noticeLabel.bounds = withRect;
    
    if (self.noticeLabel.bounds.size.width > self.frame.size.width) {
        [self noticeStatScroll];
    }
}
//公告滚动
- (void)noticeStatScroll {
    
    [UIView animateWithDuration:10 animations:^{
        self.noticeLabel.center = CGPointMake(self.noticeLabel.center.x - self.noticeLabel.frame.size.width,self.noticeLabel.center.y);
    } completion:^(BOOL finished) {
        [self rootScroll];
    }];
}

- (void)rootScroll {
    self.noticeLabel.center = CGPointMake(self.noticeLabel.frame.size.width/2*3, self.noticeLabel.center.y);
    [UIView animateWithDuration:10 animations:^{
        self.noticeLabel.center = CGPointMake(self.noticeLabel.center.x - 2*self.noticeLabel.frame.size.width,self.noticeLabel.center.y);
    } completion:^(BOOL finished) {
        [self rootScroll];
    }];
}

@end
