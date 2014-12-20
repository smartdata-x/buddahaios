//
//  MapBuildMenuView.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/14.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"

enum
{
    MIG_MAP_BUILDING_TYPE_TEMPLE = 1,
    MIG_MAP_BUILDING_TYPE_BOOKSTORE,
    MIG_MAP_BUILDING_TYPE_FOODSTORE,
    MIG_MAP_BUILDING_TYPE_FOJU,
    MIG_MAP_BUILDING_TYPE_CLOTHESSTORE,
};

@interface MapBuildMenuView : UIView<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *mBuildInfoArray;
    
    UIView *titleView;
    
    float mTableStartY;
    UITableView *mFeatureTableView;
    NSMutableArray *mBuildTableInfo;
}

@property (nonatomic, retain) UIViewController *mParentMapView; // 父指针，用于返回时复制
@property (nonatomic, retain) UIViewController *mTopViewController; // Rootview指针，用于页面跳转

- (void)reloadTableData;

- (void)doBack;

- (IBAction)doSearchAction:(id)sender;
- (void)doSearch:(NSString *)type;

- (void)getBuildingFailed:(NSNotification *)notification;
- (void)getBuildingSuccess:(NSNotification *)notification;

@end
