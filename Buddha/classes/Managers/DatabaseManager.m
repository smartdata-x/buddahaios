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
        
#if MIG_DEBUG_TEST
#if 0
        // test
        // 删除USERLOGINDATA
        BOOL isOK = [_db executeUpdate:@"drop table BOOKSHELFINFO"];
        if (!isOK) {
            
            MIGDEBUG_PRINT(@"%@", [_db lastErrorMessage]);
        }
#endif
#endif
        
        // 用户账户信息
        [_db executeUpdate:@"create table if not exists USERLOGINDATA (userid text, accesstoken text, address text, birthday text, username text, password text, thirdtoken text, thirdid text, openid text, logintype text, headurl text, logintime integer)"];
        
        // 用户登录状态
        [_db executeUpdate:@"create table if not exists USERLASTLOGIN (loginstate text)"];
        
        // 个人书架信息
        [_db executeUpdate:@"create table if not exists BOOKSHELFINFO (name text, id text, type text, imageurl text, freeurl text, fullurl text)"];
        
        [_db close];
    }
    
    return self;
}

- (void)initDataInfo {
    
    
}

- (void)insertUserLoginData:(UserLoginData *)userlogindata {
    
    // userid text, token text, address text, birthday text, username text, password text, thirdtoken text, thirdid text, openid text, logintype text, headurl text, logintime integer
    
    NSString *userid = userlogindata.userid;
    NSString *token = userlogindata.token;
    NSString *address = userlogindata.address;
    NSString *birthday = userlogindata.birthday;
    NSString *username = userlogindata.username;
    NSString *encodePassword = [PCommonUtil encodeAesAndBase64StrFromStr:userlogindata.password];
    NSString *thirdtoken = userlogindata.thirdtoken;
    NSString *thirdid = userlogindata.thirdIDStr;
    NSString *openid = userlogindata.openid;
    NSString *logintype = userlogindata.loginType;
    NSString *headurl = userlogindata.headerUrl;
    NSDate *nowDate = [NSDate date];
    long loginTime = [nowDate timeIntervalSince1970];
    NSNumber *numLoginTime = [NSNumber numberWithLong:loginTime];
    
    NSString *sql = @"insert into USERLOGINDATA (userid, accesstoken, address, birthday, password, thirdtoken, thirdid, openid, logintype, headurl, logintime, username) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
    MIGDEBUG_PRINT(@"userid = %@, accesstoken = %@, address = %@, birthday = %@, password = %@, thirdtoken = %@, thirdid = %@, openid = %@, logintype = %@, headurl = %@, logintime = %@ where username = %@", userid, token, address, birthday, encodePassword, thirdtoken, thirdid, openid, logintype, headurl, numLoginTime, username);
    
    [_db open];
    
    NSString *checksql = [NSString stringWithFormat:@"select username from USERLOGINDATA where username = '%@' ", username];
    
    FMResultSet *rs = [_db executeQuery:checksql];
    while ([rs next]) {
        
        sql = @"update USERLOGINDATA set userid = ?, accesstoken = ?, address = ?, birthday = ?, password = ?, thirdtoken = ?, thirdid = ?, openid = ?, logintype = ?, headurl = ?, logintime = ? where username = ?";
        break;
    }
    
    BOOL isOK = [_db executeUpdate:sql, userid, token, address, birthday, encodePassword, thirdtoken, thirdid, openid, logintype, headurl, numLoginTime, username];
    
    if (!isOK) {
        
        MIGDEBUG_PRINT(@"%@", [_db lastErrorMessage]);
        MIGDEBUG_PRINT(@"数据库记录用户信息失败");
    }
    
    [_db close];
}

