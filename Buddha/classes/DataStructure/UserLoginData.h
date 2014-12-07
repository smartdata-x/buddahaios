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

@property (nonatomic, retain) NSString *userid; // mig的用户id
@property (nonatomic, retain) NSString *token; // mig的token

@property (nonatomic, retain) NSString *address; // 地址
@property (nonatomic, retain) NSString *birthday; // 生日

@property (nonatomic, retain) NSString *username; // 用户名
@property (nonatomic, retain) NSString *password; // 密码
@property (nonatomic, retain) NSString *thirdtoken; // 第三方token
@property (nonatomic, retain) NSString *thirdIDStr; // 第三方用户id,字符串类型
@property (nonatomic, retain) NSString *devicetoken; // 设备token
@property (nonatomic ,retain) NSDate *expireDate; // 过期时间
@property (nonatomic, retain) NSString *szExpireDate;
@property (nonatomic, retain) NSString *loginType; // 第三方登录类型
@property (nonatomic, retain) NSString *openid; //
@property (nonatomic, retain) NSString *thirdUserId; // 第三方的用户id
@property (nonatomic, retain) NSString *headerUrl; // 第三方的头像地址
@property (nonatomic, retain) NSString *gender; // 第三方性别

@end
