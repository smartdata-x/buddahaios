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

// 计算文字高度
+ (float)heightForString:(NSString *)srcstr Font:(UIFont *)font Frame:(CGRect)frame;
+ (float)MaxHeightForFontInRectWithNumber:(float *)fontsize Rect:(CGRect)rect Line:(NSInteger)lines;

// 地图中返回字符串
+ (NSString *)distanceFromFloat:(float)distance;

// 动画
+ (void)curlUp:(UIView *)view;
+ (void)curlDown:(UIView *)view;
+ (void)curlLeft:(UIView *)view;
+ (void)curlRight:(UIView *)view;

// 颜色
+ (UIColor *)colorWithHex:(unsigned int)color;

+ (void)setFullScreen:(UINavigationController *)navcontroller FullScreen:(BOOL)full;

@end
