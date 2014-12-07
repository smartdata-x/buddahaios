//
//  MapViewController.h
//  Buddha
//
//  Created by Archer_LJ on 14/11/27.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "BMapKit.h"
#import "MyLocationManager.h"

@interface MapViewController : BaseViewController<BMKMapViewDelegate, BMKLocationServiceDelegate, BMKPoiSearchDelegate, BMKGeneralDelegate>
{
    BMKMapManager *mBDMapManager;
    BMKLocationService *mLocationService;
    BMKMapView *mMapView;
    BMKPoiSearch *mPoiSearch;
    
    // 搜索相关变量
    int mCurPage;
    
    // 距离搜索半径
    float searchRadius;
}

- (IBAction)startLocation:(id)sender;
- (IBAction)stopLocation:(id)sender;
- (IBAction)startFollowing:(id)sender;
- (IBAction)startFollowHeading:(id)sender;

- (IBAction)beginSearchNearby:(id)sender Radius:(float)radius Keyword:(NSString *)keyword;
- (IBAction)beginSearch:(id)sender;
- (IBAction)showNextResultPage:(id)sender;

- (IBAction)enlargeRadius:(id)sender;
- (IBAction)reduceRadius:(id)sender;

@end
