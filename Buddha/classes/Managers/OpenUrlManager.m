//
//  OpenUrlManager.m
//  Buddha
//
//  Created by Archer_LJ on 14/11/29.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "OpenUrlManager.h"
#import "SinaWeiboManager.h"
#import "TencentWeixinManager.h"
#import "TencentQQManager.h"

@implementation OpenUrlManager

+ (OpenUrlManager *)GetInstance {
    
    static OpenUrlManager *instance = nil;
    
    @synchronized(self) {
        
        if (nil == instance) {
            
            instance = [[OpenUrlManager alloc] init];
        }
    }
    
    return instance;
}

- (BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return ([[SinaWeiboManager GetInstance] openURL:url sourceApplication:sourceApplication annotation:annotation]) ||
    ([[TencentWeixinManager GetInstance] openURL:url sourceApplication:sourceApplication annotation:annotation]) ||
    ([[TencentQQManager GetInstance] openURL:url sourceApplication:sourceApplication annotation:annotation]);
}

- (BOOL)handleOpenURL:(NSURL *)url {
    
    return [[SinaWeiboManager GetInstance] handleOpenURL:url] ||
    [[TencentWeixinManager GetInstance] handleOpenURL:url] ||
    [[TencentQQManager GetInstance] handleOpenURL:url];
}

@end
