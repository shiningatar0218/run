//
//  EditCell.m
//  run1.2
//
//  Created by runner on 15/1/23.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "EditCell.h"

@implementation EditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.titleLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}



- (LabelTitle *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[LabelTitle alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width, self.frame.size.height) title:nil text:nil textColor:[UIColor lightGrayColor]];
    }
    return _titleLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
