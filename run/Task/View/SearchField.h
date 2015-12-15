//
//  SearchField.h
//  太平之家1.1
//
//  Created by rimi on 14/12/15.
//  Copyright (c) 2014年 rimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchField : UIView<UITextFieldDelegate>

@property (nonatomic,strong)UITextField *textFild;
@property (nonatomic,strong)NSString *searchText;
@property (nonatomic,strong)void (^endEding)();

- (instancetype)initWithFrame:(CGRect)frame searchImageSize:(CGRect)imageBounds placeholder:(NSString *)placeholder endEding:(void(^)(NSString *text))endEding;

@end
