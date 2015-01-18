//
//  IntroducePageViewController.h
//  Buddha
//
//  Created by Archer_LJ on 15/1/10.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"
#import "BaseViewController.h"
#import "BookIntroduceTableViewCell.h"

@interface IntroducePageViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *classicInfo;
    UIView *classicWrapper;
    
    UITableView *introTableView;
    NSMutableArray *tableHistroyInfo;
    NSMutableArray *tableThoughtInfo;
    NSMutableArray *tableArtInfo;
    NSMutableArray *tableSectionInfo;
}

- (void)initView;
- (void)initClassicView:(float)ystart;
- (void)initTableView:(float)ystart;

- (void)reloadData;

- (IBAction)onClickClassicMenu:(id)sender;
- (void)doGotoIntroduceBookView:(migsBookIntroduce *)bookintro;
- (IBAction)doGotoHistoryAndThought:(id)sender;
- (IBAction)doGotoArt:(id)sender;

- (void)getIntroFailed:(NSNotification *)notification;
- (void)getIntroSuccess:(NSNotification *)notification;

@end
