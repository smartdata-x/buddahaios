//
//  SinaWeiboManager.m
//  Buddha
//
//  Created by Archer_LJ on 14/11/29.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "SinaWeiboManager.h"
#import "UserLoginInfoManager.h"
#import "DatabaseManager.h"

@implementation SinaWeiboManager

+ (SinaWeiboManager *)GetInstance {
    
    static SinaWeiboManager *instance = nil;
    
    @synchronized(self) {
        
        if (nil == instance) {
            
            instance = [[SinaWeiboManager alloc] init];
        }
    }
    
    return instance;
}

- (void)doRegister {
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
}

- (BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)handleOpenURL:(NSURL *)url {
        
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (void)doLoginRequest {
    
    if ([UserLoginInfoManager GetInstance].isLogin) {
        
        // 已经登陆了，不需要再发送登录请求
        return;
    }
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

// WeiboSDK Delegate
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    
    if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        
        NSString *userid = [(WBAuthorizeResponse *)response userID];
        NSString *accesstoken = [(WBAuthorizeResponse *)response accessToken];
        
        UserLoginData *logindata = [[UserLoginData alloc] init];
        logindata.userid = userid;
        logindata.accesstoken = accesstoken;
        logindata.loginType = MIGLOGINTYPE_SINAWEIBO;
        
        // 保存当前登录信息，并设置用户已登录状态
        [UserLoginInfoManager GetInstance].curLoginUser = logindata;
        [UserLoginInfoManager GetInstance].isLogin = YES;
        [[DatabaseManager GetInstance] insertUserLoginData:logindata];
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
    
}

@end
