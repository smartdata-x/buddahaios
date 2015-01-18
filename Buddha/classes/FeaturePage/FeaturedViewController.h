//
//  FeaturedViewController.h
//  Buddha
//
//  Created by Archer_LJ on 14/11/26.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FeaturedNewsCell.h"
#import "FeaturedBooksCell.h"
#import "FeaturedActivitiesCell.h"

enum {
    
    SECTION_NEWS = 0,
    SECTION_BOOKS,
    SECTION_ACTIVITIES,
    MAX_SECTION,
};

@interface FeaturedViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger mRowCount;
    
    NSString *newsTitle;
    NSString *newsSummary;
    NSString *newsPic;
    
    NSMutableArray *activityTitle;
    NSMutableArray *activityPic;
}

@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, retain) UITableView *contentTableView;
@property (nonatomic, retain) NSMutableArray *tableInfoArray;
@property (nonatomic, retain) NSMutableArray *contentTableBookInfo; // migsBookIntroduce
@property (nonatomic, retain) NSMutableArray *contentTableActivityInfo; // migsBuildingInfo

- (void)reloadTableViewDataSource;
- (void)forceRefreshData;

- (void)getRecom;
- (void)getRecomFailed:(NSNotification *)notification;
- (void)getRecomSuccess:(NSNotification *)notification;

- (IBAction)doGotoBookPage:(id)sender;
- (IBAction)doGotoActivity:(id)sender;

@end
