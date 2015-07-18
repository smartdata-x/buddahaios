//
//  MyDestinyViewController.h
//  Buddha
//
//  Created by Archer_LJ on 15/7/16.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DestinyNavView.h"

@interface MyDestinyViewController : UIViewController<DestinyNavViewDelegate>

@property (nonatomic, retain) NSMutableDictionary *dicViewCache;
@property (nonatomic, assign) NSInteger curViewTag;

- (void)updateView:(NSInteger)viewTag;

@end
