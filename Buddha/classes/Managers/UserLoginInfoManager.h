//
//  UserLoginInfoManager.h
//  Buddha
//
//  Created by Archer_LJ on 14/11/30.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stdinc.h"

@interface UserLoginInfoManager : NSObject

+ (UserLoginInfoManager *)GetInstance;

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, retain) UserLoginData *curLoginUser;

@end
