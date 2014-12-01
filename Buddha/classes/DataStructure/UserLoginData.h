//
//  UserLoginData.h
//  Buddha
//
//  Created by Archer_LJ on 14/11/29.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stdinc.h"

@interface UserLoginData : NSObject

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *userid;
@property (nonatomic, retain) NSString *accesstoken;
@property (nonatomic, retain) NSString *devicetoken;
@property (nonatomic ,retain) NSDate *expireDate;
@property (nonatomic, retain) NSString *szExpireDate;
@property (nonatomic, retain) NSString *loginType;
@property (nonatomic, retain) NSString *openid;

@end
