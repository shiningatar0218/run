//
//  CustomTextView.m
//  run
//
//  Created by runner on 15/2/11.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "CustomTextView.h"

@interface CustomTextView ()<UITextViewDelegate>

@property (nonatomic,copy)endEditing completion;

@end

@implementation CustomTextView

- (instancetype)initWithFrame:(CGRect)frame endEditing:(endEditing)completion {
    self = [super initWithFrame:frame];
    if (self) {
        
        if (completion) {
            self.completion = completion;
        }
        
        [self addSubview:self.textView];
        
    }
    
    return self;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.completion (textView.text);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    self.text = textView.text;
    return YES;
}


- (NSString *)text {
    _text = self.textView.text;
    return _text;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:self.bounds];
        
        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textView.layer.borderWidth = 1.0;
        
        _textView.backgroundColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:18];
        _textView.returnKeyType = UIReturnKeyDone;
    }
    return _textView;
}


@end
