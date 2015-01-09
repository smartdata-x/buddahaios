//
//  BaiduMapServiceManager.m
//  Buddha
//
//  Created by Archer_LJ on 15/1/10.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "BaiduMapServiceManager.h"

@implementation BaiduMapServiceManager

+ (BaiduMapServiceManager *)GetInstance {
    
    static BaiduMapServiceManager *instance = nil;
    
    @synchronized(self) {
        
        if (nil == instance) {
            
            instance = [[BaiduMapServiceManager alloc] init];
        }
    }
    
    return instance;
}

- (void)registerBaiduMap {
    
    // 初始化百度地图
    BMKMapManager *mBDMapManager = [[BMKMapManager alloc] init];
    BOOL ret = [mBDMapManager start:@"96IS38XTSvyMSLgpPbV0FjKq" generalDelegate:nil];
    if (!ret) {
        
        MIGDEBUG_PRINT(@"百度地图启动成功");
    }
}

// BMKGeneral Delegate
-(void)onGetNetworkState:(int)iError
{
    if (iError == 0)
    {
        NSLog(@"网络连接正常");
    }
    else
    {
        NSLog(@"网络错误:%d",iError);
    }
}

-(void)onGetPermissionState:(int)iError
{
    if (iError == 0)
    {
        NSLog(@"授权成功");
    }
    else
    {
        NSLog(@"授权失败:%d",iError);
    }
}

@end
