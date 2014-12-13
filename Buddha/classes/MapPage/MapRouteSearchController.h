//
//  MapRouteSearchController.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/11.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"
#import "MyLocationManager.h"

@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@interface MapRouteSearchController : NSObject<BMKRouteSearchDelegate>
{
    BMKMapView *mTopMapView; // 上层赋值
    
    BMKRouteSearch *mRouteSearch;
}

- (id)initWithBMKMapView:(BMKMapView *)mapView;

- (void)doSearchTest;

- (void)doRouteSearchByWalkingLocation:(CLLocationCoordinate2D)locStart LocationEnd:(CLLocationCoordinate2D)locEnd;
- (void)doRouteSearchByBusLocation:(CLLocationCoordinate2D)locStart LocationEnd:(CLLocationCoordinate2D)locEnd;
- (void)doRouteSearchByCarLocation:(CLLocationCoordinate2D)locStart LocationEnd:(CLLocationCoordinate2D)locEnd;

@end
