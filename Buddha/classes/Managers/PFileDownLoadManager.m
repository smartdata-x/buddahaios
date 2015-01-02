//
//  PFileDownLoadManager.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/25.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "PFileDownLoadManager.h"

@implementation PFileDownLoadManager

- (void)downloadFromURL:(NSString *)szurl to:(NSString *)fileName indir:(NSString *)subdir{
    
    if (self.isDownloading) {
        
        MIGDEBUG_PRINT(@"正在下载");
        return;
    }
    
    NSURL *url = [NSURL URLWithString:szurl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    self.cnnt = [NSURLConnection connectionWithRequest:request delegate:self];
    self.filename = fileName;
    self.subdir = subdir;
    
    self.isDownloading = YES;
}

// NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    if (self.sumLength) {
        
        return;
    }
    
    // 创建文件存放路径
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *subdir = [cache stringByAppendingPathComponent:self.subdir];
    NSString *filePath = [subdir stringByAppendingPathComponent:self.filename];
    
    // 创建一个空的文件
    NSFileManager *mgr = [NSFileManager defaultManager];
    [mgr createFileAtPath:filePath contents:nil attributes:nil];
    
    // 创建文件句柄
    self.writeHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    self.sumLength = response.expectedContentLength;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    self.curLength += data.length;
    
    // 进度
    double progress = (double)self.curLength / self.sumLength;
    
    [self.writeHandle seekToEndOfFile];
    [self.writeHandle writeData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // 下载完成
    MIGDEBUG_PRINT(@"下载完成");
    [self.writeHandle closeFile];
    self.writeHandle = nil;
    self.curLength = 0;
    self.sumLength = 0;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MigLocalNameDownloadFileSuccess object:nil userInfo:nil];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    MIGDEBUG_PRINT(@"下载出错");
    [[NSNotificationCenter defaultCenter] postNotificationName:MigLocalNameDownloadFileFailed object:nil userInfo:nil];
}

@end
