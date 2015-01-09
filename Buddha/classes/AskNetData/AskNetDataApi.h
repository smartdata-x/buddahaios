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

// 获取(建筑)详情
#define MigNetNameGetSummaryFailed                      @"MigNetNameGetSummaryFailed"
#define MigNetNameGetSummarySuccess                     @"MigNetNameGetSummarySuccess"

// 获取书籍详细介绍
#define MigNetNameGetBookSummaryFailed                  @"MigNetNameGetBookSummaryFailed"
#define MigNetNameGetBookSummarySuccess                 @"MigNetNameGetBookSummarySuccess"

// 获取书城首页信息
#define MigNetNameGetBookFailed                         @"MigNetNameGetBookFailed"
#define MigNetNameGetBookSuccess                        @"MigNetNameGetBookSuccess"

// 根据类别获取书籍
#define MigNetNameSearchBookTypeFailed                  @"MigNetNameSearchBookTypeFailed"
#define MigNetNameSearchBookTypeSuccess                 @"MigNetNameSearchBookTypeSuccess"

// 获取书籍章节内容
#define MigNetNameGetChapterListFailed                  @"MigNetNameGetChapterListFailed"
#define MigNetNameGetChapterListSuccess                 @"MigNetNameGetChapterListSuccess"

// 获取书籍token
#define MigNetNameGetBookTokenFailed                    @"MigNetNameGetBookTokenFailed"
#define MigNetNameGetBookTokenSuccess                   @"MigNetNameGetBookTokenSuccess"

// 获取书单
#define MigNetNameGetBookListFailed                     @"MigNetNameGetBookListFailed"
#define MigNetNameGetBookListSuccess                    @"MigNetNameGetBookListSuccess"

// 获取活动
#define MigNetNameGetActivityFailed                     @"MigNetNameGetActivityFailed"
#define MigNetNameGetActivitySuccess                    @"MigNetNameGetActivitySuccess"

// 获取活动详情
#define MigNetNameGetActivitySummaryFailed              @"MigNetNameGetActivitySummaryFailed"
#define MigNetNameGetActivitySummarySuccess             @"MigNetNameGetActivitySummarySuccess"

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
    MIGAPI_GETBOOKSUMMARY,
    MIGAPI_GETBOOK,
    MIGAPI_SEARCHBOOKTYPE,
    MIGAPI_GETCHAPTERLIST,
    MIGAPI_GETBOOKTOKEN,
    MIGAPI_GETBOOKLIST,
    MIGAPI_GETACTIVITY,
    MIGAPI_GETACTIVITYSUMMARY,
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
- (void)doGetBookSummary:(NSString *)bookid;
- (void)doGetBook;
- (void)doSearchBookType:(NSString *)type;
- (void)doGetChapterList:(NSString *)booktoken BookID:(NSString *)bookid;
- (void)doGetBookToken:(NSString *)bookid;
- (void)doGetBookList;
- (void)doGetActivity;
- (void)doGetActivitySummary:(NSString *)aid;

@end
