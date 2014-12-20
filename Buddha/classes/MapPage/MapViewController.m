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
        
        _isMainEntry = YES;
        
        if (mBuildingInfo == nil) {
            
            mBuildingInfo = [[NSMutableArray alloc] init];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNearbyBuildingFailed:) name:MigNetNameGetNearBuildFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNearbyBuildingSuccess:) name:MigNetNameGetNearBuildSuccess object:nil];
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetNearBuildFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetNearBuildSuccess object:nil];
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
    
    CLLocationCoordinate2D curLocation = [[MyLocationManager GetInstance] getLocation];
    
    mMapView = [[BMKMapView alloc] initWithFrame:self.mFrame];
    mMapView.mapType = BMKMapTypeStandard;
    mMapView.zoomLevel = 16;
    mMapView.zoomEnabled = YES;
    mMapView.scrollEnabled = YES;
    mMapView.showsUserLocation = YES;
    mMapView.isSelectedAnnotationViewFront = YES;
    mMapView.centerCoordinate = curLocation;
    mMapView.userTrackingMode = BMKUserTrackingModeFollow;
    mMapView.delegate = self;
    
    [self.view addSubview:mMapView];
    [self initNearbyBottomMenu];
    [self initRouteBottomMenu];
    [self initBuildMenu];
    [self updateBottomMenu];
    
    mLocationService = [[BMKLocationService alloc] init];
    _mPoiSearchControl = [[MapPoiSearchController alloc] initWithBMKMapView:mMapView];
    _mRouteSearchControl = [[MapRouteSearchController alloc] initWithBMKMapView:mMapView];
    
#if !MIG_DEBUG_TEST
    // 定位到本地
    [self startLocation:nil];
    [self startFollowing:nil];
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    
    [mMapView viewWillAppear];
    mMapView.delegate = self;
    mLocationService.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [mMapView viewWillDisappear];
    mMapView.delegate = nil;
    mLocationService.delegate = nil;
}

- (void)initBuildMenu {
    
    if (mBuildMenu == nil) {
        
        mBuildMenu = [[MapBuildMenuView alloc] initWithFrame:self.mFrame];
        mBuildMenu.mTopViewController = self.topViewController;
    }
    
    mBuildMenu.mParentMapView = self;
    // 默认情况下隐藏
    [mBuildMenu setHidden:YES];
    [self.view addSubview:mBuildMenu];
}

- (void)showBuildMenu:(BOOL)animate {
    
    [mBuildMenu setHidden:NO];
    [self.view bringSubviewToFront:mBuildMenu];
    
    if (animate) {
        
        CATransition *trans = [CATransition animation];
        [trans setDuration:0.5];
        trans.type = kCATransitionPush;
        trans.subtype = kCATransitionFromTop;
        [trans setFillMode:kCAFillModeBoth];
        [trans setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.view.layer addAnimation:trans forKey:kCATransition];
    }
}

- (void)hideBuildMenu:(BOOL)animate {
    
    [mBuildMenu setHidden:YES];
    
    if (animate) {
        
        CATransition *trans = [CATransition animation];
        [trans setDuration:0.5];
        trans.type = kCATransitionPush;
        trans.subtype = kCATransitionFromBottom;
        [trans setFillMode:kCAFillModeBoth];
        [trans setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.view.layer addAnimation:trans forKey:kCATransition];
    }
}

- (void)initNearbyBottomMenu {
    
    NSArray *bottomItemArray = @[@{KEY_NORMAL:@"around_ico.png",
                                   KEY_HILIGHT:@"around_ico.png",
                                   KEY_TITLE:@"周边",
                                   KEY_TITLE_WIDTH:[NSNumber numberWithFloat:100.0]
                                   },
                                 ];
    
    if (mNearbyMenu == nil) {
        
        CGRect menuFrame = CGRectMake(0, self.mFrame.origin.y + self.mFrame.size.height - BOTTOM_MENU_BUTTON_HEIGHT, self.mFrame.size.width, BOTTOM_MENU_BUTTON_HEIGHT);
        CGSize imgSize = CGSizeMake(34 / SCREEN_SCALAR, 44 / SCREEN_SCALAR);
        mNearbyMenu = [[HorizontalMenu alloc] initWithFrame:menuFrame ButtonItems:bottomItemArray buttonSize:imgSize ButtonType:HORIZONTALMENU_TYPE_BUTTON_LABEL_RIGHT];
    }
    mNearbyMenu.delegate = self;
    [self.view addSubview:mNearbyMenu];
}

