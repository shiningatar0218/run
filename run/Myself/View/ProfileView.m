//
//  ProfileView.m
//  run1.2
//
//  Created by runner on 15/1/22.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "ProfileView.h"
#import "define.h"
#import "LineView.h"
#import "DataModel.h"
#import "CoreDataManager.h"

@interface ProfileView ()
{
    CGFloat image_Height;
    CGFloat button_Height;
    CGFloat button_with;
    
    CustomButton *_friendButton;
    CustomButton *_groupButton;
    CustomButton *_chatButton;
    CustomButton *_runButton;
    CustomButton *_cycleButton;
    
    UIButton *_shadeButton;
}

@end

@implementation ProfileView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        image_Height = iPhone4 ? 40.0 : 60;
        button_Height = (self.frame.size.height - image_Height)/2.0;
        button_with = self.frame.size.width/3.0;
        [self addSubview:self.imageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.addressLabel];
        [self addSubview:self.imageLabel];
        
        [self layoutButtons];
    }
    return self;
}

- (void)reLoadData {
    //self.imageView.image = self.profileModel.image;
    self.nameLabel.title = self.profileModel.nick;
    self.nameLabel.text = [NSString stringWithFormat:@"  0岁"];
    self.addressLabel.text = [NSString stringWithFormat:@"%@, %@",self.profileModel.street,self.profileModel.city_id];
    self.imageLabel.text = [NSString stringWithFormat:@"%@",self.profileModel.level];
}

- (UserProfile *)profileModel {
    
    if (!_profileModel) {
        
        NSArray *array = [UserProfile MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"user_id IN %@",@[DATAMODEL.userId]]];
        if (array.count > 0) {
            _profileModel = [array lastObject];
        }
    }
    return _profileModel;
}

- (void)layoutButtons {
    [self addSubview:[LineView LineViewWithFrame:CGRectMake(0, image_Height, self.frame.size.width, 1) color:BackGroundColor]];
    
    [self addSubview:[LineView LineViewWithFrame:CGRectMake(0, image_Height+button_Height, self.frame.size.width, 1) color:BackGroundColor]];
    [self addSubview:[LineView LineViewWithFrame:CGRectMake(self.frame.size.width/3.0, image_Height, 1, button_Height) color:BackGroundColor]];
    [self addSubview:[LineView LineViewWithFrame:CGRectMake(self.frame.size.width/3.0*2, image_Height, 1, button_Height) color:BackGroundColor]];
    [self addSubview:[LineView LineViewWithFrame:CGRectMake(self.frame.size.width/2.0, image_Height+button_Height, 1, button_Height) color:BackGroundColor]];
    
    
//好友
    _friendButton = [[CustomButton alloc] initWithFrame:CGRectMake(0, image_Height, self.frame.size.width/3.0, button_Height) Title:@"25好友" WhenTouchUpinside:^(id sender){
        
    }];
//群组
    _groupButton = [[CustomButton alloc] initWithFrame:CGRectMake(self.frame.size.width/3.0, image_Height, button_with, button_Height) Title:@"2群组" WhenTouchUpinside:^(id sender){
        
    }];
    
    
//聊天
    _chatButton = [[CustomButton alloc] initWithFrame:CGRectMake(button_with*2, image_Height, button_with, button_Height) NormalImage:nil selectImage:nil whenTouchUpInside:^(id sender){
        
    }];
    [_chatButton setImage:[UIImage imageNamed:@"my_icon_add_friend.png"] forState:UIControlStateNormal];
//跑步
    _runButton = [[CustomButton alloc] initWithFrame:CGRectMake(0, image_Height+button_Height, self.frame.size.width/2.0, button_Height) Title:@"跑步" WhenTouchUpinside:^(id sender){
        [self moveShadeButton:_runButton];
    }];
    _runButton.enabled = NO;
//骑车
    _cycleButton = [[CustomButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2.0, image_Height+button_Height, self.frame.size.width/2.0, button_Height) Title:@"骑车" WhenTouchUpinside:^(id sender){
        [self moveShadeButton:_cycleButton];
    }];
    
    _shadeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shadeButton setFrame:_runButton.frame];
    [_shadeButton setBackgroundColor:NaVBarColor];
    
    [self addSubview:_shadeButton];
    [self addSubview:_friendButton];
    [self addSubview:_groupButton];
    [self addSubview:_chatButton];
    [self addSubview:_runButton];
    [self addSubview:_cycleButton];
}

- (ImageLabel *)imageLabel {
    if (!_imageLabel) {
        _imageLabel = [[ImageLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame)+5, 0, self.frame.size.width - CGRectGetMaxX(self.nameLabel.frame) - 5, image_Height)];
        
        _imageLabel.image = [UIImage imageNamed:@"my_level.png"];
    }
    
    return _imageLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, image_Height-10, image_Height-10)];
        _imageView.image = [UIImage imageNamed:@"my_icon_woman.png"];
//        _imageView.layer.borderWidth = 1;
//        _imageView.layer.borderColor = layColor;
//        _imageView.layer.cornerRadius = _imageView.frame.size.height/2.0;
    }
    return _imageView;
}

- (LabelTitle *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[LabelTitle alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame), 0, self.frame.size.width/2.0-self.imageView.frame.size.width, image_Height/2.0) title:nil text:nil textColor:nil];
        
        _nameLabel.textLabel.font = iPhone4 ? SYSTEM_10_FONT : SYSTEM_12_FONT;
    }
    return _nameLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame), self.nameLabel.frame.size.height, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height)];
        
        _addressLabel.font = iPhone4 ? SYSTEM_12_FONT : SYSTEM_14_FONT;
    }
    
    return _addressLabel;
}


- (void)moveShadeButton:(CustomButton *)sender{
    _shadeButton.enabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _shadeButton.frame = sender.frame;
    } completion:^(BOOL finished) {
        _shadeButton.enabled = YES;
        
        if (_shadeButton.frame.origin.x == _runButton.frame.origin.x) {
            _runButton.enabled = NO;
            _cycleButton.enabled = YES;
        }else {
            _cycleButton.enabled = NO;
            _runButton.enabled = YES;
        }
        
    }];
}

@end
