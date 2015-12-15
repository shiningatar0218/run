//
//  MapPicture.m
//  run
//
//  Created by runner on 15/3/26.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "MapPicture.h"
#import <QuartzCore/QuartzCore.h>

@interface MapPicture ()
{
    
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSArray *points;

@end


@implementation MapPicture

- (instancetype)initWithFrame:(CGRect)frame withImage:(UIImage *)image withRoutePoints:(NSArray *)points{
    self = [super initWithFrame:frame];
    if (self) {
        _image = image;
        _points = points;
        [self setNeedsDisplayInRect:frame];
    }
    
    return self;
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    CGContextSetLineWidth(context, 2.0);
    [self.image drawInRect:self.bounds];
    
    CGPoint points[self.points.count];
    for (int i = 0; i < self.points.count; i++) {
        CGPoint point = [self.points[i] CGPointValue];
        
        points[i] = point;
    }
    CGContextAddLines(context, points, self.points.count);
    CGContextDrawPath(context, kCGPathStroke);
    
}

- (UIImage *)cutPictureInRect:(CGRect)rect {
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 0);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
 
    //UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    
    return image;
    
}


@end