- (UserLoginData *)getLastUserLoginData {
    
    UserLoginData *userdata = nil;
    
    NSString *sql = @"select username, password, userid, accesstoken, logintype from USERLOGINDATA order by logintime desc";
    
    [_db open];
    
    FMResultSet *rs = [_db executeQuery:sql];
    while ([rs next]) {
        
        userdata = [[UserLoginData alloc] init];
        
        userdata.userid = [rs stringForColumn:@"userid"];
        userdata.token = [rs stringForColumn:@"accesstoken"];
        userdata.address = [rs stringForColumn:@"address"];
        userdata.birthday = [rs stringForColumn:@"birthday"];
        userdata.username = [rs stringForColumn:@"username"];
        userdata.password = [rs stringForColumn:@"password"];
        userdata.thirdtoken = [rs stringForColumn:@"thirdtoken"];
        userdata.thirdIDStr = [rs stringForColumn:@"thirdid"];
        userdata.openid = [rs stringForColumn:@"openid"];
        userdata.loginType = [rs stringForColumn:@"logintype"];
        userdata.headerUrl = [rs stringForColumn:@"headurl"];
        
        break;
    }
    
    [_db close];
    
    return userdata;
}

- (void)insertLoginOrNot:(int)isLogin {
    
    // "create table if not exists USERLASTLOGIN (loginstate text)
    
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
        
        MIGDEBUG_PRINT(@"数据库记录用户登录信息 成功");
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

- (void)insertBookInfo:(migsBookDetailInformation *)bookinfo {
    
    // BOOKSHELFINFO (name text, id text, type text, imageurl text, freeurl text, fullurl text)
    
    NSString *name = bookinfo.bookname;
    NSString *bookid = bookinfo.bookid;
    NSString *type = bookinfo.booktype;
    NSString *imageurl = bookinfo.imgURL;
    NSString *freeurl = bookinfo.freeContentUrl;
    NSString *fullurl = bookinfo.fullContentUrl;
    
    NSString *sql = @"insert into BOOKSHELFINFO (id, type, imageurl, freeurl, fullurl, name) values (?, ?, ?, ?, ?, ?)";
    NSString *checksql = [NSString stringWithFormat:@"select name from BOOKSHELFINFO where name = '%@' ", name];
    
    MIGDEBUG_PRINT(@"name=%@, id=%@, type=%@, url=%@, free:%@, full:%@", name, bookid, type, imageurl, freeurl, fullurl);
    
    [_db open];
    
    FMResultSet *rs = [_db executeQuery:checksql];
    while ([rs next]) {
        
        sql = @"update BOOKSHELFINFO set id = ?, type = ?, imageurl = ?, freeurl = ?, fullurl = ? where name = ?";
        break;
    }
    
    if ([_db executeUpdate:sql, bookid, type, imageurl, freeurl, fullurl, name]) {
        
        MIGDEBUG_PRINT(@"数据库记录书架信息 成功");
    }
    else {
        
        MIGDEBUG_PRINT(@"%@", [_db lastErrorMessage]);
    }
    
    [_db close];
}

- (NSArray *)getAllBookInfo {
    
    NSMutableArray *retArray = [[NSMutableArray alloc] init];
    
    NSString *sql = @"select * from BOOKSHELFINFO";
    
    [_db open];
    
    FMResultSet *rs = [_db executeQuery:sql];
    while ([rs next]) {
        
        migsBookDetailInformation *detailinfo = [[migsBookDetailInformation alloc] init];
        
        NSString *name = [rs stringForColumn:@"name"];
        NSString *bookid = [rs stringForColumn:@"id"];
        NSString *type = [rs stringForColumn:@"type"];
        NSString *imageurl = [rs stringForColumn:@"imageurl"];
        NSString *freeurl = [rs stringForColumn:@"freeurl"];
        NSString *fullurl = [rs stringForColumn:@"fullurl"];
        
        detailinfo.bookname = name;
        detailinfo.bookid = bookid;
        detailinfo.booktype = type;
        detailinfo.imgURL = imageurl;
        detailinfo.freeContentUrl = freeurl;
        detailinfo.fullContentUrl = fullurl;
        
        [retArray addObject:detailinfo];
    }
    
    return retArray;
}

@end
