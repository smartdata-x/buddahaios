//
//  BaseViewController.h
//  Buddha
//
//  Created by Archer_LJ on 14/11/26.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"
#import "CustomNavView.h"
#import "HorizontalMenu.h"

@interface BaseViewController : UIViewController

@property (nonatomic, retain) AskNetDataApi *askApi;
@property (nonatomic, assign) CGRect mFrame;
@property (nonatomic, assign) BOOL mFirstLoad;

@property (nonatomic, assign) UIViewController *topViewController; // rootview指针, 用于继承此类的view跳转

@end
