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
    
    MIG_BOOK_LISTTYPE_NEW = 0,
    MIG_BOOK_LISTTYPE_HOT,
};

@interface BookCategoryViewController : BaseNavViewController<GeneralSearchViewDelegate, HorizontalMenuDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UIView *viewWrapper;
    NSMutableArray *tableInfoNewArray;
    NSMutableArray *tableInfoHotArray;
    NSString *BookId;
    int listType;
}

@property (nonatomic, retain) GeneralSearchView *searchView;
@property (nonatomic, retain) HorizontalMenu *topMenuView;
@property (nonatomic, retain) UITableView *contentTableView;

// 外部
- (id)initWithTitle:(NSString *)title BookID:(NSString *)bookid;

// 内部
- (void)initNavView:(NSString *)title;
- (void)initSearchView;
- (void)initTopMenu;
- (void)initContentView;

- (void)doGodoBookDetail:(migsBookIntroduce *)bookIntro;

- (void)reloadDataByType:(int)type;
- (void)reloadData;

- (void)doGetBookByID:(NSString *)bookid;
- (void)doGetBookByIDFailed:(NSNotification *)notification;
- (void)doGetBookByIDSuccess:(NSNotification *)notification;

@end
