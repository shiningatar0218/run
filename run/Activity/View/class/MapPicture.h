//
//  MapPicture.h
//  run
//
//  Created by runner on 15/3/26.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapPicture : UIView

- (instancetype)initWithFrame:(CGRect)frame withImage:(UIImage *)image withRoutePoints:(NSArray *)points;

- (UIImage *)cutPictureInRect:(CGRect)rect;

@end
