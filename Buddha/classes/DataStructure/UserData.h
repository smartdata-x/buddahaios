//
//  UserData.h
//  Monas
//
//  Created by Archer_LJ on 14/11/16.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface migsImgWithTitleAndDetail : NSObject

@property (nonatomic, retain) NSString *imgName;
@property (nonatomic, retain) NSString *imgTitle;
@property (nonatomic, retain) NSString *imgDetail;
@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *type;

+ (migsImgWithTitleAndDetail *)initByDic:(NSDictionary *)dic;

@end
