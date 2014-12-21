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

@interface MapBuidingInfoViewController : BaseNavViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *mMainTableView;
    migsBuildingInfo *mBuildingInfo;
    NSString *mPhone;
    NSString *mDetailInfo;
}

@property (nonatomic, retain) UIViewController *mParentMapView;
@property (nonatomic, retain) NSString *buildID;


- (void)initialize:(migsBuildingInfo *)buildinfo;

- (void)initNav;
- (void)doSearchInMapView;
- (void)reloadData;

- (void)getSummary;
- (void)getSummaryFailed:(NSNotification *)notification;
- (void)getSummarySuccess:(NSNotification *)notification;

@end
