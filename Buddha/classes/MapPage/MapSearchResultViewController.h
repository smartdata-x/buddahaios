//
//  MapSearchResultViewController.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/20.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"
#import "BaseNavViewController.h"
#import "HorizontalMenu.h"
#import "TwoPageMenuVIew.h"

@interface MapSearchResultViewController : BaseNavViewController<UITableViewDataSource, UITableViewDelegate, HorizontalMenuDelegate>
{
    UITableView *mBuildTableView;
    NSMutableArray *mBuildTableInfo;
    
    TwoPageMenuVIew *mNearbyMenu;
}

@property (nonatomic, retain) UIViewController *mParentMapView; // 父指针，用于返回时复制
@property (nonatomic, retain) IBOutlet HorizontalMenu *mTopMenu;
@property (nonatomic, retain) IBOutlet UIView *mTopMenuWrapper;

@property (nonatomic, assign) BOOL isNearbyMenuShow;

- (void)initTopMenu;
- (void)initTableView;
- (void)initNav;

- (void)reloadData;

- (void)getTypeBuildingFailed:(NSNotification *)notification;
- (void)getTypeBuildingSuccess:(NSNotification *)notification;

@end
