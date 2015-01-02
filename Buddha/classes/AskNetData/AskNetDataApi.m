//
//  AskNetDataApi.m
//  Buddha
//
//  Created by Archer_LJ on 14/11/28.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "AskNetDataApi.h"
#import "MyLocationManager.h"
#import "UserLoginInfoManager.h"

@implementation AskNetDataApi

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        [self initDataTable];
    }
    
    return self;
}

- (BOOL)isUserLogin {
    
    BOOL isLogin = ([UserLoginInfoManager GetInstance].isLogin || [UserLoginInfoManager GetInstance].isQuickLogin);
    
    if (isLogin) {
        
        [self updateUidandToken];
    }
    
    return isLogin;
}

- (void)updateUidandToken {
    
    mUid = [UserLoginInfoManager GetInstance].curLoginUser.userid;
    mToken = [UserLoginInfoManager GetInstance].curLoginUser.token;
}

- (void)initDataTable {
    
    NSString *httpQuickLogin = [NSString stringWithFormat:@"%@/user/1/quicklogin.fcgi", MAIN_HTTP];
    NSString *httpBDBindPush = [NSString stringWithFormat:@"%@/user/1/bdbindpush.fcgi", MAIN_HTTP];
    NSString *httpThirdLogin = [NSString stringWithFormat:@"%@/user/1/thirdlogin.fcgi", MAIN_HTTP];
    NSString *httpGetRecom = [NSString stringWithFormat:@"%@/find/1/broad.fcgi", MAIN_HTTP];
    NSString *httpGetAK = [NSString stringWithFormat:@"%@/map/1/getak.fcgi", MAIN_HTTP];
    NSString *httpGetNearBuild = [NSString stringWithFormat:@"%@/build/1/nearbuild.fcgi", MAIN_HTTP];
    NSString *httpGetRecomBuild = [NSString stringWithFormat:@"%@/find/1/building.fcgi", MAIN_HTTP];
    NSString *httpSearchTypeBuild = [NSString stringWithFormat:@"%@/build/1/searchtype.fcgi", MAIN_HTTP];
    NSString *httpGetSummary = [NSString stringWithFormat:@"%@/build/1/summary.fcgi", MAIN_HTTP];
    NSString *httpGetBookSummary = [NSString stringWithFormat:@"%@/book/1/booksummary.fcgi", MAIN_HTTP];
    NSString *httpGetBook = [NSString stringWithFormat:@"%@/find/1/book.fcgi", MAIN_HTTP];
    NSString *httpSearchBookType = [NSString stringWithFormat:@"%@/book/1/searchtype.fcgi", MAIN_HTTP];
    NSString *httpGetChapterList = [NSString stringWithFormat:@"%@/book/1/chapterlist.fcgi", MAIN_HTTP];
    NSString *httpGetBookToken = [NSString stringWithFormat:@"%@/book/1/wantgetbook.fcgi", MAIN_HTTP];
    NSString *httpGetBookList = [NSString stringWithFormat:@"%@/book/1/booklist.fcgi", MAIN_HTTP];
    
    self.dataTable = @[
                       @{KEY_NET_ADDRESS:httpQuickLogin,
                         KEY_NET_SUCCESS:MigNetNameQuickLoginSuccess,
                         KEY_NET_FAILED:MigNetNameQuickLoginFailed},
                       
                       @{KEY_NET_ADDRESS:httpBDBindPush,
                         KEY_NET_SUCCESS:MigNetNameBDBindPushSuccess,
                         KEY_NET_FAILED:MigNetNameQuickLoginFailed},
                       
                       @{KEY_NET_ADDRESS:httpThirdLogin,
                         KEY_NET_SUCCESS:MigNetNameThirdLoginSuccess,
                         KEY_NET_FAILED:MigNetNameThirdLoginFailed},
                       
                       @{KEY_NET_ADDRESS:httpGetRecom,
                         KEY_NET_FAILED:MigNetNameGetRecomFailed,
                         KEY_NET_SUCCESS:MigNetNameGetRecomSuccess},
                       
                       @{KEY_NET_ADDRESS:httpGetAK,
                         KEY_NET_FAILED:MigNetNameGetAKFailed,
                         KEY_NET_SUCCESS:MigNetNameGetAKSuccess},
                       
                       @{KEY_NET_ADDRESS:httpGetNearBuild,
                         KEY_NET_FAILED:MigNetNameGetNearBuildFailed,
                         KEY_NET_SUCCESS:MigNetNameGetNearBuildSuccess},
                       
                       @{KEY_NET_ADDRESS:httpGetRecomBuild,
                         KEY_NET_FAILED:MigNetNameGetRecomBuildFailed,
                         KEY_NET_SUCCESS:MigNetNameGetRecomBuildSuccess},
                       
                       @{KEY_NET_ADDRESS:httpSearchTypeBuild,
                         KEY_NET_FAILED:MigNetNameSearchTypeBuildFailed,
                         KEY_NET_SUCCESS:MigNetNameSearchTypeBuildSuccess},
                       
                       @{KEY_NET_ADDRESS:httpGetSummary,
                         KEY_NET_FAILED:MigNetNameGetSummaryFailed,
                         KEY_NET_SUCCESS:MigNetNameGetSummarySuccess},
                       
                       @{KEY_NET_ADDRESS:httpGetBookSummary,
                         KEY_NET_FAILED:MigNetNameGetBookSummaryFailed,
                         KEY_NET_SUCCESS:MigNetNameGetBookSummarySuccess},
                       
                       @{KEY_NET_ADDRESS:httpGetBook,
                         KEY_NET_FAILED:MigNetNameGetBookFailed,
                         KEY_NET_SUCCESS:MigNetNameGetBookSuccess},
                       
                       @{KEY_NET_ADDRESS:httpSearchBookType,
                         KEY_NET_FAILED:MigNetNameSearchBookTypeFailed,
                         KEY_NET_SUCCESS:MigNetNameSearchBookTypeSuccess},
                       
                       @{KEY_NET_ADDRESS:httpGetChapterList,
                         KEY_NET_FAILED:MigNetNameGetChapterListFailed,
                         KEY_NET_SUCCESS:MigNetNameGetChapterListSuccess},
                       
                       @{KEY_NET_ADDRESS:httpGetBookToken,
                         KEY_NET_FAILED:MigNetNameGetBookTokenFailed,
                         KEY_NET_SUCCESS:MigNetNameGetBookTokenSuccess},
                       
                       @{KEY_NET_ADDRESS:httpGetBookList,
                         KEY_NET_FAILED:MigNetNameGetBookListFailed,
                         KEY_NET_SUCCESS:MigNetNameGetBookListSuccess},
                       ];
}

