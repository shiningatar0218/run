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

@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>{
    CGFloat _statusBar_hight;
    RegionAnnotation *_regionAnnotation;
    MKCircleView *circleView;
    
    CustomButton *_sureButton;
}

@property (atomic, copy)didGetAddressBlock didGetAddressCallback;
@property (nonatomic, retain)MKMapView *mapView;
@property (nonatomic, retain)CLLocationManager *locationManager;
@property (nonatomic, readwrite)MKCoordinateRegion region;

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

- (void)dealloc {
    _sureButton = nil;
    _mapView.delegate = nil;
    _locationManager.delegate = nil;
    _locationManager = nil;
    _didGetAddressCallback = nil;
    _mapView = nil;
    NSLog(@"map viewcontroller release!!!");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startUpdate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingHeading];
    [self.locationManager stopMonitoringVisits];
    _sureButton.completion = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = self.mapView;
    _statusBar_hight = [UIApplication sharedApplication].statusBarFrame.size.height;
    self.searchField = [[SearchField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50) searchImageSize:CGRectMake(0, 0, 25, 25) placeholder:@"收索跑点" endEding:^(NSString *text) {
        
    }];
    
    [self.view addSubview:self.searchField];
    [self.view bringSubviewToFront:self.searchField];
    //[self.view addSubview:self.mapView];
     _sureButton = [[CustomButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.view.frame) - 50-_statusBar_hight-self.navigationController.navigationBar.frame.size.height,self.view.frame.size.width-20 ,40) NormalImage:nil selectImage:nil whenTouchUpInside:^(id sender){
         
         __weak CustomButton *surebutton = sender;
         surebutton = nil;
         
        [super backToPop];
    }];
    
    [_sureButton setBackgroundImage:[UIImage imageNamed:@"task_button_add.png"] forState:UIControlStateNormal];
    [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
    self.mapView.frame = CGRectMake(5, CGRectGetMaxY(self.searchField.frame), self.view.frame.size.width-10, CGRectGetMinY(_sureButton.frame)-self.searchField.frame.size.height);
    [self.view addSubview:_sureButton];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.mapView addGestureRecognizer:longPress];
}

- (void)startUpdate {
    CLLocationCoordinate2D center = self.mapView.userLocation.location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01f, 0.01f);//这个显示大小精度自己调整
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [self.mapView setRegion:region animated:YES];
    [self.locationManager startUpdatingLocation];
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
        
        _regionAnnotation.radius = 300.0;
        [_mapView addAnnotation:_regionAnnotation];
        MKCoordinateSpan span = MKCoordinateSpanMake(0.01f, 0.01f);//这个显示大小精度自己调整
        self.region = MKCoordinateRegionMake(_regionAnnotation.coordinate, span);
        [self.mapView setRegion:self.region animated:YES];

        [self.mapView selectAnnotation:_regionAnnotation animated:YES];
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
    }
    annotationView.image = [UIImage imageNamed:@"task_map_location"];
    annotationView.annotation = annotation;
    annotationView.theAnnotation = annotation;
    
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
        
        circleView.strokeColor = sahara_color;
        circleView.fillColor = [sahara_color colorWithAlphaComponent:0.4];
        circleView.lineWidth = 0.5;
        circleView.miterLimit = 300.0;
        
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
            
            didGetAddressBlock myCallback = self.didGetAddressCallback;
            if (myCallback) {
                self.didGetAddressCallback = nil;
                myCallback ([placemarks[0] valueForKey:@"name"]);
            }
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    _sureButton.completion = nil;
    _sureButton = nil;
    // Dispose of any resources that can be recreated.
}
//查找用

- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
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
