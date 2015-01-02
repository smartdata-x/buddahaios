//
//  Utilities.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/19.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (NSInteger)heightForString:(NSString *)srcstr Font:(UIFont *)font Frame:(CGRect)frame {
    
    CGSize size = CGSizeMake(frame.size.width, MAXFLOAT);
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGSize labelSize = [srcstr boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    
    return labelSize.height;
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

@end
