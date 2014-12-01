//
//  TencentWeixinManager.m
//  Buddha
//
//  Created by Archer_LJ on 14/11/30.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "TencentWeixinManager.h"

@implementation TencentWeixinManager

+ (TencentWeixinManager *)GetInstance {
    
    static TencentWeixinManager *instance = nil;
    
    @synchronized(self) {
        
        if (nil == instance) {
            
            instance = [[TencentWeixinManager alloc] init];
        }
    }
    
    return instance;
}

- (void)doRegister {
    
    [WXApi registerApp:kWXAPP_ID withDescription:@"weixin"];
}

- (BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)doLoginRequest {
    
    if (![WXApi isWXAppInstalled]) {
        
        [SVProgressHUD showErrorWithStatus:@"请先安装微信"];
        return;
    }
    
    [self sendAuthRequest];
}

- (void)sendAuthRequest {
    
    // 请求code
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo"; // 要求用户信息
    req.state = @"0823"; // 可以设置为简单的参数
    [WXApi sendReq:req];
}

- (void)getAccess_token {
    
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", kWXAPP_ID, kWXAPP_SECRET, wxCode];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                accesstoken = [dic objectForKey:@"access_token"];
                openid = [dic objectForKey:@"openid"];
            }
        });
    });
}

- (void)getUserInfo {
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", accesstoken, openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 city = Haidian;
                 country = CN;
                 headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
                 language = "zh_CN";
                 nickname = "xxx";
                 openid = oyAaTjsDx7pl4xxxxxxx;
                 privilege =     (
                 );
                 province = Beijing;
                 sex = 1;
                 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
                 }
                 */
                
                nickname = [dic objectForKey:@"nickname"];
                headerimageurl = [dic objectForKey:@"headimgurl"];
            }
        });
        
    });
}

// WXAPI Delegate

- (void)onResp:(BaseResp *)resp {
    
    /*
     ErrCode	ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code	用户换取access_token的code，仅在ErrCode为0时有效
     state	第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang	微信客户端当前语言
     country	微信用户当前国家信息
     */
    
    SendAuthResp *saresp = (SendAuthResp *)resp;
    if (saresp.errCode == 0 && [saresp.state isEqualToString:@"0823"]) {
        
        wxCode = saresp.code;
        if (wxCode && ![wxCode isEqualToString:@""]) {
            
            [self getAccess_token];
        }
    }
}

@end
