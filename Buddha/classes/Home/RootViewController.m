//
//  RootViewController.m
//  Buddha
//
//  Created by Archer_LJ on 14/11/21.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "RootViewController.h"
#import "AFNetworking.h"
#import "AFHTTPClient.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFNetworkReachabilityManager.h"
#import "WeiboSDK.h"
#import "SinaWeiboManager.h"
#import "TencentWeixinManager.h"
#import "TencentQQManager.h"
#import "DatabaseManager.h"
#include "UserLoginInfoManager.h"

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self != nil) {
        
        [self initCommonData];
        [self initTopNavBar];
        _curShowViewTag = ROOTVIEWTAG_FEATURE;
        _mFirstLoad = YES;
        _mLoadAd = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAdvertiseSuccess:) name:MigNetNameGetAdSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAdvertiseFailed:) name:MigNetNameGetAdFailed object:nil];
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetAdSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetAdFailed object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initMainView];
    
    _dicViewControllerCache = [[NSMutableDictionary alloc] initWithCapacity:MAX_HORIZONTALMENU_TYPE];
    [self doUpdateView:_curShowViewTag];
    
    _mFirstLoad = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

// 改变横屏竖屏方向后重新布局
- (void)setLayout:(BOOL)isPortrait {
    
    [self setViewFrame];
}

- (void)doUpdateView:(NSInteger)viewTag {
    
    // remove
    UIView *oldShowView = [self.view viewWithTag:ROOTVIEWTAG_NULL];
    [oldShowView removeFromSuperview];
    
    // show
    UIViewController *controller = [self getControllerByTag:_curShowViewTag];
    UIView *newShowView = controller.view;
    newShowView.tag = ROOTVIEWTAG_NULL;
    newShowView.frame = CGRectMake(0, 0, mainScreenWidth, mainScreenHeight);
    [self.view insertSubview:newShowView atIndex:0];
}

- (UIViewController *)getControllerByTag:(NSInteger)tag {
    
    NSNumber *numIndex = [NSNumber numberWithInteger:tag];
    UIViewController *controller = [_dicViewControllerCache objectForKey:numIndex];
    
    switch (tag) {
        case ROOTVIEWTAG_FEATURE:
        {
            if (controller) {
                
                FeaturedViewController *feature = (FeaturedViewController *)controller;
                [feature viewWillAppear:YES];
            }
            else {
                
                FeaturedViewController *feature = [[FeaturedViewController alloc] init];
                feature.mFrame = mContentFrame;
                [feature viewWillAppear:YES];
                [_dicViewControllerCache setObject:feature forKey:numIndex];
                controller = feature;
            }
        }
            break;
            
        case ROOTVIEWTAG_MAP:
        {
            if (controller) {
                
                MapViewController *map = (MapViewController *)controller;
                [map viewWillAppear:YES];
            }
            else {
                
                MapViewController *map = [[MapViewController alloc] init];
                map.mFrame = mContentFrame;
                [map viewWillAppear:YES];
                [_dicViewControllerCache setObject:map forKey:numIndex];
                controller = map;
            }
        }
            break;
            
        default:
            break;
    }
    
    return controller;
}

// 重载导航条
- (void)initTopNavBar {
    
    float navHeight = 44.0;
    
    // 左按钮
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (navHeight - 24) / 2.0, 100, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:IMG_PAGE_LOGO] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:IMG_PAGE_LOGO] forState:UIControlStateSelected];
    //[leftButton setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    // 中间
    self.navigationItem.titleView = [[CustomNavView alloc] initWithFrame:CGRectMake(0, 0, 140, navHeight)];
    
    // 右按钮
    float rBtnSize = 28;
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (navHeight - rBtnSize) / 2.0, rBtnSize, rBtnSize)];
    [rightButton setBackgroundImage:[UIImage imageNamed:IMG_HOME_MESSAGE] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:IMG_HOME_MESSAGE] forState:UIControlStateSelected];
    [rightButton setTitle:@"" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

// 初始化全局数据
- (void)initCommonData {

    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // 注册新浪微博, 微信, QQ
    [[SinaWeiboManager GetInstance] doRegister];
    [[TencentWeixinManager GetInstance] doRegister];
    [[TencentQQManager GetInstance] doRegister];
    
    // 检查上次登录状态
    [UserLoginInfoManager GetInstance].isLogin = NO;
    if ([[DatabaseManager GetInstance] getLastLoginOrNot] != 0) {
        
        // 上次已登录，从本地数据库获取登录信息
        UserLoginData *logindata = [[DatabaseManager GetInstance] getLastUserLoginData];
        [UserLoginInfoManager GetInstance].curLoginUser = logindata;
        [UserLoginInfoManager GetInstance].isLogin = YES;
    }
    
    // 初始化百度地图
    mBDMapManager = [[BMKMapManager alloc] init];
    BOOL ret = [mBDMapManager start:@"96IS38XTSvyMSLgpPbV0FjKq" generalDelegate:self];
    if (!ret) {
        
        MIGDEBUG_PRINT(@"百度地图启动成功");
    }
    
#if 0
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager startMonitoring];
    
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                MIGDEBUG_PRINT(@"connect by wifi, can work");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                MIGDEBUG_PRINT(@"connect by 3G");
                break;
                
            case AFNetworkReachabilityStatusUnknown:
            default:
                MIGDEBUG_PRINT(@"not by wifi, disable work");
                break;
        }
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }];
#endif
}

