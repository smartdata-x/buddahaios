//
//  AskNetDataApi.h
//  Buddha
//
//  Created by Archer_LJ on 14/11/28.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stdinc.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"

#ifdef DEBUG
#define MAIN_HTTP                                       @"http://112.124.49.59/cgi-bin/buddha"
#else
#define MAIN_HTTP                                       @"http://112.124.49.59/cgi-bin/buddha"
#endif

// 此处定义用于本地与网络间的通信。先定义消息，再将index添加于enum，最后在dataTable中添加Key
// Quick Login
#define MigNetNameQuickLoginSuccess                     @"MigNetNameQuickLoginSuccess"
#define MigNetNameQuickLoginFailed                      @"MigNetNameQuickLoginFailed"

// Baidu Bind Push
#define MigNetNameBDBindPushSuccess                     @"MigNetNameBDBindPushSuccess"
#define MigNetNameBDBindPushFailed                      @"MigNetNameBDBindPushFailed"

// Third part Login
#define MigNetNameThirdLoginSuccess                     @"MigNetNameThirdLoginSuccess"
#define MigNetNameThirdLoginFailed                      @"MigNetNameThirdLoginFailed"

// 获取首页内容
#define MigNetNameGetRecomFailed                        @"MigNetNameGetRecomFailed"
#define MigNetNameGetRecomSuccess                       @"MigNetNameGetRecomSuccess"

// 获取最空闲accesskey
#define MigNetNameGetAKFailed                           @"MigNetNameGetAKFailed"
#define MigNetNameGetAKSuccess                          @"MigNetNameGetAKSuccess"

// 获取周围建筑信息
#define MigNetNameGetNearBuildFailed                    @"MigNetNameGetNearBuildFailed"
#define MigNetNameGetNearBuildSuccess                   @"MigNetNameGetNearBuildSuccess"

// 获取推荐建筑信息
#define MigNetNameGetRecomBuildFailed                   @"MigNetNameGetRecomBuildFailed"
#define MigNetNameGetRecomBuildSuccess                  @"MigNetNameGetRecomBuildSuccess"

// 根据类别搜索
#define MigNetNameSearchTypeBuildFailed                 @"MigNetNameSearchTypeBuildFailed"
#define MigNetNameSearchTypeBuildSuccess                @"MigNetNameSearchTypeBuildSuccess"

// 获取详情
#define MigNetNameGetSummaryFailed                      @"MigNetNameGetSummaryFailed"
#define MigNetNameGetSummarySuccess                     @"MigNetNameGetSummarySuccess"

enum {
    
    MIGAPI_QUICKLOGIN = 0,
    MIGAPI_BDBINDPUSH,
    MIGAPI_THIRDLOGIN,
    MIGAPI_GETRECOM,
    MIGAPI_GETAK,
    MIGAPI_GETNEARBUILD,
    MIGAPI_GETRECOMBUILD,
    MIGAPI_SEARCHTYPEBUILD,
    MIGAPI_GETSUMMARY,
};

@interface AskNetDataApi : NSObject
{
    NSString *mUid;
    NSString *mToken;
}

@property (nonatomic, retain) NSArray *dataTable;

- (BOOL)isUserLogin;
- (void)updateUidandToken;

- (void)doPostData:(NSInteger)index postdata:(NSString *)postData;
- (void)doGetData:(NSInteger)index tail:(NSString *)appendTail;

- (void)doQuickLogin;
- (void)doThirdLogin;
- (void)doGetRecom;
- (void)doGetAK;
- (void)doGetNearBuild;
- (void)doGetRecomBuild;
- (void)doSearchTypeBuild:(NSString *)type;
- (void)doGetSummary:(NSString *)buildid;

@end
