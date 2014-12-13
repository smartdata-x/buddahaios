//
//  MapBuildMenuView.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/14.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"

@interface MapBuildMenuView : UIView<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *mBuildInfoArray;
    
    UIView *titleView;
    
    float mTableStartY;
    UITableView *mFeatureTableView;
    NSMutableArray *mInfoImage;
    NSMutableArray *mInfoTitle;
    NSMutableArray *mInfoDetail;
    NSMutableArray *mInfoDistance;
}

@property (nonatomic, retain) UIViewController *mTopMapView; // 父指针，用于返回时复制

- (void)reloadTableData;

- (void)doBack;

@end