- (void)initMainView {
    
    float titleWidth = TOP_MENU_BUTTON_WIDTH;
    float baseWidth = BOTTOM_MENU_BUTTON_WIDTH;
    float ystart = NAVIGATION_HEIGHT;
    
    NSArray *topButtonItemArray = @[@{KEY_NORMAL:IMG_HOME_NORMAL_BG,
                                      KEY_HILIGHT:IMG_HOME_HILIGHT_BG,
                                      KEY_TITLE:@"推荐",
                                      KEY_TITLE_WIDTH:[NSNumber numberWithFloat:titleWidth]
                                      },
                                    @{KEY_NORMAL:IMG_HOME_NORMAL_BG,
                                      KEY_HILIGHT:IMG_HOME_HILIGHT_BG,
                                      KEY_TITLE:@"介绍",
                                      KEY_TITLE_WIDTH:[NSNumber numberWithFloat:titleWidth]
                                      },
                                    @{KEY_NORMAL:IMG_HOME_NORMAL_BG,
                                      KEY_HILIGHT:IMG_HOME_HILIGHT_BG,
                                      KEY_TITLE:@"书库",
                                      KEY_TITLE_WIDTH:[NSNumber numberWithFloat:titleWidth]
                                      },
                                    @{KEY_NORMAL:IMG_HOME_NORMAL_BG,
                                      KEY_HILIGHT:IMG_HOME_HILIGHT_BG,
                                      KEY_TITLE:@"地图",
                                      KEY_TITLE_WIDTH:[NSNumber numberWithFloat:titleWidth]
                                      },
                                    @{KEY_NORMAL:IMG_HOME_NORMAL_BG,
                                      KEY_HILIGHT:IMG_HOME_HILIGHT_BG,
                                      KEY_TITLE:@"活动",
                                      KEY_TITLE_WIDTH:[NSNumber numberWithFloat:titleWidth]
                                      }];
    
    NSArray *bottomItemArray = @[@{KEY_NORMAL:IMG_FOUND_FO,
                                   KEY_HILIGHT:IMG_FOUND_FO_ON,
                                   KEY_TITLE:@"发现佛缘",
                                   KEY_TITLE_WIDTH:[NSNumber numberWithFloat:baseWidth]
                                   },
                                 @{KEY_NORMAL:IMG_MY_FO,
                                   KEY_HILIGHT:IMG_MY_FO_ON,
                                   KEY_TITLE:@"我的佛缘",
                                   KEY_TITLE_WIDTH:[NSNumber numberWithFloat:baseWidth]
                                   },
                                 @{KEY_NORMAL:IMG_USER_CENTER,
                                   KEY_HILIGHT:IMG_USER_CENTER_ON,
                                   KEY_TITLE:@"个人中心",
                                   KEY_TITLE_WIDTH:[NSNumber numberWithFloat:baseWidth]
                                   },
                                 ];
    
    // 初始化顶部菜单
    if (_mTopMenu == nil) {
        
        _mTopMenu = [[HorizontalMenu alloc] initWithFrame:CGRectMake(0, ystart, self.view.frame.size.width, TOP_MENU_HEIGHT) ButtonItems:topButtonItemArray ButtonType:HORIZONTALMENU_TYPE_BUTTON];
        _mTopMenu.delegate = self;
    }
    ystart += TOP_MENU_HEIGHT;
    
    float bottomHeight = BOTTOM_MENU_BUTTON_HEIGHT;
    if (_mLoadAd) {
        
        bottomHeight += BOTTOM_AD_HEIGHT;
    }
    
    // 设置view的大小
    mContentFrame = CGRectMake(0, ystart, self.view.frame.size.width, self.view.frame.size.height - ystart - bottomHeight);
    
    // 初始化底部菜单
    if (_mBottomMenu == nil) {
        
        _mBottomMenu = [[HorizontalMenu alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - bottomHeight, self.view.frame.size.width, BOTTOM_MENU_BUTTON_HEIGHT) ButtonItems:bottomItemArray ButtonType:HORIZONTALMENU_TYPE_BUTTON_LABEL];
        _mBottomMenu.delegate = self;
    }
    
    if (_mBottomAd == nil) {
        
        _mBottomAd = [[EGOImageButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - BOTTOM_AD_HEIGHT, self.view.frame.size.width, BOTTOM_AD_HEIGHT)];
    }
    
    if (!_mLoadAd) {
        
        _mBottomAd.hidden = YES;
    }
    
    // 设置第一个按钮为选中
    [_mTopMenu clickButtonAtIndex:0];
    [_mBottomMenu clickButtonAtIndex:0];
    
    [self.view addSubview:_mTopMenu];
    [self.view addSubview:_mBottomMenu];
    [self.view addSubview:_mBottomAd];
    
    if (mADTable == nil) {
        
        mADTable = [[NSMutableArray alloc] init];
    }
}

