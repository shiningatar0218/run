//
//  MapView.m
//  run1.2
//
//  Created by runner on 14/12/31.
//  Copyright (c) 2014年 runner. All rights reserved.
//

#import "MapView.h"
#import "define.h"
#import "DataModel.h"
#import "MessageManager.h"
#import "CLLocation+Sino.h"
#import "NSArray+Additions.h"
#import "MapPicture.h"
@interface MapView ()
{
    CLLocation *_currentLocation;
    MKMapRect _routeRect;
    
    CLLocation *_zeroLocation;
}

@property (nonatomic, retain)MKMapView *mapView;
@property (nonatomic, retain)CLLocationManager *locationManager;
@property (nonatomic, retain)MKPointAnnotation *annotation;

@property (nonatomic, retain) NSMutableArray* points;
@property (nonatomic, retain) MKPolyline* routeLine;
@property (nonatomic, retain) MKPolylineView* routeLineView;

@property (strong, nonatomic) NSString *addressString;
@property (assign, nonatomic) MKCoordinateRegion region;

@end

@implementation MapView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cutMapPicture) name:CutMapPicture object:nil];
        [self buildMap];
        self.startActivity = NO;
    }
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
//记录中直接画出路径
- (void)startUpDateAndShowRuteWithPoints:(NSArray *)points {
    self.startActivity = NO;
    self.mapView.showsUserLocation = NO;
    if (!_points) {
        _points = [NSMutableArray arrayWithCapacity:0];
    }
    [_points removeAllObjects];
    for (NSDictionary *dic in points) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[dic[@"lat"] doubleValue] longitude:[dic[@"long"] doubleValue]];
        
        if (location.coordinate.longitude != 0.f || location.coordinate.latitude) {
            [_points addObject:location];
        }
    }
    [self.locationManager startUpdatingLocation];
    [self configureRoutes];
}

- (void)buildMap {
    [self.locationManager startUpdatingLocation];
    [self addSubview:self.mapView];
    
    [self.mapView setRegion:self.region animated:YES];
}

- (void)dealloc {
    _locationManager = nil;
    _annotation = nil;
    _routeLine = nil;
    _routeLineView = nil;
    _points = nil;
    _mapView = nil;
    NSLog(@"mapView  relsease!!");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CutMapPicture object:nil];
}

- (void)beginingActivity {
    self.startActivity = YES;
    [self.locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
    [self startUpDate];
}

- (void)paseActivity {
    [self.locationManager stopUpdatingLocation];
}

- (void)startUpDate {
    //View Area
    self.mapView.showsUserLocation = YES;
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
    //[self.mapView setRegion:self.region animated:YES];
}

- (void)freaMap {
    
    [self getDistance:[[CLLocation alloc] initWithLatitude:self.mapView.userLocation.coordinate.latitude longitude:self.mapView.userLocation.coordinate.longitude]];
    self.startActivity = NO;
    [self.locationManager stopUpdatingLocation];
    self.mapView.showsUserLocation = YES;
    self.points = nil;
    [self.mapView removeOverlay:self.routeLine];
}

#pragma mark - MKMapViewDelegate
//更新用户位置
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if (!self.startActivity) {
        return;
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    MKPointAnnotation * annotation=(MKPointAnnotation *)view.annotation;
    self.annotation = annotation;
}

- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews
{
    NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
    NSLog(@"overlayViews: %@", overlayViews);
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
    
    MKOverlayView* overlayView = nil;
    
    if(overlay == self.routeLine)
    {
        //if we have not yet created an overlay view for this overlay, create it now.
        if (self.routeLineView) {
            [self.routeLineView removeFromSuperview];
        }
        
        self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
        self.routeLineView.fillColor = [UIColor yellowColor];
        self.routeLineView.strokeColor = [UIColor yellowColor];//路线颜色
        self.routeLineView.lineWidth = 10.0;//路线宽度
        
        overlayView = self.routeLineView;
    }
    
    return overlayView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
    NSLog(@"annotation views: %@", views);
}

#pragma mark -- CLLocationManagerDelegate
//停止跟新位置
- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"gps 定位失败！！！！%f",manager.desiredAccuracy);
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *wggLocation = [locations firstObject];
    CLLocation *currentLocation = [wggLocation locationMarsFromEarth];
    [DataModel getInstance].longitude = currentLocation.coordinate.longitude;
    [DataModel getInstance].latitude = currentLocation.coordinate.latitude;
    [DataModel getInstance].altitude = currentLocation.altitude;
    
    NSLog(@"误差： %f",currentLocation.horizontalAccuracy);
    if (currentLocation.horizontalAccuracy > 25) return;
    //if (!currentLocation.floor) return;
    
    if (!self.startActivity) {
        return;
    }
    
    
    if (!_points) {
        _points = [[NSMutableArray alloc] init];
        if (self.mapView.userLocation.location) {
            [_points addObject:self.mapView.userLocation.location];
            _currentLocation = self.mapView.userLocation.location;
        }else {
            _currentLocation = currentLocation;
        }
    }
    [_points addObject:currentLocation];
    self.mapView.showsUserLocation = YES;
    if (_points.count > 1) {
        //CLLocationDistance distance = [currentLocation distanceFromLocation:_currentLocation];
        //记录当前位置经纬度
        [self getDistance:currentLocation];
    }
    
    _currentLocation = currentLocation;
    [self configureRoutes];
}

