//
//  MAmapView.m
//  run
//
//  Created by runner on 15/3/24.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "MAmapView.h"
#import "define.h"
#import <MAMapKit/MAMapKit.h>
#import "DataModel.h"
#import "MessageManager.h"
#import "CLLocation+Sino.h"
#import "NSArray+Additions.h"
@interface MAmapView ()<MAMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocation *_currentLocation;
    NSMutableArray* _points;
    MAMapRect _routeRect;
    
    CLLocation *_zeroLocation;
}

@property (nonatomic, assign) BOOL startActivity;

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, retain) NSMutableArray* points;
@property (nonatomic, retain) MAPolyline* routeLine;
@property (nonatomic, retain) MAPolylineView* routeLineView;
@property (nonatomic, assign) MACoordinateRegion region;
@property (nonatomic, retain)CLLocationManager *locationManager;

@end

@implementation MAmapView

@synthesize mapView = _mapView;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.startActivity = NO;
        [self buildMap];
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"mamapview  release");
    self.mapView.delegate = nil;
    self.locationManager = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DidSaveLocation object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CutMapPicture object:nil];
}

- (void)freaMap {
    [self.locationManager stopUpdatingLocation];
    self.mapView.showsUserLocation = NO;
    self.points = nil;
    [self.mapView removeOverlay:self.routeLine];
    self.routeLineView = nil;
}

- (void)buildMap {
    [self.locationManager startUpdatingLocation];
    [self addSubview:self.mapView];
    
    [self.mapView setRegion:self.region animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveToCoreData:) name:DidSaveLocation object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cutMapPicture) name:CutMapPicture object:nil];
}

- (void)beginingActivity {
    self.startActivity = YES;
    self.mapView.showsUserLocation = YES;
    [self startUpDate];
}

- (void)paseActivity {
    [self.locationManager stopUpdatingLocation];
}

- (void)startUpDate {
    [self.locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(self.mapView.userLocation.coordinate.latitude, self.mapView.userLocation.coordinate.longitude);
    
    [self.mapView setCenterCoordinate:center animated:YES];
}


- (void)mapViewDidFailLoadingMap:(MAMapView *)mapView withError:(NSError *)error {
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"地图加载失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alertView show];
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
        if (!self.startActivity) {
            return;
        }
        
//        CLLocationCoordinate2D center = userLocation.location.coordinate;
//        [self.mapView setCenterCoordinate:center animated:YES];

    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"gps 定位失败！！！！%f",manager.desiredAccuracy);
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *wggLocation = [locations lastObject];
    CLLocation *currentLocation = [wggLocation locationMarsFromEarth];
    [DataModel getInstance].longitude = currentLocation.coordinate.longitude;
    [DataModel getInstance].latitude = currentLocation.coordinate.latitude;
    [DataModel getInstance].altitude = currentLocation.altitude;
    
    NSLog(@"误差： %f",currentLocation.horizontalAccuracy);
    if (currentLocation.horizontalAccuracy > 25) return;
    if (!currentLocation.floor) return;
    
    if (!self.startActivity) {
        return;
    }
    
    if (!_points) {
        _points = [[NSMutableArray alloc] init];
        [_points addObject:self.mapView.userLocation.location];
        _currentLocation = self.mapView.userLocation.location;
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

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay {
    MAOverlayPathView *overlayView = nil;
    
    if (overlay == self.routeLine) {
        if (self.routeLineView) {
            [self.routeLineView removeFromSuperview];
        }
        
        self.routeLineView = [[MAPolylineView alloc] initWithPolyline:self.routeLine];
        
        self.routeLineView.fillColor = [UIColor yellowColor];
        self.routeLineView.strokeColor = [UIColor yellowColor];
        self.routeLineView.lineWidth = 5.0f;
        self.routeLineView.lineJoinType = kMALineJoinRound;
        self.routeLineView.lineCapType = kMALineCapRound;
        overlayView = self.routeLineView;
    }
    
    return overlayView;
}


- (void)saveToCoreData:(NSNotification *)sender {
    
}

- (void)cutMapPicture {
    [self.mapView setVisibleMapRect:_routeRect edgePadding:UIEdgeInsetsMake(5, 10, 5, 10) animated:NO];
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:0];
    for (CLLocation *location in self.points) {
        CGPoint point = [self.mapView convertCoordinate:location.coordinate toPointToView:self.mapView];
        
        [points addObject:[NSValue valueWithCGPoint:point]];
    }
    //--------截取小图------------
    NSArray *array = [points sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result = [NSArray comparePointValue1:obj1 WithPointValue2:obj2];
        return result;
    }];
    CGFloat max_y = [[array lastObject] CGPointValue].y;
    CGFloat min_y = [[array firstObject] CGPointValue].y;
    
    CGFloat center_y = (max_y + min_y)/2.0;
    CGFloat image_height = iPhone4 ? 160.0*0.8 : 160.0;
    
    CGRect cutRect = CGRectMake(0, center_y - image_height/2.0, self.mapView.frame.size.width, center_y + image_height/2.0);
    UIImage *image = [self.mapView takeSnapshotInRect:cutRect];
    
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    
    [DATAMODEL cutMapImage:image];
}

