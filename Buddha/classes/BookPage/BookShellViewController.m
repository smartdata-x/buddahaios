//
//  BookStoreViewController.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/23.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "BookShellViewController.h"
#import "BookDetailViewController.h"
#import "DatabaseManager.h"
#import "ReadingViewController.h"

@interface BookShellViewController ()

@end

@implementation BookShellViewController

- (id)init {
    
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initBookShellInfo];
    
    _shellHeight = 22 / SCREEN_SCALAR;
    _bookWidth = 170 / SCREEN_SCALAR;
    _bookHeight = 223 / SCREEN_SCALAR;
    
    [self initNavView];
    [self initBookShellView];
}

- (void)initBookShellInfo {
    
    if (_mBookData == nil) {
        
        _mBookData = [[NSMutableArray alloc] init];
    }
    
    NSArray *bookinfos = [[DatabaseManager GetInstance] getAllBookInfo];
    int count = [bookinfos count];
    
    for (int i=0; i<count; i++) {
        
        migsBookDetailInformation *detailinfo = (migsBookDetailInformation *)[bookinfos objectAtIndex:i];
        
        [_mBookData addObject:detailinfo];
    }
}

- (void)initNavView {
    
    self.navigationItem.title = @"书架";
    
    // 书城按钮
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(44, 0, 60/SCREEN_SCALAR, 43/SCREEN_SCALAR);
    [btnRight setBackgroundColor:[UIColor clearColor]];
    [btnRight setTitle:@"书城" forState:UIControlStateNormal];
    [btnRight.titleLabel setFont:[UIFont fontOfApp:28 / SCREEN_SCALAR]];
    [btnRight.titleLabel setTextColor:[UIColor whiteColor]];
    [btnRight.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btnRight addTarget:self action:@selector(doGotoBookStore) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = item0;
    
    // view wrapper
    if (viewWrapper == nil) {
        
        viewWrapper = [[UIView alloc] initWithFrame:self.view.frame];
    }
    [viewWrapper setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:viewWrapper];
}

- (void)initBookShellView {
    
    if (_mScrlBookStore == nil) {
        
        _mScrlBookStore = [[UIScrollView alloc] initWithFrame:self.view.frame];
    }
    
    int bookcount = [_mBookData count];
    if (bookcount <= 0) {
        
        return;
    }
    
    float row = (float)bookcount / MIG_BOOKS_PER_ROW; // 每排显示3本
    float ceilRow = ceilf(row);
    float height = ceilRow * MIG_BOOKCELL_HEIGHT;
    float contentHeight = height > self.view.frame.size.height ? height : self.view.frame.size.height;
    _mScrlBookStore.contentSize = CGSizeMake(self.view.frame.size.width, contentHeight);
    
    [viewWrapper addSubview:_mScrlBookStore];
    
    // 加载书店背景图
    int bgCount = (int)ceilRow;
    for (int i=0; i<bgCount; i++) {
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_BOOK_SHELF]];
        bgImageView.frame = CGRectMake(10, (223 + 48) / SCREEN_SCALAR, self.view.frame.size.width - 20, _shellHeight);
        
        float ystart = i * MIG_BOOKCELL_HEIGHT;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, ystart, self.view.frame.size.width, MIG_BOOKCELL_HEIGHT)];
        [view addSubview:bgImageView];
        [_mScrlBookStore addSubview:view];
    }

    [self initBookImage];
}

- (void)initBookImage {
    
    if (_mBookData == nil) {
        
        _mBookData = [[NSMutableArray alloc] init];
    }
    
#if MIG_DEBUG_TEST
#if 0
    migsBookDetailInformation *bookinfo = [[migsBookDetailInformation alloc] init];
    bookinfo.bookname = @"书籍";
    bookinfo.imgURL = @"http://face.miu.miyomate.com/system.jpg";
    
    [_mBookData addObject:bookinfo];
    [_mBookData addObject:bookinfo];
    [_mBookData addObject:bookinfo];
    [_mBookData addObject:bookinfo];
    [_mBookData addObject:bookinfo];
    [_mBookData addObject:bookinfo];
    [_mBookData addObject:bookinfo];
#endif
#endif
    
    float xGap = (self.view.frame.size.width - _bookWidth * 3 - 40) / 2.0;
    int count = [_mBookData count];
    
    if (count <= 0) {
        
        return;
    }
    
    for (int i=0; i<count; i++) {
        
        int x = i % 3;
        int y = i / 3;
        
        CGRect curFrame = CGRectMake(20 + x * (_bookWidth + xGap),
                                     48 / SCREEN_SCALAR + y * MIG_BOOKCELL_HEIGHT,
                                     _bookWidth,
                                     _bookHeight);
        migsBookDetailInformation *bookinfo = [_mBookData objectAtIndex:i];
        
        BookImageView *bookview = [[BookImageView alloc] initWithFrame:curFrame BookInfo:bookinfo];
        bookview.tag = i;
        bookview.delegate = self;
        [_mScrlBookStore addSubview:bookview];
        
        //UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_BOOK_FOJING]];
        //imgView.frame = curFrame;
        //[_mScrlBookStore addSubview:imgView];
    }
}

- (void)doGotoBookStore {
    
    
}

- (void)doGotoReadingView:(NSString *)bookname BookID:(NSString *)bookid BookToken:(NSString *)booktoken {
    
    ReadingViewController *readingView = [[ReadingViewController alloc] init];
    [readingView initialize:bookname BookId:bookid BookToken:booktoken];
    [self.navigationController pushViewController:readingView animated:YES];
}

// BookImageViewDelegate
- (void)didBookImageClicked:(BookImageView *)sender {
    
    int index = sender.tag;
    MIGDEBUG_PRINT(@"第%d本书被点击", index);
    migsBookDetailInformation *detailinfo = [_mBookData objectAtIndex:index];
    
    [self doGotoReadingView:detailinfo.bookname BookID:detailinfo.bookid BookToken:detailinfo.booktoken];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
