//
//  Utilities.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/19.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (float)heightForString:(NSString *)srcstr Font:(UIFont *)font Frame:(CGRect)frame {
    
    CGSize size = CGSizeMake(frame.size.width, MAXFLOAT);
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGSize labelSize = [srcstr boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    
    return labelSize.height;
}

+ (float)heightForAttributedString:(NSAttributedString *)srcstr Font:(UIFont *)font Frame:(CGRect)frame {
    
    CGSize size = CGSizeMake(frame.size.width, MAXFLOAT);
    CGRect labelSize = [srcstr boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return labelSize.size.height;
}

+ (float)MaxHeightForFontInRectWithNumber:(float *)fontsize Rect:(CGRect)rect Line:(NSInteger)lines {
    
    float maxHeight = 1;
    float lastFontsize = 5;
    CGRect maxRect = CGRectMake(0, 0, rect.size.width, MAXFLOAT);
    
    NSMutableString *testString = [[NSMutableString alloc] init];
    [testString appendString:@"1"];
    for (int i=0; i<lines-1; i++) {
        
        [testString appendString:@"\n1"];
    }
    
    int i = 100;
    while (i > 0) {
        
        if ([self heightForString:testString Font:[UIFont fontOfApp:lastFontsize] Frame:maxRect] >= rect.size.height) {
            
            break;
        }
        
        lastFontsize += 1.0;
        i--;
    }
    
    lastFontsize -= 1.0;
    maxHeight = [self heightForString:testString Font:[UIFont fontOfApp:lastFontsize] Frame:maxRect];
    
    *fontsize = lastFontsize * SCREEN_SCALAR;
    return maxHeight;
}

+ (NSString *)distanceFromFloat:(float)distance {
    
    NSString *ret = nil;
    
    if (distance < 1000.0) {
        
        ret = [NSString stringWithFormat:@"%.1fM", distance];
    }
    else if (distance > 1000.0) {
        
        float tmpDistance = distance / 1000.0;
        ret = [NSString stringWithFormat:@"%.1fKM", tmpDistance];
    }
    
    return ret;
}

+ (void)curlUp:(UIView *)view {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:view cache:YES];
    [UIView commitAnimations];
}

+ (void)curlDown:(UIView *)view {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:view cache:YES];
    [UIView commitAnimations];
}

+ (void)curlLeft:(UIView *)view {
    
    CATransition *tr = [CATransition animation];
    tr.duration = 0.6;
    tr.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    tr.type = @"pageUnCurl";
    tr.subtype = @"fromLeft";
    tr.fillMode = kCAFillModeForwards;
    [tr setFillMode:@"extended"];
    [tr setRemovedOnCompletion:NO];
    
    tr.delegate = self;
    [view.layer addAnimation:tr forKey:@"pageCurlAnimation"];
}

+ (void)curlRight:(UIView *)view {
    
    CATransition *tr = [CATransition animation];
    tr.duration = 0.6;
    tr.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    tr.type = @"pageUnCurl";
    tr.subtype = @"fromRight";
    tr.fillMode = kCAFillModeForwards;
    [tr setFillMode:@"extended"];
    [tr setRemovedOnCompletion:NO];
    
    tr.delegate = self;
    [view.layer addAnimation:tr forKey:@"pageCurlAnimation"];
}

+ (UIColor *)colorWithHex:(unsigned int)color {
    
    unsigned int Blue = color & 0xFF;
    unsigned int Green = (color >> 8) & 0xFF;
    unsigned int Red = (color >> 16) & 0xFF;
    unsigned int Alpha = (color >> 24) & 0xFF;
    float fblue = Blue / 255.0;
    float fgreen = Green / 255.0;
    float fred = Red / 255.0;
    float falpha = Alpha / 1.0;
    
    UIColor *uicolor = [UIColor colorWithRed:fred green:fgreen blue:fblue alpha:falpha];
    
    return uicolor;
}

+ (void)setFullScreen:(UINavigationController *)navcontroller FullScreen:(BOOL)full {
    
    [navcontroller setNavigationBarHidden:full animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:full withAnimation:YES];
}

+ (UIImage *)getPartOfImage:(UIImage *)img Rect:(CGRect)rect {
    
    CGImageRef imageRef = img.CGImage;
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *retImg = [UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    
    return retImg;
}

@end
