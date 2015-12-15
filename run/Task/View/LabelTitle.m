//
//  LabelTitle.m
//  太平之家1.1
//
//  Created by rimi on 14/12/17.
//  Copyright (c) 2014年 rimi. All rights reserved.
//

#import "LabelTitle.h"
#import "define.h"

@interface LabelTitle ()<UITextFieldDelegate>
{
    UILabel *_label;
}



@end

@implementation LabelTitle

@synthesize text = _text;
@synthesize font = _font;
@synthesize textField = _textField;
@synthesize textLabel = _textLabel;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title text:(NSString *)text textColor:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.text = title;
        _label.font = [UIFont systemFontOfSize:iPhone4?14:16];
        _label.textAlignment = NSTextAlignmentRight|NSTextAlignmentCenter;
        
        CGRect autoSize = [title boundingRectWithSize:CGSizeMake(100, self.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_label.font} context:nil];
        _label.frame = CGRectMake(0, 0, autoSize.size.width, frame.size.height);
        
        [self addSubview:_label];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(_label.frame.size.width, 0, frame.size.width-_label.frame.size.width-5, frame.size.height)];
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.font = [UIFont systemFontOfSize:iPhone4?14:16];
        _textLabel.text = text;
        _textLabel.textColor = color;
        
        [self addSubview:_textLabel];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title placeholder:(NSString *)text {
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.text = title;
        _label.font = [UIFont systemFontOfSize:iPhone4?14:16];
        _label.textAlignment = NSTextAlignmentRight;
        
        CGRect autoSize = [title boundingRectWithSize:CGSizeMake(100, self.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_label.font} context:nil];
        _label.frame = CGRectMake(0, 0, autoSize.size.width, frame.size.height);
        
        [self addSubview:_label];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(_label.frame.size.width, 0, frame.size.width-_label.frame.size.width-5, frame.size.height)];
        _textField.placeholder = text;
        _textField.font = [UIFont systemFontOfSize:iPhone4?14:16];
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.delegate = self;
        
        [self addSubview:_textField];
    }
    return self;
}

- (void)setText:(NSString *)text {
    _text = text;
    
    if (_textField) {
        _textField.text = text;
    }
    if (_textLabel) {
        _textLabel.text = text;
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _label.text = _title;
    
    CGRect autoSize = [_label.text boundingRectWithSize:CGSizeMake(100, self.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_label.font} context:nil];
    _label.frame = CGRectMake(0, 0, autoSize.size.width, self.frame.size.height);
    _textLabel.frame = CGRectMake(_label.frame.size.width, 0, self.frame.size.width-_label.frame.size.width-5, self.frame.size.height);
}

- (void)setFont:(UIFont *)font {
    _font = font;
    _textLabel.font = font;
    _label.font = font;

    CGRect autoSize = [_label.text boundingRectWithSize:CGSizeMake(100, self.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_label.font} context:nil];
    _label.frame = CGRectMake(0, 0, autoSize.size.width, self.frame.size.height);
    _textLabel.frame = CGRectMake(_label.frame.size.width, 0, self.frame.size.width-_label.frame.size.width-5, self.frame.size.height);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    self.text = textField.text;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    __weak EndEdit myBlock = self.didendEditing;
    if (self.didendEditing) {
        myBlock (textField.text);
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    __weak BeginEdit myBlock = self.didBeginEditing;
    if (self.didBeginEditing) {
        myBlock ();
    }
}

- (void)didendEditing:(EndEdit)didendEditing {
    if (didendEditing) {
        self.didendEditing = didendEditing;
    }
}

- (void)didBeginEditing:(BeginEdit)didBeginEditing {
    if (didBeginEditing) {
        self.didBeginEditing = didBeginEditing;
    }
}


- (void)dealloc {
    self.didBeginEditing = nil;
    self.didendEditing = nil;
    
    NSLog(@"label title   release!!!");
}

@end

