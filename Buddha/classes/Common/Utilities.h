//
//  Utilities.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/19.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stdinc.h"

@interface Utilities : NSObject

+ (NSInteger)heightForString:(NSString *)srcstr Font:(UIFont *)font Frame:(CGRect)frame;
+ (NSString *)distanceFromFloat:(float)distance;

// 动画
+ (void)curlUp:(UIView *)view;
+ (void)curlDown:(UIView *)view;
+ (void)curlLeft:(UIView *)view;
+ (void)curlRight:(UIView *)view;

@end