- (void)initRouteBottomMenu {
    
    NSArray *bottomItemArray = @[@{KEY_NORMAL:@"bus_ico.png",
                                   KEY_HILIGHT:@"bus_ico.png",
                                   KEY_TITLE:@"公交",
                                   KEY_TITLE_WIDTH:[NSNumber numberWithFloat:100.0]},
                                 
                                 @{KEY_NORMAL:@"car_ico.png",
                                   KEY_HILIGHT:@"car_ico.png",
                                   KEY_TITLE:@"驾车",
                                   KEY_TITLE_WIDTH:[NSNumber numberWithFloat:100.0]},
                                 
                                 @{KEY_NORMAL:@"walk_ico.png",
                                   KEY_HILIGHT:@"walk_ico.png",
                                   KEY_TITLE:@"步行",
                                   KEY_TITLE_WIDTH:[NSNumber numberWithFloat:100.0]},
                                 ];
    
    if (mRouteMenu == nil) {
        
        CGRect menuFrame = CGRectMake(0, self.mFrame.origin.y + self.mFrame.size.height - BOTTOM_MENU_BUTTON_HEIGHT, self.mFrame.size.width, BOTTOM_MENU_BUTTON_HEIGHT);
        CGSize imgSize = CGSizeMake(49 / SCREEN_SCALAR, 46 / SCREEN_SCALAR);
        mRouteMenu = [[HorizontalMenu alloc] initWithFrame:menuFrame ButtonItems:bottomItemArray buttonSize:imgSize ButtonType:HORIZONTALMENU_TYPE_BUTTON_LABEL_RIGHT];
    }
    mRouteMenu.delegate = self;
    [self.view addSubview:mRouteMenu];
    
    // 返回按钮
    float backX = self.mFrame.origin.x + 22 / SCREEN_SCALAR;
    float backY = self.mFrame.origin.y + 48 / SCREEN_SCALAR;
    float backWidth = 94 / SCREEN_SCALAR;
    float backHeight = 87 / SCREEN_SCALAR;
    
    if (mBtnBack == nil) {
        
        mBtnBack = [[UIButton alloc] initWithFrame:CGRectMake(backX, backY, backWidth, backHeight)];
    }
    [mBtnBack setBackgroundColor:[UIColor clearColor]];
    [mBtnBack setBackgroundImage:[UIImage imageNamed:@"map_back.png"] forState:UIControlStateNormal];
    [mBtnBack addTarget:self action:@selector(doBackToMainEntry) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mBtnBack];
    
    // 导航按钮
    float navWidth = 233 / SCREEN_SCALAR;
    float navHeight = 87 / SCREEN_SCALAR;
    float navX = self.mFrame.origin.x + self.mFrame.size.width - 22 / SCREEN_SCALAR - navWidth;
    float navY = self.mFrame.origin.y + 48 / SCREEN_SCALAR;
    if (mBtnGogoNav == nil) {
        
        mBtnGogoNav = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    mBtnGogoNav.frame = CGRectMake(navX, navY, navWidth, navHeight);
    [mBtnGogoNav setBackgroundColor:[UIColor clearColor]];
    [mBtnGogoNav setBackgroundImage:[UIImage imageNamed:@"another_ico.png"] forState:UIControlStateNormal];
    [mBtnGogoNav setTitle:@"其他地图导航" forState:UIControlStateNormal];
    mBtnGogoNav.titleLabel.textAlignment = NSTextAlignmentCenter;
    [mBtnGogoNav setTitleColor:[UIColor colorWithRed:1.0 green:136/255.0 blue:71/255.0 alpha:1.0] forState:UIControlStateNormal];
    mBtnGogoNav.titleLabel.font = [UIFont fontOfApp:26 / SCREEN_SCALAR];
    [mBtnGogoNav addTarget:self action:@selector(doGotoAppleNav) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mBtnGogoNav];
}

- (void)updateBottomMenu {
    
    if (mNearbyMenu == nil ||
        mRouteMenu == nil ||
        mBtnBack == nil ||
        mBtnGogoNav == nil) {
        
        return;
    }
    
    if (_isMainEntry) {
        
        [mNearbyMenu setHidden:NO];
        [mRouteMenu setHidden:YES];
        [mBtnBack setHidden:YES];
        [mBtnGogoNav setHidden:YES];
    }
    else {
        
        [mNearbyMenu setHidden:YES];
        [mRouteMenu setHidden:NO];
        [mBtnBack setHidden:NO];
        [mBtnGogoNav setHidden:NO];
    }
}

- (void)doBackToMainEntry {
    
    _isMainEntry = YES;
    [self updateBottomMenu];
    [self updateShowNearby];
}

- (void)doGotoMapFeatureView {
    
    [self showBuildMenu:YES];
}

- (void)doGotoAppleNav {
    
    
}

- (void)getNearbyBuildingFailed:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取周围建筑失败");
}

