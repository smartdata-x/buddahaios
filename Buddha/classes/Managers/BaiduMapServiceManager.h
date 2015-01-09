//
//  BaiduMapServiceManager.h
//  Buddha
//
//  Created by Archer_LJ on 15/1/10.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stdinc.h"
#import "BMapKit.h"

@interface BaiduMapServiceManager : NSObject<BMKGeneralDelegate>
{

}

+ (BaiduMapServiceManager *)GetInstance;

- (void)registerBaiduMap;

@end
