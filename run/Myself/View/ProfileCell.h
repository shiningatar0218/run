//
//  ProfileCell.h
//  run
//
//  Created by runner on 15/2/14.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserProfile.h"

typedef void(^endEditing)();

@interface ProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *runnerImage;
@property (weak, nonatomic) IBOutlet UITextField *family_name;
@property (weak, nonatomic) IBOutlet UITextField *first_name;

@property (nonatomic, retain) UserProfile *profileModel;

@property (nonatomic, copy) endEditing didEndEditing;

- (void)awakeFromNibWithModel:(UserProfile *)model endEditing:(endEditing)didEndEditing;
@end
