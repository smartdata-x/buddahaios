//
//  ArtDisplayViewController.h
//  Buddha
//
//  Created by Archer_LJ on 15/1/11.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"
#import "BaseNavViewController.h"

@interface ArtDisplayViewController : BaseNavViewController<UIGestureRecognizerDelegate>
{
    UIView *viewWrapper;

    EGOImageView *imageDisplayView;
    NSString *imageName;
    
    UIView *infoWrapper;
    UILabel *infoView;
    NSString *infoString;
    
    NSString *introID;
    NSString *titleName;
    
    BOOL isFullScreen;
}

- (void)initialize:(NSString *)introid Title:(NSString *)title;

- (void)initView;
- (void)initNavView;
- (void)initImageDisplayView:(float *)originY;
- (void)initInfoView:(float *)originY;

- (void)reloadData;

- (void)getArt:(NSString *)introid;
- (void)getArtFailed:(NSNotification *)notification;
- (void)getArtSuccess:(NSNotification *)notification;

- (void)doTap:(UITapGestureRecognizer *)tapGesture;
- (void)changeFullScreen;

@end
