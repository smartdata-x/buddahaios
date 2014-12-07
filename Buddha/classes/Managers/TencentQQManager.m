//
//  TencentQQManager.m
//  Buddha
//
//  Created by Archer_LJ on 14/11/30.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "TencentQQManager.h"
#import "UserLoginInfoManager.h"

@implementation TencentQQManager

+ (TencentQQManager *)GetInstance {
    
    static TencentQQManager *instance = nil;
    
    @synchronized(self) {
        
        if (nil == instance) {
            
            instance = [[TencentQQManager alloc] init];
        }
    }
    
    return instance;
}

- (void)doRegister {
    
    tencentOAuth = [[TencentOAuth alloc] initWithAppId:kQQAppKey andDelegate:self];
}

- (BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [TencentOAuth HandleOpenURL:url];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    
    return [TencentOAuth HandleOpenURL:url];
}

- (void)doLoginRequest {
    
    permissions = [NSArray arrayWithObjects:
                    kOPEN_PERMISSION_GET_USER_INFO,
                    kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                    kOPEN_PERMISSION_ADD_ALBUM,
                    kOPEN_PERMISSION_ADD_IDOL,
                    kOPEN_PERMISSION_ADD_ONE_BLOG,
                    kOPEN_PERMISSION_ADD_PIC_T,
                    kOPEN_PERMISSION_ADD_SHARE,
                    kOPEN_PERMISSION_ADD_TOPIC,
                    kOPEN_PERMISSION_CHECK_PAGE_FANS,
                    kOPEN_PERMISSION_DEL_IDOL,
                    kOPEN_PERMISSION_DEL_T,
                    kOPEN_PERMISSION_GET_FANSLIST,
                    kOPEN_PERMISSION_GET_IDOLLIST,
                    kOPEN_PERMISSION_GET_INFO,
                    kOPEN_PERMISSION_GET_OTHER_INFO,
                    kOPEN_PERMISSION_GET_REPOST_LIST,
                    kOPEN_PERMISSION_LIST_ALBUM,
                    kOPEN_PERMISSION_UPLOAD_PIC,
                    kOPEN_PERMISSION_GET_VIP_INFO,
                    kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                    kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                    kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                    nil];
    
#if 0
    permissions = [NSArray arrayWithObjects:
                   kOPEN_PERMISSION_GET_USER_INFO,
                   kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                   kOPEN_PERMISSION_GET_INFO,
                   nil];
#endif

    [tencentOAuth authorize:permissions inSafari:NO];
}

// TencentSession Delegate
- (void)tencentDidLogin {
    
    if (tencentOAuth.accessToken && 0 != [tencentOAuth.accessToken length]) {
        
        MIGDEBUG_PRINT(@"QQ登录成功");
        
        UserLoginData *userlogindata = [[UserLoginData alloc] init];
        userlogindata.openid = tencentOAuth.openId;
        userlogindata.thirdtoken = tencentOAuth.accessToken;
        userlogindata.expireDate = tencentOAuth.expirationDate;
        userlogindata.loginType = MIGLOGINTYPE_TENCENTQQ;
        
        [UserLoginInfoManager GetInstance].curLoginUser = userlogindata;
        
        // 调用接口获取用户信息
        [tencentOAuth getUserInfo];
    }
    else {
        
        MIGDEBUG_PRINT(@"QQ登录失败");
    }
}

- (void)getUserInfoResponse:(APIResponse *)response {
    
    if (response.retCode == URLREQUEST_SUCCEED) {
        
        NSString *username = [response.jsonResponse objectForKey:@"nickname"];
        NSString *headerurl = [response.jsonResponse objectForKey:@"figureurl"];
        NSString *gender = [[response.jsonResponse objectForKey:@"gender"] isEqualToString:@"男"] ? @"1" : @"0";
        NSString *birthday = [response.jsonResponse objectForKey:@""];
        NSString *address = [response.jsonResponse objectForKey:@"city"];
        NSString *struid = [UserLoginInfoManager GetInstance].curLoginUser.openid;
        
        [UserLoginInfoManager GetInstance].curLoginUser.username = username;
        [UserLoginInfoManager GetInstance].curLoginUser.headerUrl = headerurl;
        [UserLoginInfoManager GetInstance].curLoginUser.gender = gender;
        [UserLoginInfoManager GetInstance].curLoginUser.birthday = birthday;
        [UserLoginInfoManager GetInstance].curLoginUser.address = address;
        [UserLoginInfoManager GetInstance].curLoginUser.thirdIDStr = struid;
        
        // 第三方登陆成功, 向服务器发送登陆状态信息
        AskNetDataApi *askApi = [[AskNetDataApi alloc] init];
        [askApi doThirdLogin];
    }
}

@end
