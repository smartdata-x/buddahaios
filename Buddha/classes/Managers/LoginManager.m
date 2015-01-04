//
//  LoginManager.m
//  Buddha
//
//  Created by Archer_LJ on 14/11/25.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "LoginManager.h"

@implementation LoginManager

+ (LoginManager *)GetInstance {
    
    static LoginManager *instance = nil;
    
    @synchronized(self) {
        
        if (nil == instance) {
            
            instance = [[LoginManager alloc] init];
            
            [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(LoginFromThirdPartSuccess:) name:MigNetNameThirdLoginSuccess object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(LoginFromThirdPartFailed:) name:MigNetNameThirdLoginFailed object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(quickLoginSuccess:) name:MigNetNameQuickLoginSuccess object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(quickLoginFailed:) name:MigNetNameQuickLoginFailed object:nil];
        }
    }
    
    return instance;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameThirdLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameThirdLoginFailed object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameQuickLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameQuickLoginFailed object:nil];
}

- (void)registerLogins {
    
    [[SinaWeiboManager GetInstance] doRegister];
    [[TencentWeixinManager GetInstance] doRegister];
    [[TencentQQManager GetInstance] doRegister];
}

- (void)doSinaWeiboLogin {
    
    [[SinaWeiboManager GetInstance] doLoginRequest];
}

- (void)doTencentWeixinLogin {
    
    [[TencentWeixinManager GetInstance] doLoginRequest];
}

- (void)doTencentQQLogin {
    
    [[TencentQQManager GetInstance] doLoginRequest];
}

- (void)doSinaWeiboShare {
    
    MIGDEBUG_PRINT(@"新浪微博分享");
}

- (void)doTencentWeixinShare {
    
    MIGDEBUG_PRINT(@"微信分享");
}

- (void)doTencentQQShare {
    
    MIGDEBUG_PRINT(@"QQ分享");
}

- (void)doLogOut {
    
    [[DatabaseManager GetInstance] insertLoginOrNot:DATABASE_LOGOUT];
}

- (void)doQuickLogin {
    
    AskNetDataApi *askApi = [[AskNetDataApi alloc] init];
    [askApi doQuickLogin];
}

- (void)LoginFromThirdPartSuccess:(NSNotification *)notification {
    
    // 登录成功，保存当前登录信息到数据库，并设置用户已登录状态
    NSDictionary *userinfo = [notification userInfo];
    NSDictionary *result = [userinfo objectForKey:@"result"];
    NSDictionary *logininfo = [result objectForKey:@"userinfo"];
    
    NSString *userid = [logininfo objectForKey:@"uid"];
    NSString *token = [logininfo objectForKey:@"token"];
    NSString *address = [logininfo objectForKey:@"address"];
    NSString *username = [logininfo objectForKey:@"nickname"];
    NSString *source = [logininfo objectForKey:@"source"];
    NSString *headurl = [logininfo objectForKey:@"head"];
    
    UserLoginData *userlogindata = [UserLoginInfoManager GetInstance].curLoginUser;
    userlogindata.userid = userid;
    userlogindata.token = token;
    userlogindata.address = address;
    userlogindata.username = username;
    userlogindata.loginType = source;
    userlogindata.headerUrl = headurl;
    
    [UserLoginInfoManager GetInstance].isLogin = YES;
    [[DatabaseManager GetInstance] insertUserLoginData:[UserLoginInfoManager GetInstance].curLoginUser];
    [[DatabaseManager GetInstance] insertLoginOrNot:DATABASE_LOGIN];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MigLocalNameLoginSuccess object:nil userInfo:nil];
}

- (void)LoginFromThirdPartFailed:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MigLocalNameLoginFailed object:nil userInfo:nil];
}

- (void)quickLoginSuccess:(NSNotification *)notification {
    
    NSDictionary *userinfo = [notification userInfo];
    NSDictionary *result = [userinfo objectForKey:@"result"];
    NSDictionary *logininfo = [result objectForKey:@"userinfo"];
    
    NSString *userid = [logininfo objectForKey:@"uid"];
    NSString *token = [logininfo objectForKey:@"token"];
    NSString *address = [logininfo objectForKey:@"address"];
    NSString *username = [logininfo objectForKey:@"nickname"];
    NSString *logintype = [logininfo objectForKey:@"source"];
    NSString *headurl = [logininfo objectForKey:@"head"];
    
    if (!MIG_IS_EMPTY_STRING(userid) && !MIG_IS_EMPTY_STRING(token)) {
        
        UserLoginData *logindata = [[UserLoginData alloc] init];
        logindata.userid = userid;
        logindata.token = token;
        logindata.address = address;
        logindata.username = username;
        logindata.headerUrl = headurl;
        logindata.loginType = logintype;
        
        [UserLoginInfoManager GetInstance].curLoginUser = logindata;
        [UserLoginInfoManager GetInstance].isQuickLogin = YES;
        [[DatabaseManager GetInstance] insertUserLoginData:logindata];
        [[DatabaseManager GetInstance] insertLoginOrNot:DATABASE_QUICKLOGIN];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MigLocalNameLoginSuccess object:nil userInfo:nil];
    }
}

- (void)quickLoginFailed:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MigLocalNameLoginFailed object:nil userInfo:nil];
}

@end
