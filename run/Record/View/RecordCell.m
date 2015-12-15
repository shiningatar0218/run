//
//  RecordCell.m
//  run
//
//  Created by runner on 15/2/10.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "RecordCell.h"
#import "define.h"
#import "CustomButton.h"
#import "DataModel.h"

@interface RecordCell ()
{
    CustomButton *_praiseButton;
    CustomButton *_commentButton;
    CustomButton *_shareButton;
}

@end

@implementation RecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, kMainScreenWidth, 160.0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.mapImage];
        [self addSubview:self.whiterView];
    }
    
    return self;
}

- (void)showDataWithModel:(Activity *)model {
    NSString *string = model.file_url;
    
    NSInteger count = 0;
    int user_id = [model.user_id intValue];
    while (user_id) {
        user_id /= 10;
        count ++;
    }
    NSString *fileName = @"";
    if (string.length > 0) {
        NSRange range = [string rangeOfString:@".txt"];
        fileName = [string substringWithRange:NSMakeRange(range.location - 12 - count-1, 12 + count + 1)];
    }
    NSString *imageName = [NSString stringWithFormat:@"%@.png",fileName];
    self.mapImage.image = [DATAMODEL setActivityImage:imageName];
}

- (UIView *)whiterView {
    if (!_whiterView) {
        _whiterView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/4*3, kMainScreenWidth, self.frame.size.height/4)];
        _whiterView.backgroundColor = [UIColor whiteColor];
        _whiterView.alpha = 0.75;
        
        _praiseButton = [[CustomButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 70, 0, _whiterView.frame.size.height, _whiterView.frame.size.height) NormalImage:@"record_praise_normal.png" selectImage:@"record_praise_press.png" whenTouchUpInside:^(id sender) {
            if ([sender isKindOfClass:[CustomButton class]]) {
                CustomButton *button = sender;
                [button setImage:[UIImage imageNamed:button.selectImage] forState:UIControlStateNormal];
            }
        }];
        
        _commentButton = [[CustomButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_praiseButton.frame) - 60, 0, _whiterView.frame.size.height, _whiterView.frame.size.height) NormalImage:@"record_comment_normal.png" selectImage:@"record_comment_press.png" whenTouchUpInside:^(id sender) {
            if ([sender isKindOfClass:[CustomButton class]]) {
                CustomButton *button = sender;
                [button setImage:[UIImage imageNamed:button.selectImage] forState:UIControlStateNormal];
            }
        }];
        
        _shareButton = [[CustomButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_commentButton.frame) - 70, 0, _whiterView.frame.size.height, _whiterView.frame.size.height) NormalImage:@"record_share_normal.png" selectImage:@"record_share_press.png" whenTouchUpInside:^(id sender) {
            if ([sender isKindOfClass:[CustomButton class]]) {
                CustomButton *button = sender;
                [button setImage:[UIImage imageNamed:button.selectImage] forState:UIControlStateNormal];
            }
        }];
        
        
        [_whiterView addSubview:_praiseButton];
        [_whiterView addSubview:_commentButton];
        [_whiterView addSubview:_shareButton];
    }
    return _whiterView;
}

- (UIImageView *)mapImage {
    if (!_mapImage) {
        _mapImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,kMainScreenWidth, self.frame.size.height)];
    }
    return _mapImage;
}


- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
