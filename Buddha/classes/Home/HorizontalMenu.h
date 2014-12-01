//
//  TopHorizontalMenu.h
//  Buddha
//
//  Created by Archer_LJ on 14/11/22.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"

enum {
    
    HORIZONTALMENU_TYPE_BUTTON = 0,
    HORIZONTALMENU_TYPE_BUTTON_LABEL,
    MAX_HORIZONTALMENU_TYPE
};

@protocol HorizontalMenuDelegate <NSObject>

@optional

- (void)didHorizontalMenuClickedButttonAtIndex:(NSInteger)index Type:(NSInteger)type;

@end

@interface HorizontalMenu : UIView
{
    NSMutableArray *mButtonArray;
    NSMutableArray *mItemInfoArray;
    UIScrollView *mMenuScrollView;
    float mMenuTotalWidth;
    NSInteger menuType;
}

@property (nonatomic, assign) id <HorizontalMenuDelegate> delegate;

// 初始化菜单
- (id)initWithFrame:(CGRect)frame ButtonItems:(NSArray *)itemArray ButtonType:(NSInteger)type;

// 选中某个按钮
- (void)clickButtonAtIndex:(NSInteger)index;

// 改变某个按钮状态，不发送delegate
- (void)changeButtonStateAtIndex:(NSInteger)index;

@end