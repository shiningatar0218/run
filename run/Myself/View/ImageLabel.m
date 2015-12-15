//
//  ImageLabel.m
//  run1.2
//
//  Created by runner on 15/1/22.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "ImageLabel.h"

@implementation ImageLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self addSubview:self.imageView];
        [self addSubview:self.textLabel];
        
        
    }
    return self;
}

- (void)setText:(NSString *)text {
    _text = text;
    self.textLabel.text = _text;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.textLabel.title = _title;
}

- (LabelTitle *)textLabel {
    if (!_textLabel) {
        _textLabel = [[LabelTitle alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame), 0, self.frame.size.width-self.imageView.frame.size.width,self.frame.size.height) title:nil text:nil textColor:nil];
        
        _textLabel.center = CGPointMake(_textLabel.center.x, self.frame.size.height/2.0);
        
    }
    return _textLabel;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = _image;
    _imageView.bounds = CGRectMake(0, 0, _imageView.image.size.width, _imageView.image.size.height);
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.height)];
    }
    
    return _imageView;
}



@end
