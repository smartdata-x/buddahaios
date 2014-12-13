//
//  MapPoiSearchController.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/10.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"
#import "MyLocationManager.h"

@interface MapPoiSearchController : NSObject<BMKPoiSearchDelegate>
{
    
    BMKMapView *mTopMapView; // 上层赋值
    
    BMKPoiSearch *mPoiSearch;
    float searchRadius; // 距离搜索半径
    NSInteger mPageCapacity; // 地图一页显示的地点个数
    NSInteger mCurPage; // 地图当前显示的页
}

- (id)initWithBMKMapView:(BMKMapView *)mapView;

- (void)doSearchNearBy:(NSString *)keyword;
- (void)doSearchInCity:(NSString *)keyword City:(NSString *)city;

- (void)enlargeSearch;
- (void)shrinkSearch;

@end
