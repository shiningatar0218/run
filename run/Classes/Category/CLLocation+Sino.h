//
//  CLLocation+Sino.h
//  run
//
//  Created by runner on 15/3/16.
// 火星坐标系转换扩展
//
// earth（国外 WGS84）, mars（国内 GCJ-02）, bearPaw（百度 BD-09） 坐标系间相互转换
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (Sino)

- (CLLocation*)locationMarsFromEarth;
//- (CLLocation*)locationEarthFromMars; // 未实现

- (CLLocation*)locationBearPawFromMars;
- (CLLocation*)locationMarsFromBearPaw;

@end
