//
//  ReadingView.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/23.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"
#import "BaseNavViewController.h"

@interface ReadingViewController : BaseNavViewController<UITextViewDelegate, UIGestureRecognizerDelegate>
{
    UIView *viewWrapper;
    BOOL isFullScreen;
    float contentoffset;
}

@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) NSString *mainContent;
@property (nonatomic, retain) NSString *fileURL;
@property (nonatomic, assign) int curPage;
@property (nonatomic, assign) int allPage;
@property (nonatomic, assign) float pageHeight;

// 外部
- (void)initialize:(NSString *)filename fileurl:(NSString *)fileURL;

// 内部
- (void)initView:(CGRect)frame;

- (void)doDownloadBook;
- (void)doDownloadBookFailed;
- (void)doDownloadBookSuccess;

- (void)setIsFullScreen;

- (void)doNextPage:(UISwipeGestureRecognizer *)swipGesture;
- (void)doPreviousPage:(UISwipeGestureRecognizer *)swipGesture;
- (void)doTap:(UITapGestureRecognizer *)tapGesture;

- (void)getFileContent;

@end
