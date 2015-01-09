//
//  RootViewController.h
//  Buddha
//
//  Created by Archer_LJ on 14/11/21.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "CustomNavView.h"
#import "FeaturedViewController.h"
#import "MapViewController.h"
#import "BookStoreViewController.h"
#import "ActivityViewController.h"
#import "HorizontalMenu.h"

// 每个继承类的标志
enum {
    
    ROOTVIEWTAG_FEATURE = 0,
    ROOTVIEWTAG_PREFER,
    ROOTVIEWTAG_LIBRARY,
    ROOTVIEWTAG_MAP,
    ROOTVIEWTAG_ACTIVITY,
    MAX_ROOTVIEWTAG,
    
    ROOTVIEWTAG_LOGOUT = 50,
    
    ROOTVIEWTAG_CURRENT = 100,
};

@interface RootViewController : UIViewController<CustomNavViewDelegate, BMKGeneralDelegate, HorizontalMenuDelegate>
{
    BMKMapManager *mBDMapManager;
    CGRect mContentFrame;
    NSMutableArray *mADTable;
}

@property (nonatomic, retain) HorizontalMenu *mTopMenu;
@property (nonatomic, retain) HorizontalMenu *mBottomMenu;
@property (nonatomic, retain) EGOImageButton *mBottomAd;
@property (nonatomic, assign) BOOL mFirstLoad;
@property (nonatomic, assign) BOOL mLoadAd;
@property (nonatomic, retain) NSMutableDictionary *dicViewControllerCache;
@property (nonatomic, assign) NSInteger curShowViewTag;

- (void)doUpdateView:(NSInteger)viewTag;

- (void)getAdvertiseSuccess:(NSNotification *)notification;
- (void)getAdvertiseFailed:(NSNotification *)notification;

@end
