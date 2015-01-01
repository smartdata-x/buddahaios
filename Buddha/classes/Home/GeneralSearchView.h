//
//  GeneralSearchView.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/27.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"

@protocol GeneralSearchViewDelegate <NSObject>

@optional

- (void)didGeneralSearchViewClicked;

@end

@interface GeneralSearchView : UIView

@property (nonatomic, retain) UIImageView *bgImgView;
@property (nonatomic, retain) UIImageView *searchIcon;
@property (nonatomic, retain) UILabel *lblSearchContent;
@property (nonatomic, retain) id<GeneralSearchViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame BgImg:(NSString *)bgimg IconImg:(NSString *)iconimg Content:(NSString *)content Font:(UIFont *)font;

- (void)selfClicked;

@end
