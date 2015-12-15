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

@interface MapViewController : CustomViewController<MKMapViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, copy)didGetAddressBlock didGetAddressCallback;
@property (nonatomic, retain)MKMapView *mapView;
@property (nonatomic, retain)CLLocationManager *locationManager;
@property (nonatomic, readwrite)MKCoordinateRegion region;


- (instancetype)initWithDidGetAddressBlock:(didGetAddressBlock)didGetAddressCallback;

@end
