//
//  LoginViewController.h
//  Buddha
//
//  Created by Archer_LJ on 14/11/25.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterBaseViewController.h"
#import "AskNetDataApi.h"

@interface LoginViewController : CenterBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *loginMenuTableView;
    NSMutableArray *tableInfoArray;
}

- (void)doLoginSuccess;
- (void)doLoginFailed;

- (void)doBack:(id)sender;

- (void)doGetBookList;
- (void)doGetBookListFailed:(NSNotification *)notification;
- (void)doGetBookListSuccess:(NSNotification *)notification;

@end
