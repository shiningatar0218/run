//
//  PhotoScrollerView.m
//  run
//
//  Created by runner on 15/2/12.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "PhotoScrollerView.h"
#import "define.h"

@interface PhotoScrollerView ()<UIScrollViewDelegate>


@property (nonatomic, retain) UIScrollView *scrollerView;
@property (nonatomic, retain) NSMutableArray *imageArray;
@end

@implementation PhotoScrollerView

- (instancetype)initWithFrame:(CGRect)frame ImageData:(NSMutableArray *)array {
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor whiteColor];
        self.imageArray = array;
        [self addSubview:self.scrollerView];
        for (int i = 0; i < array.count; i ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(70+5)+5, 5, 70, 70)];
            imageView.layer.borderWidth = 1;
            imageView.layer.shadowOffset = CGSizeMake(1, 1);
            imageView.layer.shadowOpacity = 0.5;
            imageView.layer.shadowRadius = 10;
            imageView.layer.shadowColor = NaVBarColor.CGColor;
            imageView.layer.borderColor = NaVBarColor.CGColor;
            imageView.image = array[i];
            [self.scrollerView addSubview:imageView];
        }
        self.scrollerView.contentSize = CGSizeMake((75+5)*(array.count-1)+5, self.frame.size.height);
        
    }
    
    return self;
}


- (UIScrollView *)scrollerView {
    if (!_scrollerView) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollerView.scrollEnabled = YES;
        _scrollerView.backgroundColor = [UIColor whiteColor];
        _scrollerView.showsHorizontalScrollIndicator = YES;
        _scrollerView.showsVerticalScrollIndicator = NO;
        _scrollerView.alwaysBounceHorizontal = YES;
        _scrollerView.delegate = self;
    }
    return _scrollerView;
}


@end
