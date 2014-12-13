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
#import "MapPoiSearchController.h"
#import "MapRouteSearchController.h"
#import "HorizontalMenu.h"
#import "MapBuildMenuView.h"

@interface MapViewController : BaseViewController<BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeneralDelegate, HorizontalMenuDelegate>
{
    BMKMapManager *mBDMapManager;
    BMKLocationService *mLocationService;
    BMKMapView *mMapView;
    
    MapPoiSearchController *mPoiSearchControl; // 搜索
    MapRouteSearchController *mRouteSearchControl; // 路径规划
    
    // 底部周边菜单栏
    HorizontalMenu *mNearbyMenu;
    
    // 底部路线菜单，返回菜单和导航菜单
    HorizontalMenu *mRouteMenu;
    UIButton *mBtnBack;
    UIButton *mBtnGogoNav;
    
    // 推荐和附近建筑菜单
    MapBuildMenuView *mBuildMenu;
}


@property (nonatomic, assign) BOOL isMainEntry; // 是否为地图的主入口, 主入口显示底部周边菜单，非主入口则显示底部路线菜单和导航菜单

- (IBAction)startLocation:(id)sender;
- (IBAction)stopLocation:(id)sender;
- (IBAction)startFollowing:(id)sender;
- (IBAction)startFollowHeading:(id)sender;

- (void)initNearbyBottomMenu;
- (void)initRouteBottomMenu;
- (void)updateBottomMenu;

- (void)initBuildMenu;
- (void)showBuildMenu:(BOOL)animate;
- (void)hideBuildMenu:(BOOL)animate;

- (void)doGotoMapFeatureView;
- (void)doBackToMainEntry;
- (void)doGotoAppleNav;

@end
