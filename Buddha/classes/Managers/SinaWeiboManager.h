//
//  SinaWeiboManager.h
//  Buddha
//
//  Created by Archer_LJ on 14/11/29.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Stdinc.h"
#import "WeiboSDK.h"

@interface SinaWeiboManager : NSObject<WeiboSDKDelegate>

+ (SinaWeiboManager *)GetInstance;

- (BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (BOOL)handleOpenURL:(NSURL *)url;

- (void)doRegister;
- (void)doLoginRequest;

@end
