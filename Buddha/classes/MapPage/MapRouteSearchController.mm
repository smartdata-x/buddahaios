//
//  MapRouteSearchController.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/11.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "MapRouteSearchController.h"

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;

@end

@implementation MapRouteSearchController

- (id)initWithBMKMapView:(BMKMapView *)mapView {
    
    self = [super init];
    
    if (self) {
        
        mTopMapView = mapView;
        mRouteSearch = [[BMKRouteSearch alloc] init];
        mRouteSearch.delegate = self;
    }
    
    return self;
}

- (void)doSearchTest {
    
    BMKPlanNode *start = [[BMKPlanNode alloc] init];
    start.pt = [[MyLocationManager GetInstance] getLocation];
    
    CLLocationCoordinate2D curloc = CLLocationCoordinate2DMake(30.625746, 104.055281);
    BMKPlanNode *end = [[BMKPlanNode alloc] init];
    end.pt = curloc;
    
    BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    walkingRouteSearchOption.from = start;
    walkingRouteSearchOption.to = end;
    BOOL flag = [mRouteSearch walkingSearch:walkingRouteSearchOption];
    
    if(flag)
    {
        NSLog(@"walk检索发送成功");
    }
    else
    {
        NSLog(@"walk检索发送失败");
    }
}

- (void)doRouteSearchByWalkingLocation:(CLLocationCoordinate2D)locStart LocationEnd:(CLLocationCoordinate2D)locEnd {
    
    BMKPlanNode *start = [[BMKPlanNode alloc] init];
    start.pt = locStart;
    
    BMKPlanNode *end = [[BMKPlanNode alloc] init];
    end.pt = locEnd;
    
    BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    walkingRouteSearchOption.from = start;
    walkingRouteSearchOption.to = end;
    
    BOOL flag = [mRouteSearch walkingSearch:walkingRouteSearchOption];
    if(flag)
    {
        NSLog(@"步行检索发送成功");
    }
    else
    {
        NSLog(@"步行检索发送失败");
    }
}

- (void)doRouteSearchByBusLocation:(CLLocationCoordinate2D)locStart LocationEnd:(CLLocationCoordinate2D)locEnd {
    
    BMKPlanNode *start = [[BMKPlanNode alloc] init];
    start.pt = locStart;
    
    BMKPlanNode *end = [[BMKPlanNode alloc] init];
    end.pt = locEnd;
    
    BMKTransitRoutePlanOption *busRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    busRouteSearchOption.from = start;
    busRouteSearchOption.to = end;
    
    BOOL flag = [mRouteSearch transitSearch:busRouteSearchOption];
    if(flag)
    {
        NSLog(@"公交检索发送成功");
    }
    else
    {
        NSLog(@"公交检索发送失败");
    }
}

- (void)doRouteSearchByCarLocation:(CLLocationCoordinate2D)locStart LocationEnd:(CLLocationCoordinate2D)locEnd {
    
    BMKPlanNode *start = [[BMKPlanNode alloc] init];
    start.pt = locStart;
    
    BMKPlanNode *end = [[BMKPlanNode alloc] init];
    end.pt = locEnd;
    
    BMKDrivingRoutePlanOption *carRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    carRouteSearchOption.from = start;
    carRouteSearchOption.to = end;
    
    BOOL flag = [mRouteSearch drivingSearch:carRouteSearchOption];
    if(flag)
    {
        NSLog(@"驾车检索发送成功");
    }
    else
    {
        NSLog(@"驾车检索发送失败");
    }
}

// delete公用函数
//- (void)handleRouteResult:(BMKRouteSearch *)searcher result:(BMKWalkingRouteLine)

// BMKRouteSearchDelegate
- (void)onGetWalkingRouteResult:(BMKRouteSearch *)searcher result:(BMKWalkingRouteResult *)result errorCode:(BMKSearchErrorCode)error {
    
    NSArray* array = [NSArray arrayWithArray:mTopMapView.annotations];
    [mTopMapView removeAnnotations:array];
    array = [NSArray arrayWithArray:mTopMapView.overlays];
    [mTopMapView removeOverlays:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        int size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [mTopMapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [mTopMapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [mTopMapView addAnnotation:item];
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [mTopMapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        
        MIGDEBUG_PRINT(@"起始点有歧义");
    }
    else {
        
        // 各种情况的判断。。。
        MIGDEBUG_PRINT(@"百度地图搜索路线 发生其他错误");
    }
}

- (void)onGetTransitRouteResult:(BMKRouteSearch *)searcher result:(BMKTransitRouteResult *)result errorCode:(BMKSearchErrorCode)error {
    
    NSArray* array = [NSArray arrayWithArray:mTopMapView.annotations];
    [mTopMapView removeAnnotations:array];
    array = [NSArray arrayWithArray:mTopMapView.overlays];
    [mTopMapView removeOverlays:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        int size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [mTopMapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [mTopMapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            //item.title = transitStep.entraceInstruction;
            //item.degree = transitStep.direction * 30;
            item.type = 4;
            [mTopMapView addAnnotation:item];
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [mTopMapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        
        MIGDEBUG_PRINT(@"起始点有歧义");
    }
    else {
        
        // 各种情况的判断。。。
        MIGDEBUG_PRINT(@"百度地图搜索路线 发生其他错误");
    }
}

- (void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error {
    
    NSArray* array = [NSArray arrayWithArray:mTopMapView.annotations];
    [mTopMapView removeAnnotations:array];
    array = [NSArray arrayWithArray:mTopMapView.overlays];
    [mTopMapView removeOverlays:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        int size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [mTopMapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [mTopMapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [mTopMapView addAnnotation:item];
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [mTopMapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        
        MIGDEBUG_PRINT(@"起始点有歧义");
    }
    else {
        
        // 各种情况的判断。。。
        MIGDEBUG_PRINT(@"百度地图搜索路线 发生其他错误");
    }
}

@end
