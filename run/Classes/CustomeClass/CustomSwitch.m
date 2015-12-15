//
//  CustomSwitch.m
//  run
//
//  Created by runner on 15/2/11.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "CustomSwitch.h"
#import "define.h"

@interface CustomSwitch ()

@property (nonatomic, copy)didChangeValue valueChanged;

@end

@implementation CustomSwitch

- (instancetype)initWithValueChanged:(didChangeValue) valueChanged {
    self = [super init];
    if (self) {
        
        if (valueChanged) {
            self.valueChanged = valueChanged;
        }
        self.on = YES;
        
        self.onTintColor = NaVBarColor;
        
        [self addTarget:self action:@selector(didValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)didValueChanged:(id)sender {
    
    self.valueChanged (self.on);
}

@end
