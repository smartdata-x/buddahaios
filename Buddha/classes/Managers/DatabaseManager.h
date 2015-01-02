//
//  DatabaseManager.h
//  Buddha
//
//  Created by Archer_LJ on 14/11/26.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stdinc.h"
#import "PFileManager.h"
#import "FMDatabase.h"
#import "UserLoginData.h"
#import "PCommonUtil.h"
#import "BookDetailViewController.h"

@interface DatabaseManager : PFileManager

@property (nonatomic, retain) FMDatabase *db;

+ (DatabaseManager *)GetInstance;

// 记录和获取账号信息
- (void)insertUserLoginData:(UserLoginData *)userlogindata;
- (UserLoginData *)getLastUserLoginData;

// 记录是否登陆
- (void)insertLoginOrNot:(int)isLogin;
- (int)getLastLoginOrNot;

// 记录书架信息
- (void)removeAllBooks;
- (void)insertBookInfo:(migsBookDetailInformation *)bookinfo;
- (NSArray *)getAllBookInfo;

@end