//画路线
- (void)configureRoutes
{
    // define minimum, maximum points
    MAMapPoint northEastPoint = MAMapPointMake(0.f, 0.f);
    MAMapPoint southWestPoint = MAMapPointMake(0.f, 0.f);
    
    // create a c array of points.
    MAMapPoint* pointArray = malloc(sizeof(CLLocationCoordinate2D) * _points.count);
    
    // for(int idx = 0; idx < pointStrings.count; idx++)
    
    
    
    for(int idx = 0; idx < _points.count; idx++)
    {
        CLLocation *location = [_points objectAtIndex:idx];
        CLLocationDegrees latitude  = location.coordinate.latitude;
        CLLocationDegrees longitude = location.coordinate.longitude;
        
        // create our coordinate and add it to the correct spot in the array
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        MAMapPoint point = MAMapPointForCoordinate(coordinate);
        
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
    
    self.routeLine = [MAPolyline polylineWithPoints:pointArray count:_points.count];
    
    // add the overlay to the map
    if (nil != self.routeLine) {
        [self.mapView addOverlay:self.routeLine];
    }
    
    // clear the memory allocated earlier for the points
    free(pointArray);
    
    
    double width = northEastPoint.x - southWestPoint.x;
    double height = northEastPoint.y - southWestPoint.y;
    
    _routeRect = MAMapRectMake(southWestPoint.x, southWestPoint.y, width, height);
    
    // zoom in on the route.
    if (!self.startActivity) {
        [self.mapView setVisibleMapRect:_routeRect];
    }
}

- (void)getDistance:(CLLocation *)location {
    CLLocationDistance distance = [location distanceFromLocation:_currentLocation];
    CGFloat total_distance = [[DataModel getInstance].activity.total_distance floatValue] + distance;
    
    NSLog(@"total_distance = %lf",total_distance);
    
    [DataModel getInstance].activity.total_distance = [NSNumber numberWithFloat:total_distance];
}

- (MAMapView *)mapView {
    if (_mapView) {
        return _mapView;
    }
    _mapView = [[MAMapView alloc] initWithFrame:self.bounds];
    _mapView.delegate = self;
    _mapView.mapType = MAMapTypeStandard;
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    _mapView.showsScale = YES;
    _mapView.showsCompass = YES;
    return _mapView;
}

- (MACoordinateRegion)region {
    CLLocationCoordinate2D center = self.mapView.userLocation.location.coordinate;
    MACoordinateSpan span = MACoordinateSpanMake(0.001f, 0.001f);//这个显示大小精度自己调整
    MACoordinateRegion region = MACoordinateRegionMake(center, span);
    self.mapView.region = region;
    return self.mapView.region;
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


@end
