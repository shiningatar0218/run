//
//  ImageLabel.h
//  run1.2
//
//  Created by runner on 15/1/22.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelTitle.h"

@interface ImageLabel : UIView

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *title;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) LabelTitle *textLabel;

@end
