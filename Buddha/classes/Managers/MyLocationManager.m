//
//  MyLocationManager.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/4.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "MyLocationManager.h"

@implementation MyLocationManager

+ (MyLocationManager *)GetInstance {
    
    static MyLocationManager *instance = nil;
    
    @synchronized(self) {
        
        if (nil == instance) {
            
            instance = [[MyLocationManager alloc] init];
            instance.isUpdated = NO;
        }
    }
    
    return instance;
}

- (void)updateLocation {
    
    if (_locationManager == nil) {
        
        _locationManager = [[CLLocationManager alloc] init];
    }
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        [_locationManager setDelegate:self];
        [_locationManager setDistanceFilter:DEFAULT_DISTANCE_FILTER];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [_locationManager startUpdatingLocation];
        
        if (IS_OS_8_OR_LATER) {
            
            [_locationManager requestWhenInUseAuthorization];
        }
    }
}

- (void)updateLocationByLocation:(CLLocationCoordinate2D)curLocation {
    
#if MIG_DEBUG_TEST
    mLatitude = 30.257028579711914;
    mLongitude = 120.20285034179688;
#else
    mLatitude = curLocation.latitude;
    mLongitude = curLocation.longitude;
#endif
}

- (CLLocationCoordinate2D)getLocation {
    
    return CLLocationCoordinate2DMake(mLatitude, mLongitude);
}

- (NSString *)getLatitude {
    
    return [NSString stringWithFormat:@"%f", mLatitude];
}

- (NSString *)getLongitude {
    
    return [NSString stringWithFormat:@"%f", mLongitude];
}

// CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *location = [locations lastObject];
    mLongitude = location.coordinate.longitude;
    mLatitude = location.coordinate.latitude;
    _isUpdated = YES;
    
#if MIG_DEBUG_TEST
    mLatitude = 30.257028579711914;
    mLongitude = 120.20285034179688;
#endif
    
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    MIGDEBUG_PRINT(@"获取坐标失败: %@", [error localizedDescription]);
    
    _isUpdated = NO;
}

@end
