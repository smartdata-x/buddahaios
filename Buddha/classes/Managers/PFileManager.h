//
//  PFileManager.h
//  Buddha
//
//  Created by Archer_LJ on 14/11/29.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFileManager : NSObject

- (NSString *)getCacheHomeDirectory;
- (NSString *)createPath:(NSString *)path;
- (long long)getLocalFileSize:(NSString *)filepath;

// 计算文件夹总大小
- (long long)getFileSizeForDir:(NSString *)dir;

// Document目录下，文件是否存在
- (BOOL)isFileExistInDocument:(NSString *)filename;

// Document目录的文件路径
- (NSString *)getFullPathFromDocument:(NSString *)filename;

@end
