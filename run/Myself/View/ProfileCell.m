//
//  ProfileCell.m
//  run
//
//  Created by runner on 15/2/14.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "ProfileCell.h"
#import "define.h"
#import "DataModel.h"

@interface ProfileCell ()<UITextFieldDelegate>
{
    
}

@end

@implementation ProfileCell

- (void)awakeFromNibWithModel:(UserProfile *)model endEditing:(endEditing)didEndEditing{
    
    if (didEndEditing) {
        self.didEndEditing = didEndEditing;
    }
    self.family_name.delegate = self;
    self.first_name.delegate = self;
    self.profileModel = model;
    
    self.family_name.text = self.profileModel.family_name;
    self.first_name.text = self.profileModel.first_name;
    [self.runnerImage setImage:[UIImage imageNamed:@"my_icon_woman.png"]];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.didEndEditing();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
