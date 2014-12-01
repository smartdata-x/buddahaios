//
//  TopHorizontalMenu.m
//  Buddha
//
//  Created by Archer_LJ on 14/11/22.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "HorizontalMenu.h"

@implementation HorizontalMenu

- (id)initWithFrame:(CGRect)frame ButtonItems:(NSArray *)itemArray ButtonType:(NSInteger)type {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        if (mButtonArray == nil) {
            
            mButtonArray = [[NSMutableArray alloc] init];
        }
        
        if (mItemInfoArray == nil) {
            
            mItemInfoArray = [[NSMutableArray alloc] init];
        }
        
        if (mMenuScrollView == nil) {
            
            mMenuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            mMenuScrollView.showsHorizontalScrollIndicator = NO;
        }
        
        [mItemInfoArray removeAllObjects];
        
        if (type == HORIZONTALMENU_TYPE_BUTTON ) {
            
            [self createMenuItemsWithButton:itemArray];
        }
        else if (type == HORIZONTALMENU_TYPE_BUTTON_LABEL) {
            
            [self createMenuItemsWithButtonAndLabel:itemArray];
        }
    }
    
    return self;
}

- (void)createMenuItemsWithButton:(NSArray *)itemsArray {
    
    int i = 0;
    float menuStart = 0.0;
    
    for (NSDictionary *dic in itemsArray) {
        
        NSString *szNormalImg = [dic objectForKey:KEY_NORMAL];
        NSString *szHilightImg = [dic objectForKey:KEY_HILIGHT];
        NSString *szTitle = [dic objectForKey:KEY_TITLE];
        float buttonWidth = [[dic objectForKey:KEY_TITLE_WIDTH] floatValue];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:szNormalImg] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:szHilightImg] forState:UIControlStateSelected];
        
        [button setTitle:szTitle forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontOfApp:30.0 / SCREEN_SCALAR];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        [button setTag:i];
        [button addTarget:self action:@selector(menuButtonClicked:Type:) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(menuStart, 0, buttonWidth, self.frame.size.height)];
        
        [mMenuScrollView addSubview:button];
        [mButtonArray addObject:button];
        
        menuStart += buttonWidth;
        i++;
        
        // 保存button资源
        NSMutableDictionary *newDic = [dic mutableCopy];
        [newDic setObject:[NSNumber numberWithFloat:menuStart] forKey:KEY_TOTAL_WIDTH];
        [mItemInfoArray addObject:newDic];
    }
    
    [mMenuScrollView setContentSize:CGSizeMake(menuStart, self.frame.size.height)];
    [self addSubview:mMenuScrollView];
    
    // 保存菜单总长度
    mMenuTotalWidth = menuStart;
    menuType = HORIZONTALMENU_TYPE_BUTTON;
}

- (void)createMenuItemsWithButtonAndLabel:(NSArray *)itemsArray {
    
    int i = 0;
    float menuStart = 0.0;
    float imgWidth = 42 / SCREEN_SCALAR;
    float imgHeight = 44 / SCREEN_SCALAR;
    float lblHeight = 30 / SCREEN_SCALAR;
    
    for (NSDictionary *dic in itemsArray) {
        
        NSString *szNormalImg = [dic objectForKey:KEY_NORMAL];
        NSString *szHilightImg = [dic objectForKey:KEY_HILIGHT];
        NSString *szTitle = [dic objectForKey:KEY_TITLE];
        float menuWidth = [[dic objectForKey:KEY_TITLE_WIDTH] floatValue];
        float menuLeftSpace = (menuWidth - imgWidth) / 2.0;
        float menuUpperSpace = 4.0;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:szNormalImg] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:szHilightImg] forState:UIControlStateSelected];
        [button setTitle:szTitle forState:UIControlStateNormal];
        [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
        
        [button setTag:i];
        [button addTarget:self action:@selector(menuButtonClicked:Type:) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(menuStart + menuLeftSpace, menuUpperSpace, imgWidth, imgHeight)];
        
        float lblYStart = menuUpperSpace * 2 + imgHeight;
        UILabel *lblDesc = [[UILabel alloc] initWithFrame:CGRectMake(menuStart, lblYStart, menuWidth, lblHeight)];
        lblDesc.text = szTitle;
        lblDesc.font = [UIFont fontOfApp:20.0 / SCREEN_SCALAR];
        lblDesc.textColor = [UIColor grayColor];
        lblDesc.textAlignment = NSTextAlignmentCenter;
        
        [mMenuScrollView addSubview:button];
        [mButtonArray addObject:button];
        [mMenuScrollView addSubview:lblDesc];
        
        menuStart += menuWidth;
        i++;
        
        // 保存button资源
        NSMutableDictionary *newDic = [dic mutableCopy];
        [newDic setObject:[NSNumber numberWithFloat:menuStart] forKey:KEY_TOTAL_WIDTH];
        [mItemInfoArray addObject:newDic];
    }
    
    [mMenuScrollView setContentSize:CGSizeMake(menuStart, self.frame.size.height)];
    [self addSubview:mMenuScrollView];
    
    // 保存菜单总长度
    mMenuTotalWidth = menuStart;
    
    menuType = HORIZONTALMENU_TYPE_BUTTON_LABEL;
}

/* 
 ************** 其他辅助功能 **************
 */
// 取消所有按钮点击状态
- (void)changeButtonsToNormalState {
    
    for (UIButton *button in mButtonArray) {
        
        button.selected = NO;
    }
}

// 模拟选中第几个按钮
- (void)clickButtonAtIndex:(NSInteger)index {
    
    UIButton *button = [mButtonArray objectAtIndex:index];
    [self menuButtonClicked:button Type:menuType];
}

// 改变某个按钮状态，不发送delegate
- (void)changeButtonStateAtIndex:(NSInteger)index {
    
    [self changeButtonsToNormalState];
    
    UIButton *button = [mButtonArray objectAtIndex:index];
    button.selected = YES;
    
    [self moveScrollViewWithIndex:index];
}

// 移动按钮到可视区域
- (void)moveScrollViewWithIndex:(NSInteger)index {
    
    // 宽度太小不用移动
    if (mItemInfoArray.count < index ||
        mMenuTotalWidth <= 320) {
        
        return;
    }
    
    NSDictionary *dic = [mItemInfoArray objectAtIndex:index];
    float buttonOrigin = [[dic objectForKey:KEY_TOTAL_WIDTH] floatValue];
    if (buttonOrigin >= 300) {
        
        if ((buttonOrigin + 180) >= mMenuScrollView.contentSize.width) {
            
            [mMenuScrollView setContentOffset:CGPointMake(mMenuScrollView.contentSize.width - 320, mMenuScrollView.contentOffset.y) animated:YES];
            return;
        }
        
        float moveToContentOffset = buttonOrigin - 180;
        if (moveToContentOffset > 0) {
            
            [mMenuScrollView setContentOffset:CGPointMake(moveToContentOffset, mMenuScrollView.contentOffset.y) animated:YES];
        }
    }
    else {
        
        [mMenuScrollView setContentOffset:CGPointMake(0, mMenuScrollView.contentOffset.y) animated:YES];
        return;
    }
}

// 点击事件
- (void)menuButtonClicked:(UIButton *)button Type:(NSInteger)type {
    
    [self changeButtonStateAtIndex:button.tag];
    
    if ([_delegate respondsToSelector:@selector(didHorizontalMenuClickedButttonAtIndex:Type:)]) {
        
        [_delegate didHorizontalMenuClickedButttonAtIndex:button.tag Type:menuType];
    }
}

@end
