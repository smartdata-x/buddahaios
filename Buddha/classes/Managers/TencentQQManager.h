//
//  TencentQQManager.h
//  Buddha
//
//  Created by Archer_LJ on 14/11/30.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Stdinc.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface TencentQQManager : NSObject<TencentSessionDelegate>
{
    TencentOAuth *tencentOAuth;
    NSArray *permissions;
}

+ (TencentQQManager *)GetInstance;

- (void)doRegister;

- (BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (BOOL)handleOpenURL:(NSURL *)url;

- (void)doLoginRequest;

@end
