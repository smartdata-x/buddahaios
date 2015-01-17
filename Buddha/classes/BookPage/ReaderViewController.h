//
//  ReaderViewController.h
//  Buddha
//
//  Created by Archer_LJ on 15/1/17.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"
#import "BaseNavViewController.h"
#import "PFileManager.h"

@interface ReaderViewController : BaseNavViewController<UIGestureRecognizerDelegate>
{
    BOOL isFullScreen;
    float pageHeight;
    
    float fontSize;
    
    int curPage;
    int allPage;
    int curChapter;
    int allChapter;
    
    NSString *mBookname;
    NSString *mBookid;
    NSString *mBooktoken;
    NSString *curContent;
    
    NSString *curChapterFilename;
    
    CGRect viewFrame;
    
    migsReadingProcess *readingProcess;
    BOOL pageAnimate;
    BOOL useProcess;
    BOOL needDoNextInAppear;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) UILabel *lblBookName;
@property (nonatomic, retain) UILabel *lblChapterName;
@property (nonatomic, retain) PFileManager *pfm;
@property (nonatomic, retain) NSMutableArray *chapterArray;

// 外部
- (void)initialize:(NSString *)bookname BookId:(NSString *)bookid BookToken:(NSString *)booktoken;
- (void)initWithChapterArray:(NSString *)bookname Chapter:(NSArray *)chapters StartChapter:(int)startchapter UseProcess:(BOOL)useprocess;

// 内部
- (void)initView:(CGRect)frame;
- (void)initTopView:(CGRect)frame;

- (void)doDownloadBook:(NSString *)url ToFile:(NSString *)tofile;
- (void)doDownloadBookFailed;
- (void)doDownloadBookSuccess;

- (void)getChapterList:(NSString *)booktoken ID:(NSString *)bookid;
- (void)getChapterListFailed:(NSNotification *)notification;
- (void)getChapterListSuccess:(NSNotification *)notification;

- (void)setIsFullScreen;

- (void)doNextPage:(UISwipeGestureRecognizer *)swipGesture;
- (void)doPreviousPage:(UISwipeGestureRecognizer *)swipGesture;
- (void)doTap:(UITapGestureRecognizer *)tapGesture;

- (void)getFileContent:(NSString *)filename;

- (void)doGotoPreviousChapter;
- (void)doGotoNextChapter:(BOOL)forceDownload;

- (void)recordReadingProcess;
- (migsReadingProcess *)getReadingProcessByID:(NSString *)bookid;
- (migsReadingProcess *)getReadingProcessByName:(NSString *)bookname;
- (void)jumpToReadingProcess;

@end
