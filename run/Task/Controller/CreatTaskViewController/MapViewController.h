//
//  MapViewController.h
//  run1.2
//
//  Created by runner on 15/1/14.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "CustomViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MapView.h"

typedef void (^didGetAddressBlock)(NSString *address);

@interface MapViewController : CustomViewController

- (instancetype)initWithDidGetAddressBlock:(didGetAddressBlock)didGetAddressCallback;

@end
