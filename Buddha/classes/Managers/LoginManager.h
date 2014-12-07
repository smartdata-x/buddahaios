//
//  LoginManager.h
//  Buddha
//
//  Created by Archer_LJ on 14/11/25.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeiboManager.h"
#import "TencentWeixinManager.h"
#import "TencentQQManager.h"
#import "UserLoginInfoManager.h"
#import "DatabaseManager.h"
#import "AskNetDataApi.h"

/*
 登录过程
 1. 调用第三方Manager的doLoginRequest
 2. 在登陆成功后的回调中获取accesstoken参数，然后调用第三方的getUserInfo
 3. 在获取用户信息的回调中调用mig的登陆
 4. 在mig的返回数据中获取userid，然后保存到数据库，完成登录
 */

@interface LoginManager : UIView

+ (LoginManager *)GetInstance;

- (void)registerLogins;

- (void)doSinaWeiboLogin;
- (void)doTencentWeixinLogin;
- (void)doTencentQQLogin;
- (void)doLogOut;

- (void)doQuickLogin;

- (void)LoginFromThirdPartSuccess:(NSNotification *)notification;
- (void)LoginFromThirdPartFailed:(NSNotification *)notification;

- (void)quickLoginSuccess:(NSNotification *)notification;
- (void)quickLoginFailed:(NSNotification *)notification;

@end
