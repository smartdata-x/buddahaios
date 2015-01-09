//
//  MapBuidingInfoViewController.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/17.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"
#import "BaseNavViewController.h"
#import "EGOImageButton.h"
#import "HorizontalMenu.h"
#import "MapFeatureTableViewCell.h"
#import "ActivityDetailTableViewCell.h"

enum {
    
    PAGETYPE_MAPBUILD = 0,
    PAGETYPE_ACTIVITY,
};

@interface MapBuidingInfoViewController : BaseNavViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *mMainTableView;
    migsBuildingInfo *mBuildingInfo;
    NSString *mPhone;
    NSString *mDetailInfo;
}

@property (nonatomic, retain) UIViewController *mParentMapView;
@property (nonatomic, retain) NSString *buildID;
@property (nonatomic, assign) int pageType;

- (void)initialize:(migsBuildingInfo *)buildinfo PageType:(int)pageType;

- (void)initNav;
- (void)reloadData;

- (void)doSearchInMapView;
- (void)doCallPhoneNumber;

- (void)getSummary;
- (void)getSummaryFailed:(NSNotification *)notification;
- (void)getSummarySuccess:(NSNotification *)notification;

- (void)getActivitySummary;
- (void)getActivitySummaryFailed:(NSNotification *)notification;
- (void)getActivitySummarySuccess:(NSNotification *)notification;

- (void)doFav;
- (void)doShare;

@end
