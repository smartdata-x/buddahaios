//
//  MapPoiSearchController.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/10.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "MapPoiSearchController.h"

@implementation MapPoiSearchController

- (id)initWithBMKMapView:(BMKMapView *)mapView {
    
    self = [super init];
    
    if (self) {
        
        mTopMapView = mapView;
        mPoiSearch = [[BMKPoiSearch alloc] init];
        mPoiSearch.delegate = self;
        searchRadius = DEFAULT_DISTANCE_RADIUS;
        mCurPage = 0;
        mPageCapacity = 50;
    }
    
    return self;
}

- (void)doSearchNearBy:(NSString *)keyword {
    
    CLLocationCoordinate2D location = [[MyLocationManager GetInstance] getLocation];
    
    BMKNearbySearchOption *nearbySearchOption = [[BMKNearbySearchOption alloc] init];
    nearbySearchOption.radius = searchRadius;
    nearbySearchOption.location = location;
    nearbySearchOption.pageCapacity = mPageCapacity;
    nearbySearchOption.keyword = keyword;
    
    BOOL flag = [mPoiSearch poiSearchNearBy:nearbySearchOption];
    if (flag) {
        
        MIGDEBUG_PRINT(@"周边搜索发送成功");
    }
    else {
        
        MIGDEBUG_PRINT(@"周边搜索发送失败");
    }
}

- (void)doSearchInCity:(NSString *)keyword City:(NSString *)city {
    
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = mCurPage;
    citySearchOption.pageCapacity = mPageCapacity;
    citySearchOption.city= city;
    citySearchOption.keyword = keyword;
    
    BOOL flag = [mPoiSearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        MIGDEBUG_PRINT(@"城市内检索发送成功");
    }
    else
    {
        MIGDEBUG_PRINT(@"城市内检索发送失败");
    }
}

- (void)enlargeSearch {
    
    if (searchRadius < MAX_DISTANCE_RADIUS) {
        
        searchRadius += searchRadius;
    }
}

- (void)shrinkSearch {
    
    if (searchRadius > 1) {
        
        searchRadius /= 2.0;
    }
}

// BMKPoiSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)result errorCode:(BMKSearchErrorCode)error {
    
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:mTopMapView.annotations];
    [mTopMapView removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [mTopMapView addAnnotation:item];
            
            if(i == 0)
            {
                //将第一个点的坐标移到屏幕中央
                //mMapView.centerCoordinate = poi.pt;
            }
        }
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        
        MIGDEBUG_PRINT(@"起始点有歧义");
    }
    else {
        
        MIGDEBUG_PRINT(@"百度地图搜索位置 发生其他错误");
    }
}

@end