- (void)doPostData:(NSInteger)index postdata:(NSString *)postData {
    
    NSDictionary *infoData = [self.dataTable objectAtIndex:index];
    
    NSString *url = [infoData objectForKey:KEY_NET_ADDRESS];
    NSString *successName = [infoData objectForKey:KEY_NET_SUCCESS];
    NSString *failedName = [infoData objectForKey:KEY_NET_FAILED];
    
    MIGDEBUG_PRINT(@"post request url: %@, data: %@", url, postData);
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            int resultStatus = [[dicJson objectForKey:@"status"] intValue];
            
            if (1 == resultStatus) {
                
                MIGDEBUG_PRINT(@"url:%@ request success", url);
                
                NSDictionary *returnResult = [dicJson objectForKey:@"result"];
                NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:returnResult, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:successName object:nil userInfo:dicResult];
            }
            else {
                
                MIGDEBUG_PRINT(@"url:%@ request failed", url);
                
                NSString *msg = [dicJson objectForKey:@"msg"];
                NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:failedName object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            MIGDEBUG_PRINT(@"url:%@ 解析返回数据失败", url);
            [[NSNotificationCenter defaultCenter] postNotificationName:failedName object:nil userInfo:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        MIGDEBUG_PRINT(@"url:%@ request failed, error: %@", url, error);
        [[NSNotificationCenter defaultCenter] postNotificationName:failedName object:nil userInfo:nil];
    }];
    
    [operation start];
}

