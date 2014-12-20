//
//  BaseNavViewController.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/17.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//


// 此类继承于BaseViewController，主要添加一个绿色的导航颜色和淡色背景,以及一个返回键
#import <UIKit/UIKit.h>
#import "Stdinc.h"

@interface BaseNavViewController : UIViewController

- (IBAction)doBack:(id)sender;

@end
