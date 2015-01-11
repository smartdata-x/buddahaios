//
//  BookCategoryViewController.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/27.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"
#import "BaseNavViewController.h"
#import "GeneralSearchView.h"
#import "HorizontalMenu.h"
#import "BookCategoryInfoTableViewCell.h"

enum {
    
    // frombook: 最新，热点
    // fromintro: 历史，思想
    MIG_BOOK_LISTTYPE_NEW = 0,
    MIG_BOOK_LISTTYPE_HOT,
};

enum {
    
    FROMPAGE_BOOK = 0,
    FROMPAGE_INTRODUCE,
};

enum {
    
    INTROTYPE_HISTORY = 1,
    INTROTYPE_THOUGHT,
    INTROTYPE_IMAGE,
    INTROTYPE_ART,
};

@interface BookCategoryViewController : BaseNavViewController<GeneralSearchViewDelegate, HorizontalMenuDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UIView *viewWrapper;
    NSMutableArray *tableInfoNewArray;
    NSMutableArray *tableInfoHotArray;
    NSString *BookId;
    int listType;
    BOOL isLoadingNetData;
}

@property (nonatomic, retain) GeneralSearchView *searchView;
@property (nonatomic, retain) HorizontalMenu *topMenuView;
@property (nonatomic, retain) UITableView *contentTableView;
@property (nonatomic, assign) int fromPage;

// 外部
- (id)initWithTitle:(NSString *)title BookID:(NSString *)bookid From:(int)frompage;

// 内部
- (void)initNavView:(NSString *)title;
- (void)initSearchView;
- (void)initTopMenu;
- (void)initTopMenuAndClick:(int)index;
- (void)initContentView;

- (void)doGodoBookDetail:(migsBookIntroduce *)bookIntro;

- (void)reloadDataByType:(int)type;
- (void)reloadData;

- (void)doGetBookByID:(NSString *)bookid;
- (void)doGetBookByIDFailed:(NSNotification *)notification;
- (void)doGetBookByIDSuccess:(NSNotification *)notification;

- (void)doGetIntroSearch:(NSString *)type;
- (void)doGetIntroSearchFailed:(NSNotification *)notification;
- (void)doGetIntroSearchSuccess:(NSNotification *)notification;
@end