- (void)reArrangeView {
    
#if 0
    float ystart = NAVIGATION_HEIGHT;
    
    // 顶部菜单位置
    _mTopMenu.frame = CGRectMake(0, ystart, self.view.frame.size.width, TOP_MENU_HEIGHT);
    ystart += TOP_MENU_HEIGHT;
    
    float bottomHeight = BOTTOM_MENU_BUTTON_HEIGHT;
    if (_mLoadAd) {
        
        bottomHeight += BOTTOM_AD_HEIGHT;
    }
    
    // 设置view的大小
    mContentFrame = CGRectMake(0, ystart, self.view.frame.size.width, self.view.frame.size.height - ystart - bottomHeight);
    
    _mBottomMenu.frame = CGRectMake(0, self.view.frame.size.height - bottomHeight, self.view.frame.size.width, BOTTOM_MENU_BUTTON_HEIGHT);
    
    if (_mBottomAd) {
        
        _mBottomAd.hidden = NO;
        _mBottomAd.frame = CGRectMake(0, self.view.frame.size.height - BOTTOM_AD_HEIGHT, self.view.frame.size.width, BOTTOM_AD_HEIGHT);
        _mBottomAd.imageURL = [NSURL URLWithString:[mADTable objectAtIndex:0]];
    }
    else {
        
        _mBottomAd.hidden = YES;
    }
    
    UIViewController *controller = [self getControllerByTag:_curShowViewTag];
    [controller viewWillAppear:YES];
    [self viewWillAppear:YES];
#endif
    
    _mBottomAd.imageURL = [NSURL URLWithString:[mADTable objectAtIndex:0]];
}

- (void)getAdvertiseSuccess:(NSNotification *)notification {
    
    NSDictionary *userinfo = [notification userInfo];
    NSArray *result = [userinfo objectForKey:@"result"];
    
    for (NSDictionary *dic in result) {
        
        NSString *pic = [dic objectForKey:@"pic"];
        [mADTable addObject:pic];
    }
    
    //_mLoadAd = YES;
    [self reArrangeView];
}

- (void)getAdvertiseFailed:(NSNotification *)notification {
    
    //_mLoadAd = NO;
    [self reArrangeView];
}


// 设置View方向
- (void)setViewFrame {
    
    
}

// CustomNavView delegate
- (void)didCustomNavViewClicked {
    
    
}

// HorizontalMenu Delegate
- (void)didHorizontalMenuClickedButttonAtIndex:(NSInteger)index Type:(NSInteger)type {
    
    // 初始化的时候不响应delegate
    if (_mFirstLoad) {
        
        return;
    }
    
    if (type == HORIZONTALMENU_TYPE_BUTTON) {
        
        // 顶部菜单
        MIGDEBUG_PRINT(@"top Menu of %d index clicked", index);
        
        _curShowViewTag = index;
        [self doUpdateView:_curShowViewTag];
    }
    else if (type == HORIZONTALMENU_TYPE_BUTTON_LABEL) {
        
        // 底部菜单
        MIGDEBUG_PRINT(@"bottom Menu of %d index clicked", index);
        
        if (0 == index) {
            
            [[SinaWeiboManager GetInstance] doLoginRequest];
        }
        else if (1 == index) {
            
            [[TencentWeixinManager GetInstance] doLoginRequest];
        }
        else if (2 == index) {
            
            [[TencentQQManager GetInstance] doLoginRequest];
        }
    }
}

// BMKGeneral Delegate
-(void)onGetNetworkState:(int)iError
{
    if (iError == 0)
    {
        NSLog(@"网络连接正常");
    }
    else
    {
        NSLog(@"网络错误:%d",iError);
    }
}

-(void)onGetPermissionState:(int)iError
{
    if (iError == 0)
    {
        NSLog(@"授权成功");
    }
    else
    {
        NSLog(@"授权失败:%d",iError);
    }
}

@end