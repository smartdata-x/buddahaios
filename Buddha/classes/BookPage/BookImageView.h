//
//  BookImageView.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/23.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"
#import "EGOImageButton.h"
#import "BookDetailViewController.h"
@protocol BookImageViewDelegate;


@interface BookImageView : UIView
{
}

@property (nonatomic, assign) id<BookImageViewDelegate> delegate;
@property (nonatomic, retain) IBOutlet EGOImageButton *avatarImg;
@property (nonatomic, retain) migsBookDetailInformation *bookinfo;

// 外部调用
- (id)initWithFrame:(CGRect)frame BookInfo:(migsBookDetailInformation *)bookinfo;

// 内部调用
- (void)imageClicked;

@end

@protocol BookImageViewDelegate <NSObject>

@optional

- (void)didBookImageClicked:(BookImageView *)sender;

@end
