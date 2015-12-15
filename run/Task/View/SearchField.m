//
//  SearchField.m
//  太平之家1.1
//
//  Created by rimi on 14/12/15.
//  Copyright (c) 2014年 rimi. All rights reserved.
//

#import "SearchField.h"
#import "CustomButton.h"

@implementation SearchField

- (instancetype)initWithFrame:(CGRect)frame searchImageSize:(CGRect)imageBounds placeholder:(NSString *)placeholder endEding:(void(^)(NSString *text))endEding{
    self = [super initWithFrame:frame];
    if (self) {
        if (endEding) {
            self.endEding = endEding;
        }
        
        UIImageView *backImage = [[UIImageView alloc] initWithFrame:self.bounds];
        backImage.image = [UIImage imageNamed:@"task_search.png"];
        [self addSubview:backImage];
        
//        self.backgroundColor = [UIColor whiteColor];
//        self.layer.cornerRadius = 10;
//        self.layer.borderWidth = 1;
//        self.clipsToBounds = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageBounds];
        imageView.center = CGPointMake(self.frame.size.height/2, self.frame.size.height/2);
        imageView.image = [UIImage imageNamed:@"搜索.png"];
        [self addSubview:imageView];
        
        _textFild = [[UITextField alloc] initWithFrame:CGRectMake(self.frame.size.height, 0, self.frame.size.width-self.frame.size.height-80, self.frame.size.height)];
        _textFild.backgroundColor = [UIColor clearColor];
        _textFild.placeholder = placeholder;
        _textFild.tintColor = [UIColor cyanColor];
        _textFild.delegate = self;
        [self addSubview:_textFild];
        _textFild.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textFild.keyboardAppearance = UIKeyboardAppearanceLight;
        _textFild.returnKeyType = UIReturnKeySearch;
        
        CustomButton *searchButton = [[CustomButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_textFild.frame), 0, self.frame.size.width-CGRectGetMaxX(_textFild.frame), self.frame.size.height) Title:@"搜索" WhenTouchUpinside:^(id sender) {
            [_textFild resignFirstResponder];
            self.endEding(_textFild.text);
        }];
        searchButton.backgroundColor = [UIColor clearColor];
        [self addSubview:searchButton];
    }
    return self;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    _searchText = textField.text;
    if (_endEding) {
        _endEding(textField.text);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    _textFild.text = textField.text;
    _searchText = textField.text;
    return YES;
}



@end
