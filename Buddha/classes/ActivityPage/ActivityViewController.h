//
//  ActivityViewController.h
//  Buddha
//
//  Created by Archer_LJ on 15/1/6.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"
#import "BaseViewController.h"

@interface ActivityViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UIView *classicWrapper;
    NSMutableArray *topActivityInfo;
    
    UIView *titleView;
    
    UITableView *otherActTableView;
    NSMutableArray *otherActTableInfo;
    
    migsImgWithTitleAndDetail *choosedInfo;
}

// 内部
- (void)reloadData;

- (void)initTopActivityView:(float)ystart;
- (void)initClassicView:(float)ystart;
- (void)initTableView:(float)ystart;

- (IBAction)doGotoBuildingView:(id)sender;

- (void)getActivityFailed:(NSNotification *)notification;
- (void)getActivitySuccess:(NSNotification *)notification;

@end
