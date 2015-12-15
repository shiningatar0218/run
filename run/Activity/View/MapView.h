//
//  MapView.h
//  run1.2
//
//  Created by runner on 14/12/31.
//  Copyright (c) 2014年 runner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "define.h"

@interface MapView : UIView<MKMapViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, assign) BOOL startActivity;

- (void)startUpDate;
- (void)buildMap;
- (void)freaMap;
- (void)beginingActivity;
- (void)paseActivity;
- (void)startUpDateAndShowRuteWithPoints:(NSArray *)points;

@end
