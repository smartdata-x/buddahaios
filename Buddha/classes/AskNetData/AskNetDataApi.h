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
#define MAIN_HTTP                                       @"http://112.124.49.59/cgi-bin/buddha/user/1/"
#else
#define MAIN_HTTP                                       @"http://112.124.49.59/cgi-bin/buddha/user/1/"
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

enum {
    
    MIGAPI_QUICKLOGIN = 0,
    MIGAPI_BDBINDPUSH,
    MIGAPI_THIRDLOGIN,
};

@interface AskNetDataApi : NSObject

@property (nonatomic, retain) NSArray *dataTable;

- (void)doPostData:(NSInteger)index postdata:(NSString *)postData;
- (void)doGetData:(NSInteger)index tail:(NSString *)appendTail;

- (void)doQuickLogin;
- (void)doThirdLogin;

@end
