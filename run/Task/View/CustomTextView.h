//
//  CustomTextView.h
//  run
//
//  Created by runner on 15/2/11.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^endEditing)(NSString *text);

@interface CustomTextView : UIView

@property (nonatomic, retain)NSString *text;
@property (nonatomic, retain)UITextView *textView;

- (instancetype)initWithFrame:(CGRect)frame endEditing:(endEditing)completion;

@end
