//
//  AskNetDataApi.m
//  Buddha
//
//  Created by Archer_LJ on 14/11/28.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "AskNetDataApi.h"

@implementation AskNetDataApi

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        [self initDataTable];
    }
    
    return self;
}

- (void)initDataTable {
    
    NSString *httpQuickLogin = [NSString stringWithFormat:@"%@quicklogin.fcgi", MAIN_HTTP];
    NSString *httpBDBindPush = [NSString stringWithFormat:@"%@bdbindpush.fcgi", MAIN_HTTP];
    
    self.dataTable = @[
                       @{KEY_NET_ADDRESS:httpQuickLogin,
                         KEY_NET_SUCCESS:MigNetNameQuickLoginSuccess,
                         KEY_NET_FAILED:MigNetNameQuickLoginFailed},
                       
                       @{KEY_NET_ADDRESS:httpBDBindPush,
                         KEY_NET_SUCCESS:MigNetNameBDBindPushSuccess,
                         KEY_NET_FAILED:MigNetNameQuickLoginFailed},
                       
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
    
    NSString *postData = [NSString stringWithFormat:@"imei=%@&machine=%@&latitude=%@&longitude=%@", @"", @"", @"", @""];
    
    [self doPostData:MIGAPI_QUICKLOGIN postdata:postData];
}

@end
