//
//  ProfileView.h
//  run1.2
//
//  Created by runner on 15/1/22.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelTitle.h"
#import "ImageLabel.h"
#import "CustomButton.h"
#import "User.h"

@interface ProfileView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) LabelTitle *nameLabel;
@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) ImageLabel *imageLabel;


@property (nonatomic, strong) NSString *number_friends;
@property (nonatomic, strong) NSString *number_groups;


@property (nonatomic, strong) UserProfile *profileModel;


- (void)reLoadData;

@end
