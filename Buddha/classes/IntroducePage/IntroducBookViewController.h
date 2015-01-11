//
//  IntroducBookViewController.h
//  Buddha
//
//  Created by Archer_LJ on 15/1/10.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"
#import "BaseNavViewController.h"
#import "BookDetailViewController.h"
#import "GeneralSearchView.h"

@interface IntroducBookViewController : BaseNavViewController<UITableViewDataSource, UITableViewDelegate, GeneralSearchViewDelegate, UIActionSheetDelegate>
{
    UIView *rootViewWrapper;
    UIScrollView *viewWrapper;
    
    UITableView *headerTableView;
    NSMutableArray *headerTableInfo;
    
    UIButton *btnRead;
    GeneralSearchView *shareView;
    
    UILabel *detailInfoView;
    
    UITableView *chapterTableView;
    NSMutableArray *chapterTableInfo;
}

@property (nonatomic, retain) migsBookIntroduce *bookInfo;
@property (nonatomic, retain) migsBookDetailInformation *bookDetailInfo;
@property (nonatomic, retain) GeneralShareView *bookShareView;
//IOS7及以下分享菜单
@property (nonatomic, retain) UIActionSheet *shareAchtionSheet;
//IOS8及以上分享选择
@property (nonatomic,retain) UIAlertController * shareAlertController;

// 外部
- (void)initialize:(migsBookIntroduce *)bookIntro;

- (void)initView;
- (void)initNavView;
- (void)initHeaderTableView:(float)ystart;
- (void)initInfomationView:(float *)ystart;
- (void)initChapterTableView:(float)ystart;

- (void)reloadData;

- (void)doGetHisAndThr:(NSString *)type;
- (void)doGetHisAndThrFailed:(NSNotification *)notification;
- (void)doGetHisAndThrSuccess:(NSNotification *)notification;

- (IBAction)doGotoReadingView:(id)sender;
- (void)doGotoShare:(UIGestureRecognizer *)gesture;

@end