- (void)cutMapPicture {
    [self.mapView setVisibleMapRect:_routeRect edgePadding:UIEdgeInsetsMake(5, 10, 5, 10) animated:NO];
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:0];
    for (CLLocation *location in self.points) {
        CGPoint point = [self.mapView convertCoordinate:location.coordinate toPointToView:self.mapView];
        
        [points addObject:[NSValue valueWithCGPoint:point]];
    }
    //--------截取图------------
    NSArray *array = [points sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result = [NSArray comparePointValue1:obj1 WithPointValue2:obj2];
        return result;
    }];
    CGFloat max_y = [[array lastObject] CGPointValue].y;
    CGFloat min_y = [[array firstObject] CGPointValue].y;
    
    CGFloat center_y = (max_y + min_y)/2.0;
    CGFloat image_height = iPhone4 ? 160.0*0.8 : 160.0;
    
    CGRect cutRect = CGRectMake(0, (center_y - image_height/2.0)*2, self.mapView.frame.size.width*2, image_height*2);
    
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    options.region = self.mapView.region;
    options.scale = [UIScreen mainScreen].scale;
    options.size = self.mapView.frame.size;
    options.showsBuildings = YES;
    options.showsPointsOfInterest = YES;
    options.camera = self.mapView.camera;
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        
        if (error) {
            NSLog(@"error:%@",error);
            return;
        }

        MapPicture *map = [[MapPicture alloc] initWithFrame:self.mapView.bounds withImage:snapshot.image withRoutePoints:points];
        
        UIImage *image = [map cutPictureInRect:cutRect];
        
        UIImage *sendImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, cutRect)];
        //UIImageWriteToSavedPhotosAlbum(sendImage, self, nil, nil);
        [DATAMODEL cutMapImage:sendImage];
        
        NSLog(@"截图成功！！！！！");
    }];
}

//画路线
- (void)configureRoutes
{
    // define minimum, maximum points
    MKMapPoint northEastPoint = MKMapPointMake(0.f, 0.f);
    MKMapPoint southWestPoint = MKMapPointMake(0.f, 0.f);
    
    // create a c array of points.
    MKMapPoint* pointArray = malloc(sizeof(CLLocationCoordinate2D) * _points.count);
    
    // for(int idx = 0; idx < pointStrings.count; idx++)
    
    
    
    for(int idx = 0; idx < _points.count; idx++)
    {
        CLLocation *location = [_points objectAtIndex:idx];
        CLLocationDegrees latitude  = location.coordinate.latitude;
        CLLocationDegrees longitude = location.coordinate.longitude;
        
        // create our coordinate and add it to the correct spot in the array
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        MKMapPoint point = MKMapPointForCoordinate(coordinate);
        
        // if it is the first point, just use them, since we have nothing to compare to yet.
        if (idx == 0) {
            northEastPoint = point;
            southWestPoint = point;
        } else {
            if (point.x > northEastPoint.x)
                northEastPoint.x = point.x;
            if(point.y > northEastPoint.y)
                northEastPoint.y = point.y;
            if (point.x < southWestPoint.x)
                southWestPoint.x = point.x;
            if (point.y < southWestPoint.y)
                southWestPoint.y = point.y;
        }
        
        pointArray[idx] = point;
    }
    
    if (self.routeLine) {
        [self.mapView removeOverlay:self.routeLine];
    }
    
    self.routeLine = [MKPolyline polylineWithPoints:pointArray count:_points.count];
    
    // add the overlay to the map
    if (nil != self.routeLine) {
        [self.mapView addOverlay:self.routeLine];
    }
    
    // clear the memory allocated earlier for the points
    free(pointArray);
    
    
    double width = northEastPoint.x - southWestPoint.x;
    double height = northEastPoint.y - southWestPoint.y;
    
    _routeRect = MKMapRectMake(southWestPoint.x, southWestPoint.y, width, height);
    
    // zoom in on the route.
    if (!self.startActivity) {
        [self.mapView setVisibleMapRect:_routeRect];
    }
}

#pragma mark -- get

- (MKCoordinateRegion)region {
    CLLocationCoordinate2D center = self.mapView.userLocation.location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.001f, 0.001f);//这个显示大小精度自己调整
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    return region;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 1.0;
        _locationManager.activityType = CLActivityTypeOther;
        _locationManager.delegate = self;
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            //[_locationManager requestWhenInUseAuthorization];
            [self.locationManager requestAlwaysAuthorization];
        }
    }
    return _locationManager;
}

- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView=[[MKMapView alloc]initWithFrame:self.bounds];
        _mapView.mapType=MKMapTypeStandard;//设置地图的样式
        _mapView.zoomEnabled=YES;//是否允许缩放
        _mapView.scrollEnabled=YES;//是否允许滚动
        _mapView.showsUserLocation=YES;//是否允许显示当前的位置
        _mapView.userTrackingMode=MKUserTrackingModeFollowWithHeading;//设置用户跟随模式
        _mapView.delegate = self;
        _mapView.showsBuildings = YES;
        _mapView.showsPointsOfInterest = YES;
        _mapView.rotateEnabled = YES;
        _mapView.pitchEnabled = YES;
        [_mapView.userLocation setTitle:@"我在这里"];
    }
    return _mapView;
}

- (void)getDistance:(CLLocation *)location {
    CLLocationDistance distance = [location distanceFromLocation:_currentLocation];
    CGFloat total_distance = [[DataModel getInstance].activity.total_distance floatValue] + distance;
        
    NSLog(@"total_distance = %lf",total_distance);
        
    [DataModel getInstance].activity.total_distance = [NSNumber numberWithFloat:total_distance];
}

@end
