//
//  MapViewController.m
//  Buddha
//
//  Created by Archer_LJ on 14/11/27.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    // 初始化百度地图
    if (mBDMapManager == nil) {
        
        mBDMapManager = [[BMKMapManager alloc] init];
        BOOL ret = [mBDMapManager start:@"96IS38XTSvyMSLgpPbV0FjKq" generalDelegate:self];
        if (!ret) {
            
            MIGDEBUG_PRINT(@"百度地图启动成功");
        }
    }
    
    mMapView = [[BMKMapView alloc] initWithFrame:self.mFrame];
    mMapView.mapType = BMKMapTypeStandard;
    mMapView.zoomLevel = 16;
    mMapView.zoomEnabled = YES;
    mMapView.scrollEnabled = YES;
    mMapView.showsUserLocation = YES;
    mMapView.isSelectedAnnotationViewFront = YES;
    mMapView.delegate = self;
    [self.view addSubview:mMapView];
    
    mLocationService = [[BMKLocationService alloc] init];
    mPoiSearch = [[BMKPoiSearch alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [mMapView viewWillAppear];
    mMapView.delegate = self;
    mLocationService.delegate = self;
    mPoiSearch.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [mMapView viewWillDisappear];
    mMapView.delegate = nil;
    mLocationService.delegate = nil;
    mPoiSearch.delegate = nil;
}


/*
 ******************* 地图操作 *******************
 */
// 放大地图
- (void)ZoomInMap:(id)sender {
    
    mMapView.zoomLevel++;
}

// 缩小地图
- (void)ZoomOutMap:(id)sender {
    
    mMapView.zoomLevel--;
}

// 地图长按事件
-(void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate {
    
    MIGDEBUG_PRINT(@"长按");
}

// 地图双击手势
- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {
    
    MIGDEBUG_PRINT(@"双击");
}


/*
 ******************* 地图定位 *******************
 */

// 开始定位
- (void)startLocation:(id)sender {
    
    MIGDEBUG_PRINT(@"开始定位");
    [mLocationService startUserLocationService];
    
    mMapView.showsUserLocation = NO; // 先关闭显示的定位图层
    mMapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    mMapView.showsUserLocation = YES;//显示定位图层
    
    // TODO:设置按钮显示和消失状态
}

// 罗盘态
- (void)startFollowHeading:(id)sender {
    
    MIGDEBUG_PRINT(@"进入罗盘态");
    
    mMapView.showsUserLocation = NO;
    mMapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
    mMapView.showsUserLocation = YES;
}

// 跟随态
- (void)startFollowing:(id)sender {
    
    MIGDEBUG_PRINT(@"进入跟随态");
    
    mMapView.showsUserLocation = NO;
    mMapView.userTrackingMode = BMKUserTrackingModeFollow;
    mMapView.showsUserLocation = YES;
}

// 停止定位
- (void)stopLocation:(id)sender {
    
    MIGDEBUG_PRINT(@"停止定位");
    
    [mLocationService stopUserLocationService];
    mMapView.showsUserLocation = YES;
    
    // TODO:设置按钮消失和显示状态
}

- (void)willStartLocatingUser {
    
    MIGDEBUG_PRINT(@"%s", __FUNCTION__);
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    
    MIGDEBUG_PRINT(@"%s", __FUNCTION__);
    
    [mMapView updateLocationData:userLocation];
}

- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation {
    
    MIGDEBUG_PRINT(@"%s", __FUNCTION__);
    
    [mMapView updateLocationData:userLocation];
}

- (void)didStopLocatingUser {
    
    MIGDEBUG_PRINT(@"%s", __FUNCTION__);
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    
    MIGDEBUG_PRINT(@"定位失败");
}

/*
 ******************* 地图搜寻 *******************
 */
- (void)beginSearch:(id)sender {
    
    mCurPage = 0;
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = mCurPage;
    citySearchOption.pageCapacity = 40;
    citySearchOption.city= @"北京";
    citySearchOption.keyword = @"餐厅";
    
    BOOL flag = [mPoiSearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        //_nextPageButton.enabled = true;
        MIGDEBUG_PRINT(@"城市内检索发送成功");
    }
    else
    {
        //_nextPageButton.enabled = false;
        MIGDEBUG_PRINT(@"城市内检索发送失败");
    }
}


- (IBAction)showNextResultPage:(id)sender {
    
    mCurPage++;
    
    //城市内检索，请求发送成功返回YES，请求发送失败返回NO
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = mCurPage;
    citySearchOption.pageCapacity = 40;
    citySearchOption.city= @"北京";
    citySearchOption.keyword = @"餐厅";
    
    BOOL flag = [mPoiSearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        //_nextPageButton.enabled = true;
        MIGDEBUG_PRINT(@"城市内检索发送成功");
    }
    else
    {
        //_nextPageButton.enabled = false;
        MIGDEBUG_PRINT(@"城市内检索发送失败");
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id<BMKAnnotation>)annotation {
    
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    
    [mMapView bringSubviewToFront:view];
    [mMapView setNeedsDisplay];
}

- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    
    MIGDEBUG_PRINT(@"%s", __FUNCTION__);
}

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)result errorCode:(BMKSearchErrorCode)error {
    
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:mMapView.annotations];
    [mMapView removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [mMapView addAnnotation:item];
            
            if(i == 0)
            {
                //将第一个点的坐标移到屏幕中央
                mMapView.centerCoordinate = poi.pt;
            }
        }
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        
        MIGDEBUG_PRINT(@"起始点有歧义");
    }
    else {
        
        // 各种情况的判断。。。
    }
}


// BMKGeneral Delegate
-(void)onGetNetworkState:(int)iError
{
    if (iError == 0)
    {
        NSLog(@"网络连接正常");
    }
    else
    {
        NSLog(@"网络错误:%d",iError);
    }
}

-(void)onGetPermissionState:(int)iError
{
    if (iError == 0)
    {
        NSLog(@"授权成功");
    }
    else
    {
        NSLog(@"授权失败:%d",iError);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
