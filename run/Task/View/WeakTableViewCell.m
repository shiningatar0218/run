//
//  WeakTableViewCell.m
//  run1.2
//
//  Created by runner on 15/1/12.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "WeakTableViewCell.h"
#import "define.h"

@implementation WeakTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addSubview:self.selectCell];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectCell.hidden = !self.selectCell.hidden;
}

- (UIImageView *)selectCell {
    if (!_selectCell) {
        _selectCell = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth - 50, 0, 25, 25)];
        _selectCell.center = CGPointMake(_selectCell.center.x, self.frame.size.height/2);
        _selectCell.image = [UIImage imageNamed:@"task_time_selected.png"];
        _selectCell.hidden = NO;
    }
    
    return _selectCell;
}

@end
