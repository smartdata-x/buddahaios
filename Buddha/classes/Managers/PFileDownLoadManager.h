//
//  PFileDownLoadManager.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/25.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stdinc.h"
#import "PFileManager.h"

@interface PFileDownLoadManager : PFileManager<NSURLConnectionDataDelegate>

@property (nonatomic, retain) NSMutableData *fileData; // 文件数据
@property (nonatomic, retain) NSFileHandle *writeHandle; // 文件句柄
@property (nonatomic, assign) long long curLength;
@property (nonatomic, assign) long long sumLength;
@property (nonatomic, assign) BOOL isDownloading;
@property (nonatomic, retain) NSURLConnection *cnnt;

@property (nonatomic, retain) NSString *filename;

- (void)downloadFromURL:(NSString *)szurl to:(NSString *)fileName;

@end
