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
    
    CGSize size = CGSizeMake(frame.size.width, 2000);
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

@end