- (void)doGetData:(NSInteger)index tail:(NSString *)appendTail {
    
    NSDictionary *infoData = [self.dataTable objectAtIndex:index];
    
    NSString *url = [infoData objectForKey:KEY_NET_ADDRESS];
    NSString *successName = [infoData objectForKey:KEY_NET_SUCCESS];
    NSString *failedName = [infoData objectForKey:KEY_NET_FAILED];

    NSString *askUrl = [NSString stringWithFormat:@"%@?%@", url, appendTail];
    
    MIGDEBUG_PRINT(@"get request url: %@", askUrl);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:askUrl]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            int resultStatus = [[dicJson objectForKey:@"status"] intValue];
            
            if (1 == resultStatus) {
                
                MIGDEBUG_PRINT(@"url:%@ request success", url);
                
                NSDictionary *returnResult = [dicJson objectForKey:@"result"];
                NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:returnResult, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:successName object:nil userInfo:dicResult];
            }
            else {
                
                MIGDEBUG_PRINT(@"url:%@ request failed", url);
                
                NSString *msg = [dicJson objectForKey:@"msg"];
                NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:failedName object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            MIGDEBUG_PRINT(@"url:%@ 解析返回数据失败", url);
            [[NSNotificationCenter defaultCenter] postNotificationName:failedName object:nil userInfo:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        MIGDEBUG_PRINT(@"url:%@ request failed, error: %@", url, error);
        [[NSNotificationCenter defaultCenter] postNotificationName:failedName object:nil userInfo:nil];
    }];
    
    [operation start];
}

- (void)doQuickLogin {
    
    NSString *latitude = [[MyLocationManager GetInstance] getLatitude];
    NSString *longitude = [[MyLocationManager GetInstance] getLongitude];
    NSString *imei = [UserLoginInfoManager GetInstance].openUDID;
    
    NSString *postData = [NSString stringWithFormat:@"imei=%@&machine=%@&latitude=%@&longitude=%@", imei, @"2", latitude, longitude];
    
    [self doPostData:MIGAPI_QUICKLOGIN postdata:postData];
}

- (void)doThirdLogin {
    
    NSString *machine = @"2";
    NSString *nickname = [UserLoginInfoManager GetInstance].curLoginUser.username;
    NSString *source = [UserLoginInfoManager GetInstance].curLoginUser.loginType;
    NSString *session = [UserLoginInfoManager GetInstance].curLoginUser.thirdIDStr;
    NSString *imei = [UserLoginInfoManager GetInstance].openUDID;
    NSString *sex = [UserLoginInfoManager GetInstance].curLoginUser.gender;
    NSString *birthday = [UserLoginInfoManager GetInstance].curLoginUser.birthday;
    NSString *location = [UserLoginInfoManager GetInstance].curLoginUser.address;
    NSString *head = [UserLoginInfoManager GetInstance].curLoginUser.headerUrl;
    NSString *latitude = [[MyLocationManager GetInstance] getLatitude];
    NSString *longitude = [[MyLocationManager GetInstance] getLongitude];
    
    // 如下几个字符需要转码
    NSString *urlcodeNickname = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)nickname, nil, nil, kCFStringEncodingUTF8));
    NSString *urlcodeLocation = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)location, nil, nil, kCFStringEncodingUTF8));
    NSString *urlcodeHeadUrl = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)head, nil, nil, kCFStringEncodingUTF8));
    
    NSMutableString *postData = [[NSMutableString alloc] initWithFormat:@"machine=%@&nickname=%@&source=%@&session=%@&sex=%@&head=%@&latitude=%@&longitude=%@", machine, urlcodeNickname, source, session, sex, urlcodeHeadUrl, latitude, longitude];
    
    if (!MIG_IS_EMPTY_STRING(birthday)) {
        
        NSString *postBirth = [NSString stringWithFormat:@"&birthday=%@", birthday];
        [postData appendString:postBirth];
    }
    
    if (!MIG_IS_EMPTY_STRING(location)) {
        
        NSString *postLocation = [NSString stringWithFormat:@"&location=%@", urlcodeLocation];
        [postData appendString:postLocation];
    }
    
    // 如果用户之前有快速登录过，则传imei值
    if ([UserLoginInfoManager GetInstance].isQuickLogin) {
        
        NSString *postImei = [NSString stringWithFormat:@"&imei=%@", imei];
        [postData appendString:postImei];
    }
    
    [self doPostData:MIGAPI_THIRDLOGIN postdata:postData];
}

- (void)doGetRecom {
    
    if ([UserLoginInfoManager GetInstance].isLogin ||
        [UserLoginInfoManager GetInstance].isQuickLogin) {
        
        NSString *uid = [UserLoginInfoManager GetInstance].curLoginUser.userid;
        NSString *token = [UserLoginInfoManager GetInstance].curLoginUser.token;
        
        NSString *postData = [NSString stringWithFormat:@"uid=%@&token=%@", uid, token];
        [self doPostData:MIGAPI_GETRECOM postdata:postData];
    }
}

