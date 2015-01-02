//
//  PFileManager.m
//  Buddha
//
//  Created by Archer_LJ on 14/11/29.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "PFileManager.h"

@implementation PFileManager

- (NSString *)getCacheHomeDirectory {
    
    NSString *cacheDiectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cacheHomeDirectory = [cacheDiectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:cacheHomeDirectory isDirectory:NULL]) {
        
        [fm createDirectoryAtPath:cacheHomeDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return cacheHomeDirectory;
}

- (NSString *)createPath:(NSString *)path {
    
    NSString *tempPath = path;
    
    if (path == nil) {
        
        tempPath = [self getCacheHomeDirectory];
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if (![fm fileExistsAtPath:tempPath isDirectory:NULL]) {
        
        [fm createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return tempPath;
}

- (long long)getLocalFileSize:(NSString *)filepath {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if (![fm fileExistsAtPath:filepath isDirectory:NULL]) {
        
        return 0;
    }
    
    NSDictionary *fileAttributes = [fm attributesOfItemAtPath:filepath error:nil];
    return [fileAttributes fileSize];
}

- (long long)getFileSizeForDir:(NSString *)dir {
    
    long long size = 0;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *filelist = [fileManager contentsOfDirectoryAtPath:dir error:nil];
    int fileCount = [filelist count];
    
    for (int i=0; i<fileCount; i++) {
        
        NSString *fullPath = [dir stringByAppendingPathComponent:[filelist objectAtIndex:i]];
        size += [self getLocalFileSize:fullPath];
    }
    
    return size;
}

- (BOOL)isFileExistInDocument:(NSString *)filename {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [directoryPath stringByAppendingPathComponent:filename];
    
    if ([fm fileExistsAtPath:filePath]) {
        
        return YES;
    }
    
    return NO;
}

- (NSString *)getFullPathFromDocument:(NSString *)filename {
    
    NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [directoryPath stringByAppendingPathComponent:filename];
    
    return filePath;
}

- (BOOL)isFileExistInBookDir:(NSString *)filename {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *fullpath = [self getFullPathFromBookDir:filename];
    
    if ([fm fileExistsAtPath:fullpath]) {
        
        return YES;
    }
    
    return NO;
}

- (NSString *)getFullPathFromBookDir:(NSString *)filename {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *bookpath = [documentPath stringByAppendingPathComponent:@"book"];
    
    if (![fm fileExistsAtPath:bookpath isDirectory:NULL]) {
        
        [self createPath:bookpath];
    }
    
    NSString *fullpath = [bookpath stringByAppendingPathComponent:filename];
    
    return fullpath;
}

@end
