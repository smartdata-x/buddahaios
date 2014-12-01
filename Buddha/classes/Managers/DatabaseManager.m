//
//  DatabaseManager.m
//  Buddha
//
//  Created by Archer_LJ on 14/11/26.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "DatabaseManager.h"

@implementation DatabaseManager

+ (DatabaseManager *)GetInstance {
    
    static DatabaseManager *instance = nil;
    
    @synchronized(self) {
        
        if (nil == instance) {
            
            instance = [[DatabaseManager alloc] init];
            [instance initDataInfo];
        }
    }
    
    return instance;
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        NSString *cacheHomeDir = [self getCacheHomeDirectory];
        NSString *dbPath = [cacheHomeDir stringByAppendingPathComponent:@"20141129archer.sqlite"];
        
        _db = [FMDatabase databaseWithPath:dbPath];
        
        // 创建数据库
        [_db open];
        
        // 用户账户信息
        [_db executeUpdate:@"create table if not exists USERLOGINDATA (username text not null, password text, userid text, accesstoken text, logintype text, logintime integer)"];
        
        // 用户登录状态
        [_db executeUpdate:@"create table if not exists USERLASTLOGIN (loginstate text)"];
        
        [_db close];
    }
    
    return self;
}

- (void)initDataInfo {
    
    
}

- (void)insertUserLoginData:(UserLoginData *)userlogindata {
    
    NSString *encodePassword = [PCommonUtil encodeAesAndBase64StrFromStr:userlogindata.password];
    NSDate *nowDate = [NSDate date];
    long loginTime = [nowDate timeIntervalSince1970];
    
    NSString *sql = @"insert into USERLOGINDATA (username, password, userid, accesstoken, logintime) values (?, ?, ?, ?, ?, ?)";
    
    [_db open];
    
    
    [_db close];
}

- (void)insertLoginOrNot:(int)isLogin {
    
    NSString *sql = @"insert into USERLASTLOGIN (loginstate) values (?)";
    NSString *checksql = @"select * from USERLASTLOGIN";
    NSNumber *state = [NSNumber numberWithInt:isLogin];
    
    [_db open];
    
    FMResultSet *rs = [_db executeQuery:checksql];
    while ([rs next]) {
        
        sql = @"update USERLASTLOGIN set loginstate = ?";
        break;
    }
    
    if ([_db executeUpdate:sql, state]) {
        
        MIGDEBUG_PRINT(@"记录用户登录信息 成功");
    }
    
    [_db close];
}

- (int)getLastLoginOrNot {
    
    int state = 0;
    NSString *sql = @"select * from USERLASTLOGIN";
    
    [_db open];
    
    FMResultSet *rs = [_db executeQuery:sql];
    while ([rs next]) {
        
        state = [rs intForColumn:@"loginstate"];
        break;
    }
    
    [_db close];
    
    return state;
}

@end