- (void)doGetAK {
    
    
}

- (void)doGetNearBuild {
    
    if ([self isUserLogin]) {
        
        NSString *getData = [NSString stringWithFormat:@"uid=%@&token=%@&latitude=%@&longitude=%@", mUid, mToken, [[MyLocationManager GetInstance] getLatitude], [[MyLocationManager GetInstance] getLongitude]];
        
        [self doGetData:MIGAPI_GETNEARBUILD tail:getData];
    }
}

- (void)doGetRecomBuild {
    
    if ([self isUserLogin]) {
        
        NSString *getData = [NSString stringWithFormat:@"uid=%@&token=%@&latitude=%@&longitude=%@", mUid, mToken, [[MyLocationManager GetInstance] getLatitude], [[MyLocationManager GetInstance] getLongitude]];
        
        [self doGetData:MIGAPI_GETRECOMBUILD tail:getData];
    }
}

- (void)doSearchTypeBuild:(NSString *)type {
    
    if ([self isUserLogin]) {
        
        NSString *getData = [NSString stringWithFormat:@"uid=%@&token=%@&latitude=%@&longitude=%@&btype=%@", mUid, mToken, [[MyLocationManager GetInstance] getLatitude], [[MyLocationManager GetInstance] getLongitude], type];
        
        [self doGetData:MIGAPI_SEARCHTYPEBUILD tail:getData];
    }
}

- (void)doGetSummary:(NSString *)buildid {
    
    if ([self isUserLogin]) {
        
        NSString *getData = [NSString stringWithFormat:@"uid=%@&token=%@&bid=%@&latitude=%@&longitude=%@", mUid, mToken, buildid, [[MyLocationManager GetInstance] getLatitude], [[MyLocationManager GetInstance] getLongitude]];
        
        [self doGetData:MIGAPI_GETSUMMARY tail:getData];
    }
}

- (void)doGetBookSummary:(NSString *)bookid {
    
    if ([self isUserLogin]) {
        
        NSString *getData = [NSString stringWithFormat:@"uid=%@&token=%@&bookid=%@&latitude=%@&longitude=%@", mUid, mToken, bookid, [[MyLocationManager GetInstance] getLatitude], [[MyLocationManager GetInstance] getLongitude]];
        
        [self doGetData:MIGAPI_GETBOOKSUMMARY tail:getData];
    }
}

- (void)doGetBook {
    
    if ([self isUserLogin]) {
        
        NSString *getData = [NSString stringWithFormat:@"uid=%@&token=%@&latitude=%@&longitude=%@", mUid, mToken, [[MyLocationManager GetInstance] getLatitude], [[MyLocationManager GetInstance] getLongitude]];
        
        [self doGetData:MIGAPI_GETBOOK tail:getData];
    }
}

- (void)doSearchBookType:(NSString *)type {
    
    if ([self isUserLogin]) {
        
        NSString *getData = [NSString stringWithFormat:@"uid=%@&token=%@&btype=%@&latitude=%@&longitude=%@", mUid, mToken, type, [[MyLocationManager GetInstance] getLatitude], [[MyLocationManager GetInstance] getLongitude]];
        
        [self doGetData:MIGAPI_SEARCHBOOKTYPE tail:getData];
    }
}

- (void)doGetChapterList:(NSString *)booktoken BookID:(NSString *)bookid {
    
    if ([self isUserLogin]) {
        
        NSString *getData = [NSString stringWithFormat:@"uid=%@&token=%@&booktoken=%@&bookid=%@", mUid, mToken, booktoken, bookid];
        
        [self doGetData:MIGAPI_GETCHAPTERLIST tail:getData];
    }
}

- (void)doGetBookToken:(NSString *)bookid {
    
    if ([self isUserLogin]) {
        
        NSString *getData = [NSString stringWithFormat:@"uid=%@&token=%@&bookid=%@", mUid, mToken, bookid];
        
        [self doGetData:MIGAPI_GETBOOKTOKEN tail:getData];
    }
}

- (void)doGetBookList {
    
    if ([self isUserLogin]) {
        
        NSString *getData = [NSString stringWithFormat:@"uid=%@&token=%@", mUid, mToken];
        
        [self doGetData:MIGAPI_GETBOOKLIST tail:getData];
    }
}

@end
