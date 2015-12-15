//
//  MapViewController.m
//  run1.2
//
//  Created by runner on 15/1/14.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "MapViewController.h"
#import "SearchField.h"
#import "CustomButton.h"
#import "RegionAnnotation.h"
#import "RegionAnnotationView.h"

@interface MapViewController (){
    CGFloat _statusBar_hight;
    RegionAnnotation *_regionAnnotation;
    MKCircleView *circleView;
}

@property (nonatomic, retain) SearchField *searchField;

@end

@implementation MapViewController

- (instancetype)initWithDidGetAddressBlock:(didGetAddressBlock)didGetAddressCallback{
    if (self = [super init]) {
        
        if (didGetAddressCallback) {
            self.didGetAddressCallback = didGetAddressCallback;
        }
        
    }
    return self;
}

- (instancetype)initWithCLLocation:(CLLocation *)location {
    if (self = [super init]) {
        
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.mapView = nil;
    [self.locationManager stopUpdatingHeading];
    [self.locationManager stopMonitoringVisits];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _statusBar_hight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    self.searchField = [[SearchField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30) searchImageSize:CGRectMake(0, 0, 25, 25) placeholder:@"收索跑点" endEding:^(NSString *text) {
        
    }];
    [self.view addSubview:self.searchField];
    [self.view addSubview:self.mapView];
    CustomButton *sureButton = [[CustomButton alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.view.frame) - 35-_statusBar_hight-self.navigationController.navigationBar.frame.size.height,self.view.frame.size.width-10 ,30) NormalImage:nil selectImage:nil whenTouchUpInside:^{
        [super backToPop];
    }];
    
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setBackgroundColor:[UIColor grayColor]];
    self.mapView.frame = CGRectMake(5, CGRectGetMaxY(self.searchField.frame), self.view.frame.size.width-10, CGRectGetMinY(sureButton.frame)-self.searchField.frame.size.height);
    [self.view addSubview:sureButton];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.mapView addGestureRecognizer:longPress];
}

- (void)startUpdate {
    if (_locationManager) {
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark --CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
}

#pragma mark -- 长按选定地点
- (void)longPress:(UILongPressGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        if (!_regionAnnotation) {
            _regionAnnotation = [[RegionAnnotation alloc] init];
        }
        [_mapView removeAnnotation:_regionAnnotation];
        
        CGPoint point = [gesture locationInView:_mapView];
        [_regionAnnotation setTitle:@"获取中···"];
        [_regionAnnotation setCoordinate:[_mapView convertPoint:point toCoordinateFromView:_mapView]];
        
        _regionAnnotation.radius = 30.0;
        [_mapView addAnnotation:_regionAnnotation];
        MKCoordinateSpan span = MKCoordinateSpanMake(0.01f, 0.01f);//这个显示大小精度自己调整
        self.region = MKCoordinateRegionMake(_regionAnnotation.coordinate, span);
        [self.mapView setRegion:self.region animated:YES];
        [self startUpdate];
    }
}

#pragma mark - MKMapViewDelegate
// Custom AnnotationView
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString *reuserIndentifier = @"regin";
    RegionAnnotationView *annotationView = (RegionAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:reuserIndentifier];
    
    if (!annotationView) {
        annotationView = [[RegionAnnotationView alloc] initWithAnnotation:annotation];
        annotationView.map = self.mapView;
    }else {
        annotationView.annotation = annotation;
        annotationView.theAnnotation = annotation;
    }
    
    [annotationView updateRadiusOverlay];
    
    return annotationView;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    if([overlay isKindOfClass:[MKCircle class]]) {
        // Create the view for the radius overlay.
        if (!circleView) {
            circleView = [[MKCircleView alloc] initWithOverlay:overlay];
        }
        
        if (mapView.overlays.count >= 2) {
            [mapView removeOverlay:mapView.overlays[0]];
        }
        
        circleView.strokeColor = [UIColor redColor];
        circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
        
        return circleView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    CLLocation *pressLocation = [[CLLocation alloc] initWithLatitude:view.annotation.coordinate.latitude longitude:view.annotation.coordinate.longitude];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc ]init];
    [geocoder reverseGeocodeLocation:pressLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"逆编码出错：%@",error);
            [(MKPointAnnotation *)view.annotation setTitle:@"获取失败"];
        }else{
            [(MKPointAnnotation *)view.annotation setTitle:[placemarks[0] valueForKey:@"name"]];
            [(MKPointAnnotation *)view.annotation setSubtitle:[placemarks[0] valueForKey:@"administrativeArea"]];
            
            self.didGetAddressCallback ([placemarks[0] valueForKey:@"name"]);
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//查找用

- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, self.searchField.frame.size.height+2, self.view.frame.size.width, self.view.frame.size.height - self.searchField.frame.size.height - 4 - 30)];
        _mapView.mapType=MKMapTypeStandard;//设置地图的样式
        _mapView.zoomEnabled=YES;//是否允许缩放
        _mapView.scrollEnabled=YES;//是否允许滚动
        _mapView.showsUserLocation=YES;//是否允许显示当前的位置
        _mapView.userTrackingMode=MKUserTrackingModeFollowWithHeading;//设置用户跟随模式
        _mapView.delegate = self;
        [_mapView.userLocation setTitle:@"我在这里"];
    }
    return _mapView;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.distanceFilter = 1.0;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.activityType = CLActivityTypeOther;
        _locationManager.delegate = self;
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            //[_locationManager requestWhenInUseAuthorization];
            [self.locationManager requestAlwaysAuthorization];
        }
    }
    return _locationManager;
}

@end