- (void)getNearbyBuildingSuccess:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取周围建筑成功 %@", notification);
    
    NSDictionary *userinfo = notification.userInfo;
    NSDictionary *result = [userinfo objectForKey:@"result"];
    NSDictionary *nearBuild = [result objectForKey:@"nearbuild"];
    
    // 清空现有数据
    [mBuildingInfo removeAllObjects];
    
    for (NSDictionary *dic in nearBuild) {
        
        migsBuildingInfo *buildinfo = [migsBuildingInfo setupBuildingInfoFromDictionary:dic];
        [mBuildingInfo addObject:buildinfo];
    }
    
    [self updateShowNearby];
}

- (void)updateShowNearby {
    
    // 清除屏幕上的点
    NSArray* array = [NSArray arrayWithArray:mMapView.annotations];
    [mMapView removeAnnotations:array];
    array = [NSArray arrayWithArray:mMapView.overlays];
    [mMapView removeOverlays:array];
    
    int count = [mBuildingInfo count];
    
    for (int i=0; i<count; i++) {
        
        migsBuildingInfo *buildinfo = [mBuildingInfo objectAtIndex:i];
        
        BMKPointAnnotation *item = [[BMKPointAnnotation alloc] init];
        item.coordinate = CLLocationCoordinate2DMake(buildinfo.fLatitude, buildinfo.fLongitude);
        item.title = buildinfo.name;
        mCurrentAnnotationType = buildinfo.buildType;
        [mMapView addAnnotation:item];
    }
}

// HorizontalMenuDelegate
- (void)didHorizontalMenuClickedButttonAtIndex:(NSInteger)index Type:(NSInteger)type {
    
    if (type == HORIZONTALMENU_TYPE_BUTTON_LABEL_RIGHT) {
        
        if (_isMainEntry) {
            
            if (index == 0) {
                
                // 请求推荐建筑信息，并显示页面
                [self.askApi doGetRecomBuild];
                [self doGotoMapFeatureView];
            }
        }
        else {
            
            if (index == 0) {
                
                [_mRouteSearchControl doRouteSearchByBusWithLastLocation];
            }
            else if (index == 1) {
                
                [_mRouteSearchControl doRouteSearchByCarWithLastLocation];
            }
            else if (index == 2) {
                
                [_mRouteSearchControl doRouteSearchByWalkWithLastLocation];
            }
        }
    }
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
    
    if (userLocation) {
        
        [[MyLocationManager GetInstance] updateLocationByLocation:userLocation.location.coordinate];
    }
}

- (void)didStopLocatingUser {
    
    MIGDEBUG_PRINT(@"%s", __FUNCTION__);
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    
    MIGDEBUG_PRINT(@"定位失败");
}

// BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id<BMKAnnotation>)annotation {
    
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"miglab";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        
        if ([mCurrentAnnotationType isEqualToString:@"1"]) {
            
            // 寺庙
            annotationView.image = [UIImage imageNamed:IMG_MAPID_TEMPLE];
        }
        else if ([mCurrentAnnotationType isEqualToString:@"2"]) {
            
            annotationView.image = [UIImage imageNamed:IMG_MAPID_BOOK];
        }
        else if ([mCurrentAnnotationType isEqualToString:@"3"]) {
            
            annotationView.image = [UIImage imageNamed:IMG_MAPID_FOOD];
        }
        else if ([mCurrentAnnotationType isEqualToString:@"4"]) {
            
            annotationView.image = [UIImage imageNamed:IMG_MAPID_FOJU];
        }
        else if ([mCurrentAnnotationType isEqualToString:@"5"]) {
            
            annotationView.image = [UIImage imageNamed:IMG_MAPID_CLOTHES];
        }
        else {
            
            ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        }
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
        
        // 重置图标类型
        mCurrentAnnotationType = @"";
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
    
    BMKPointAnnotation *point = view.annotation;
    CLLocationCoordinate2D culoc = point.coordinate;
    MIGDEBUG_PRINT(@"选中的坐标位置为: %f, %f", culoc.latitude, culoc.longitude);
}

- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    
    MIGDEBUG_PRINT(@"%s", __FUNCTION__);
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    
    return nil;
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
