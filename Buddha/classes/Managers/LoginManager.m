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
        }
    }
    
    return instance;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameThirdLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameThirdLoginFailed object:nil];
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

- (void)doLogOut {
    
    [[DatabaseManager GetInstance] insertLoginOrNot:DATABASE_LOGOUT];
}

- (void)LoginFromThirdPartSuccess:(NSNotification *)notification {
    
    // 登录成功，保存当前登录信息到数据库，并设置用户已登录状态
    [UserLoginInfoManager GetInstance].isLogin = YES;
    [[DatabaseManager GetInstance] insertUserLoginData:[UserLoginInfoManager GetInstance].curLoginUser];
    [[DatabaseManager GetInstance] insertLoginOrNot:DATABASE_LOGIN];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MigLocalNameLoginSuccess object:nil userInfo:nil];
}

- (void)LoginFromThirdPartFailed:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MigLocalNameLoginFailed object:nil userInfo:nil];
}

@end
