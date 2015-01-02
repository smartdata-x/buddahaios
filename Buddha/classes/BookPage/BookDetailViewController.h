//
//  BookDetailViewController.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/28.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"
#import "BaseNavViewController.h"
#import "BookIntroduceTableViewCell.h"
#import "HorizontalMenu.h"
#import "GeneralSearchView.h"
#import "GeneralShareView.h"

enum {
    
    MIG_BOOK_DETAIL_FREEREAD = 0,
    MIG_BOOK_DETAIL_SAVETOSHELF,
};

@interface migsBookDetailInformation : NSObject

@property (nonatomic, retain) NSString *bookname;
@property (nonatomic, retain) NSString *bookid;
@property (nonatomic, retain) NSString *booktype;
@property (nonatomic, retain) NSString *booktoken;
@property (nonatomic, retain) NSString *imgURL;
@property (nonatomic, retain) NSString *bookSummary;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *publicTime;
@property (nonatomic, retain) NSString *Chapters;
@property (nonatomic, retain) NSString *freeContentUrl;
@property (nonatomic, retain) NSString *fullContentUrl;
@property (nonatomic, retain) NSMutableArray *labels;
@property (nonatomic, assign) int issaved;

+ (migsBookDetailInformation *)setupBookDetailByDictionary:(NSDictionary *)dic;

@end

@interface BookDetailViewController : BaseNavViewController<HorizontalMenuDelegate, UITableViewDelegate, UITableViewDataSource, GeneralSearchViewDelegate, GeneralShareViewDelegate, UIActionSheetDelegate>
{
    UIView *rootViewWrapper;
    UIScrollView *viewWrapper;
    NSMutableArray *bookTitle; // 只能有一个数据，多个数据的时候，只取第一个
    NSMutableArray *tagInfo;
}

@property (nonatomic, retain) UITableView *titleTableView;
@property (nonatomic, retain) HorizontalMenu *menuView;
@property (nonatomic, retain) UILabel *lblDetailInfo;
@property (nonatomic, retain) GeneralSearchView *chapterView;
@property (nonatomic, retain) GeneralSearchView *shareView;
@property (nonatomic, retain) UILabel *lblTag;

@property (nonatomic, retain) migsBookIntroduce *bookInfo;
@property (nonatomic, retain) migsBookDetailInformation *bookDetailInfo;


//IOS7及以下分享菜单
@property (nonatomic, retain) UIActionSheet *shareAchtionSheet;
//IOS8及以上分享选择
@property (nonatomic,retain) UIAlertController * shareAlertController;
@property (nonatomic, retain) GeneralShareView *bookShareView;

// 外部
- (void)initialize:(migsBookIntroduce *)bookIntro;

// 内部
- (void)initNavView;
- (void)initBookCellView:(float)yStart;
- (void)initMenuView:(float)yStart;
- (void)initDetailInfoView:(float *)yStart;
- (void)initShareView:(float)yStart;
- (void)initTagView:(float *)yStart;
- (void)initBookShareView;

- (void)reloadView;

- (IBAction)doGotoBookShell:(id)sender isSaveToShelf:(BOOL)issave;
- (void)doGotoReadingView:(NSString *)bookname BookID:(NSString *)bookid BookToken:(NSString *)booktoken;
- (void)doShowShareView;

- (void)reloadData;

- (void)doGetBookSummary:(NSString *)bookid;
- (void)doGetBookSummaryFailed:(NSNotification *)notification;
- (void)doGetBookSummarySuccess:(NSNotification *)notification;

- (void)doGetBookToken:(NSString *)bookid;
- (void)doGetBookTokenFailed:(NSNotification *)notification;
- (void)doGetBookTokenSuccess:(NSNotification *)notification;

@end
