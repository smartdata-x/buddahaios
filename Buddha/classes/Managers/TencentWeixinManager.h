//
//  TencentWeixinManager.h
//  Buddha
//
//  Created by Archer_LJ on 14/11/30.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stdinc.h"
#import "WXApi.h"
#import "WXApiObject.h"

@interface TencentWeixinManager : NSObject<WXApiDelegate>
{
    NSString *wxCode;
    NSString *accesstoken;
    NSString *openid;
    NSString *nickname;
    NSString *headerimageurl;
}

+ (TencentWeixinManager *)GetInstance;

- (void)doRegister;

- (BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (BOOL)handleOpenURL:(NSURL *)url;

- (void)doLoginRequest;

@end
