//
//  LoginViewController.h
//  Buddha
//
//  Created by Archer_LJ on 14/11/25.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterBaseViewController.h"

@interface LoginViewController : CenterBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *loginMenuTableView;
    NSMutableArray *tableInfoArray;
}

@end
