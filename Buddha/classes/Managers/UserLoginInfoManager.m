//
//  UserLoginInfoManager.m
//  Buddha
//
//  Created by Archer_LJ on 14/11/30.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "UserLoginInfoManager.h"

@implementation UserLoginInfoManager

+ (UserLoginInfoManager *)GetInstance {
    
    static UserLoginInfoManager *instance = nil;
    
    @synchronized(self) {
        
        if (nil == instance) {
            
            instance = [[UserLoginInfoManager alloc] init];
        }
    }
    
    return instance;
}

@end
