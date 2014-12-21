//
//  TwoPageMenuVIew.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/21.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"

@interface TwoPageMenuVIew : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *leftMenu;
@property (nonatomic, retain) UITableView *rightMenu;

@end
