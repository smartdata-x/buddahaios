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
#import "MapFeatureTableViewCell.h"

@interface MapViewController : BaseViewController<BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeneralDelegate, HorizontalMenuDelegate>
{
    BMKMapManager *mBDMapManager;
    BMKLocationService *mLocationService;
    BMKMapView *mMapView;
    
    // 底部周边菜单栏
    HorizontalMenu *mNearbyMenu;
    
    // 底部路线菜单，返回菜单和导航菜单
    HorizontalMenu *mRouteMenu;
    UIButton *mBtnBack;
    UIButton *mBtnGogoNav;
    
    // 推荐和附近建筑菜单
    MapBuildMenuView *mBuildMenu;
    
    // 周围建筑信息
    NSMutableArray *mBuildingInfo;
    
    // 用于添加点
    NSString *mCurrentAnnotationType;
}


@property (nonatomic, assign) BOOL isMainEntry; // 是否为地图的主入口, 主入口显示底部周边菜单，非主入口则显示底部路线菜单和导航菜单

@property (nonatomic, retain) MapPoiSearchController *mPoiSearchControl; // 搜索
@property (nonatomic, retain) MapRouteSearchController *mRouteSearchControl; // 路径规划

@property (nonatomic, retain) migsBuildingInfo *mLastBuildingInfo;

- (IBAction)startLocation:(id)sender;
- (IBAction)stopLocation:(id)sender;
- (IBAction)startFollowing:(id)sender;
- (IBAction)startFollowHeading:(id)sender;

- (void)initNearbyBottomMenu;
- (void)initRouteBottomMenu;

- (void)updateIsMainEntry; // 目前需要更新updateBottomMenu和updateShowNeary
- (void)updateBottomMenu;
- (void)updateShowNearby;

- (void)initBuildMenu;
- (void)showBuildMenu:(BOOL)animate;
- (void)hideBuildMenu:(BOOL)animate;

- (void)doGotoMapFeatureView; // 搜索建筑和推荐建筑页面
- (void)doGotoBuildingInfo:(NSString *)name; // 建筑详情
- (void)doBackToMainEntry;
- (void)doBackToBuildingInfo;

- (CLLocationCoordinate2D)BD09ToGCJ02:(CLLocationCoordinate2D)bdLoc;
- (void)doGotoAppleNav;

- (void)getNearbyBuildingFailed:(NSNotification *)notification;
- (void)getNearbyBuildingSuccess:(NSNotification *)notification;

@end
