//
//  BookStoreViewController.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/26.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"
#import "BaseViewController.h"
#import "BookShellViewController.h"
#import "BookIntroduceTableViewCell.h"

enum {
    
    MIG_BOOK_ID_FOJING = 1,
    MIG_BOOK_ID_YIGUI,
    MIG_BOOK_ID_FOLUN,
    MIG_BOOK_ID_JINGDAI,
};

@interface BookStoreViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *classicInfo;
    UIView *classicWrapper;
    
    UITableView *bookTableView;
    NSMutableArray *tableIntroInfo;
    NSMutableArray *tableBookFojingInfo;
    NSMutableArray *tableBookFolunInfo;
    NSMutableArray *tableBookYiguiInfo;
    
    NSMutableArray *tableSectionInfo;
    
    float tableYStart;
}

// 外部调用

// 内部调用
- (void)initClassicView; // 顶部按钮菜单
- (void)initTableView;

- (void)reloadData;

- (IBAction)doGotoBookShell:(id)sender;
- (IBAction)doGotoBookCategory:(id)sender;
- (void)doGodoBookDetail:(migsBookIntroduce *)bookIntro;

- (void)getBookFailed:(NSNotification *)notification;
- (void)getBookSuccess:(NSNotification *)notification;

- (void)onClickFojingCell;
- (void)onClickYiguiCell;
- (void)onClickFolunCell;

@end
