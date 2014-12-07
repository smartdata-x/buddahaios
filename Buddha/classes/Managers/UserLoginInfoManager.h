//
//  UserLoginInfoManager.h
//  Buddha
//
//  Created by Archer_LJ on 14/11/30.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stdinc.h"
#import "OpenUDID.h"

@interface UserLoginInfoManager : NSObject

+ (UserLoginInfoManager *)GetInstance;

@property (nonatomic, assign) BOOL isLogin; // 用户是否登录
@property (nonatomic, assign) BOOL isQuickLogin; // 用户是否快速登录
@property (nonatomic, retain) UserLoginData *curLoginUser;
@property (nonatomic, retain) NSString *openUDID;

@end
