//
//  SinaWeiboManager.m
//  Buddha
//
//  Created by Archer_LJ on 14/11/29.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "SinaWeiboManager.h"
#import "UserLoginInfoManager.h"

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
        
        // 授权成功
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            
            NSString *userid = [(WBAuthorizeResponse *)response userID];
            NSString *accesstoken = [(WBAuthorizeResponse *)response accessToken];
            
            UserLoginData *logindata = [[UserLoginData alloc] init];
            logindata.thirdUserId = userid;
            logindata.accesstoken = accesstoken;
            logindata.loginType = MIGLOGINTYPE_SINAWEIBO;
            
            MIGDEBUG_PRINT(@"新浪 userid:%@, accesstoken:%@", userid, accesstoken);
            
            [UserLoginInfoManager GetInstance].curLoginUser = logindata;
            
            // 新浪微博授权成功, 获取用户信息
            [self getUserInfo];
        }
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
    
}

- (void)getUserInfo {
    
    NSString *weibouserid = [UserLoginInfoManager GetInstance].curLoginUser.thirdUserId;
    NSString *accesstoken = [UserLoginInfoManager GetInstance].curLoginUser.accesstoken;
    
    MIGDEBUG_PRINT(@"新浪获取用户信息 userid=%@, accesstoken=%@", weibouserid, accesstoken);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:weibouserid forKey:@"uid"];
    
    [WBHttpRequest requestWithAccessToken:accesstoken url:@"https://api.weibo.com/2/users/show.json" httpMethod:@"GET" params:dic delegate:self withTag:@"userinfo"];
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result {
    
    NSDictionary *dicResult = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    int error = [[dicResult objectForKey:@"error_code"] intValue];
    
    if (error == 0) {
        
        MIGDEBUG_PRINT(@"新浪网络请求成功");
        
        NSString *username = [dicResult objectForKey:@"screen_name"];
        NSString *headerurl = [dicResult objectForKey:@"profile_image_url"];
        NSString *gender = [[dicResult objectForKey:@"gender"] isEqualToString:@"m"] ? @"1" : @"0";
        
        [UserLoginInfoManager GetInstance].curLoginUser.username = username;
        [UserLoginInfoManager GetInstance].curLoginUser.headerUrl = headerurl;
        [UserLoginInfoManager GetInstance].curLoginUser.gender = gender;
        
        // 调用本地的登录策略
        AskNetDataApi *askApi = [[AskNetDataApi alloc] init];
        [askApi doThirdLogin];
    }
    else {
        
        MIGDEBUG_PRINT(@"新浪网络请求返回失败，错误代码 %d", error);
    }
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error {
    
    MIGDEBUG_PRINT(@"新浪网络请求失败");
}

@end
