//
//  OpenUrlManager.h
//  Buddha
//
//  Created by Archer_LJ on 14/11/29.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stdinc.h"

@interface OpenUrlManager : NSObject

+ (OpenUrlManager *)GetInstance;

- (BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (BOOL)handleOpenURL:(NSURL *)url;

@end
