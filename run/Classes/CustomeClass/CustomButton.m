//
//  CustomButton.m
//  run1.2
//
//  Created by runner on 15/1/5.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "CustomButton.h"

typedef void(^didTouchUpInside)(id sender);

@interface CustomButton ()

@end

@implementation CustomButton

- (id)initWithFrame:(CGRect)frame NormalImage:(NSString *)normalImage selectImage:(NSString *)selectImage  whenTouchUpInside:(void(^)(id sender))completion {
    self = [super initWithFrame:frame];
    if (self) {
        
        if (completion) {
            self.completion = completion;
        }
        self.normalImage = normalImage;
        self.selectImage = selectImage;
        
        [self setImage:[UIImage imageNamed:_normalImage] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:self.selectImage] forState:UIControlStateHighlighted];
        [self addTarget:self action:@selector(touched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame Title:(NSString *)title WhenTouchUpinside:(void(^)(id sender))completion {
    self = [super initWithFrame:frame];
    if (self) {

        
        if (completion) {
            self.completion = completion;
        }

        
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(touched:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)touched:(CustomButton *)sender {
    NSLog(@"%@",_completion);
    
    __weak didTouchUpInside myBlock = self.completion;
    
    if (self.completion) {
        myBlock(sender);
    }
}

- (void)dealloc {
    NSLog(@"button release!!!");
}

@end
