//
//  BookStoreViewController.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/23.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"
#import "BaseNavViewController.h"
#import "BookImageView.h"
#import "ReadingViewController.h"
#import "PFileManager.h"

@interface BookShellViewController : BaseNavViewController<BookImageViewDelegate>
{
    UIView *viewWrapper;
}

@property (nonatomic, retain) NSMutableArray *mBookData; // 信息容器
@property (nonatomic, retain) UIScrollView *mScrlBookStore; // 书架的框架结构
@property (nonatomic, assign) float shellHeight;
@property (nonatomic, assign) float bookWidth;
@property (nonatomic, assign) float bookHeight;

// 外部

// 内部
- (void)initNavView;
- (void)initBookShellView;
- (void)initBookImage;

- (void)initBookShellInfo;

- (void)doGotoBookStore;
- (void)doGotoReadingView:(NSString *)bookname BookID:(NSString *)bookid BookToken:(NSString *)booktoken;

@end
