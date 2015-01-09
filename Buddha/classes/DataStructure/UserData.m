//
//  UserData.m
//  Monas
//
//  Created by Archer_LJ on 14/11/16.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "UserData.h"

@implementation migsImgWithTitleAndDetail

+ (migsImgWithTitleAndDetail *)initByDic:(NSDictionary *)dic {
    
    if (dic == nil) {
    
        return nil;
    }
    
    migsImgWithTitleAndDetail *ret = [[migsImgWithTitleAndDetail alloc] init];
    
    int nID = [[dic objectForKey:@"id"] intValue];
    int nType = [[dic objectForKey:@"type"] intValue];
    NSString *ID = [NSString stringWithFormat:@"%d", nID];
    NSString *type = [NSString stringWithFormat:@"%d", nType];
    NSString *img = [dic objectForKey:@"pic"];
    NSString *name = [dic objectForKey:@"name"];
    NSString *summary = [dic objectForKey:@"summary"];
    
    ret.ID = ID;
    ret.type = type;
    ret.imgName = img;
    ret.imgTitle = name;
    ret.imgDetail = summary;
    
    return ret;
}

@end
