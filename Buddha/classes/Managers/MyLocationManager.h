//
//  MyLocationManager.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/4.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stdinc.h"
#import <CoreLocation/CoreLocation.h>

@interface MyLocationManager : NSObject<CLLocationManagerDelegate>
{
    CGFloat mLongitude;
    CGFloat mLatitude;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL isUpdated;

+ (MyLocationManager *)GetInstance;

- (void)updateLocation;
- (CGPoint)getLocation;
- (NSString *)getLatitude;
- (NSString *)getLongitude;

@end
