//
//  CustomSwitch.h
//  run
//
//  Created by runner on 15/2/11.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^didChangeValue)(BOOL on);
@interface CustomSwitch : UISwitch

- (instancetype)initWithValueChanged:(didChangeValue) valueChanged;

@end
