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

@end
