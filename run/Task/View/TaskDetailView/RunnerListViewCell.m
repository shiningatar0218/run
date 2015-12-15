//
//  RunnerListViewCell.m
//  run1.2
//
//  Created by runner on 15/1/16.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "RunnerListViewCell.h"
#import "TaskMember.h"
#import "define.h"
//#import <SDWebImage/UIImageView+WebCache.h>

@interface RunnerListViewCell ()
{
    
}

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *userImage;
@property (nonatomic, strong) UILabel *paceLabel;
@property (nonatomic, strong) UILabel *distanceLabel;

@end

@implementation RunnerListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addSubview:self.userImage];
        [self addSubview:self.nameLabel];
        [self addSubview:self.paceLabel];
        [self addSubview:self.distanceLabel];
        self.textLabel.font = kMainScreenWidth >= 375 ? cell_Font_big : cell_Font_small;
    }
    
    return self;
}
/////////////////***********************数据
- (void)loadDataWithModel:(TaskMember *)model {
    self.nameLabel.text = model.nick_name;
    self.paceLabel.text = [NSString stringWithFormat:@"%@/km",model.pace];
    self.distanceLabel.text = [NSString stringWithFormat:@"%0.fkm",model.distance];
    //[self.imageView setImageWithURL:model.image];
}

- (UIImageView *)userImage {
    if (!_userImage) {
        _userImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth/4.0, 2, self.frame.size.height, self.frame.size.height-4)];
        _userImage.clipsToBounds = YES;
        _userImage.layer.cornerRadius = _userImage.frame.size.height/2;
        _userImage.image = [UIImage imageNamed:@"my_icon_man.png"];
    };
    return _userImage;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userImage.frame), 0, 60, self.frame.size.height)];
        _nameLabel.font = kMainScreenWidth >= 375 ? cell_Font_big : cell_Font_small;
    }
    return _nameLabel;
}

- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth/4.0*3, 0, 60, self.frame.size.height)];
        _distanceLabel.textAlignment = NSTextAlignmentCenter;
        
        _distanceLabel.font = kMainScreenWidth >= 375 ? cell_Font_big : cell_Font_small;
    }
    return _distanceLabel;
}

- (UILabel *)paceLabel {
    if (!_paceLabel) {
        _paceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth/2.0 , 0, 60, self.frame.size.height)];
        
        _paceLabel.textAlignment = NSTextAlignmentCenter;
        
        _paceLabel.font = kMainScreenWidth >= 375 ? cell_Font_big : cell_Font_small;
    }
    return _paceLabel;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
