//
//  AppDelegate.m
//  Buddha
//
//  Created by Archer_LJ on 14/11/17.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "OpenUrlManager.h"
#import "MyLocationManager.h"
#import "AFNetworking.h"
#import "LoginManager.h"
#import "DatabaseManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize navController = _navController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (launchOptions) {
        
        NSDictionary *pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        if (pushNotificationKey) {
            
            // 程序通过远程推送消息启动
        }
    }
    
    // 开始启动界面之前，先初始化需要的全局数据
    [self initCommonData];
    
    self.window = [[UIWindow alloc] initWithFrame:mainScreenFrame];
    self.window.backgroundColor = [UIColor whiteColor];
    
    RootViewController *rootView = [[RootViewController alloc] init];
    _navController = [[UINavigationController alloc] initWithRootViewController:rootView];
    
    [_navController.navigationBar setBarTintColor:MIG_COLOR_53645E];
    _navController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.window.rootViewController = _navController;
    [self.window addSubview:self.navController.view];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [[OpenUrlManager GetInstance] openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [[OpenUrlManager GetInstance] handleOpenURL:url];
}

// 初始化全局数据
- (void)initCommonData {
    
    // 更新地理位置, 地理位置最先更新，确保能够最快的获取到地理坐标
    [[MyLocationManager GetInstance] updateLocation];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // 注册新浪微博, 微信, QQ
    [[LoginManager GetInstance] registerLogins];
    
    // 检查上次登录状态
    int lastLoginState = [[DatabaseManager GetInstance] getLastLoginOrNot];
    if (lastLoginState == DATABASE_LOGOUT) {
        
        // 上次没有登录
        [UserLoginInfoManager GetInstance].isLogin = NO;
        [UserLoginInfoManager GetInstance].isQuickLogin = NO;
    }
    else if (lastLoginState == DATABASE_LOGIN || lastLoginState == DATABASE_QUICKLOGIN) {
        
        // 上次已登录，从本地数据库获取登录信息
        UserLoginData *logindata = [[DatabaseManager GetInstance] getLastUserLoginData];
        
        if (logindata != nil) {
            
            [UserLoginInfoManager GetInstance].curLoginUser = logindata;
            [UserLoginInfoManager GetInstance].isLogin = (lastLoginState == DATABASE_LOGIN);
            [UserLoginInfoManager GetInstance].isQuickLogin = (lastLoginState == DATABASE_QUICKLOGIN);
        }
        else {
            
            [[DatabaseManager GetInstance] insertLoginOrNot:DATABASE_LOGOUT];
            [UserLoginInfoManager GetInstance].isLogin = NO;
            [UserLoginInfoManager GetInstance].isQuickLogin = NO;
        }
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

@end
