//
//  CustomButton.h
//  run1.2
//
//  Created by runner on 15/1/5.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^didTouchUpInside)(id sender);
@interface CustomButton : UIButton

@property (copy)void(^completion)(id sender);
@property (nonatomic,strong)NSString *normalImage;
@property (nonatomic,strong)NSString *selectImage;

- (id)initWithFrame:(CGRect)frame NormalImage:(NSString *)normalImage selectImage:(NSString *)selectImage  whenTouchUpInside:(void(^)(id sender))completion;

- (id)initWithFrame:(CGRect)frame Title:(NSString *)title WhenTouchUpinside:(void(^)(id sender))completion;

@end
