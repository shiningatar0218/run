//
//  TJProgressView.m
//  run1.2
//
//  Created by runner on 15/1/7.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "TJProgressView.h"
#import "define.h"

@implementation TJProgressView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.progress];
        [self addSubview:self.progressLabel];
        
    }
    
    return self;
}

- (UIProgressView *)progress {
    if (!_progress) {
        _progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, self.progressLabel.frame.size.height, self.frame.size.width, 5)];
        _progress.progressViewStyle = UIProgressViewStyleBar;
        _progress.tintColor = [UIColor orangeColor];
        _progress.trackTintColor = [UIColor lightGrayColor];
    }
    return _progress;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, self.frame.size.height-5)];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.textColor = NaVBarColor;
    }
    return _progressLabel;
}

@end
