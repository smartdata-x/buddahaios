//
//  TopHorizontalMenu.m
//  Buddha
//
//  Created by Archer_LJ on 14/11/22.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "HorizontalMenu.h"

@implementation HorizontalMenu

- (id)initWithFrame:(CGRect)frame ButtonItems:(NSArray *)itemArray buttonSize:(CGSize)btnSize ButtonType:(NSInteger)type {
    
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
        else if (type == HORIZONTALMENU_TYPE_BUTTON_LABEL_DOWN) {
            
            [self createMenuItemsWithButtonAndDownLabel:itemArray imgSize:btnSize];
        }
        else if (type == HORIZONTALMENU_TYPE_BUTTON_LABEL_RIGHT) {
            
            [self createMenuItemsWithButtonAndRightLabel:itemArray imgSize:btnSize];
        }
        else if (type == HORIZONTALMENU_TYPE_BUTTON_LABEL_LEFT) {
            
            [self createMenuItemsWithButtonAndLeftLabel:itemArray imgSize:btnSize];
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

- (void)createMenuItemsWithButtonAndDownLabel:(NSArray *)itemsArray imgSize:(CGSize)imgsize {
    
    // 初始化位置变量
    int i = 0;
    int itemcount = [itemsArray count];
    float badgeWidth = 30 / SCREEN_SCALAR;
    float imgWidth = imgsize.width;
    float imgHeight = imgsize.height;
    float lblHeight = 30 / SCREEN_SCALAR;
    float usefulWidth = self.frame.size.width - badgeWidth * 2;
    float vSeperate = 10 / SCREEN_SCALAR;
    float ystart = 4.0;
    float itemWidth = usefulWidth / itemcount;
    
    for (NSDictionary *dic in itemsArray) {
        
        // 当前菜单的基础位置
        float curXStart = badgeWidth + i * itemWidth;
        float imgXstart = curXStart + (itemWidth - imgWidth) / 2.0;
        
        NSString *szNormalImg = [dic objectForKey:KEY_NORMAL];
        NSString *szHilightImg = [dic objectForKey:KEY_HILIGHT];
        NSString *szTitle = [dic objectForKey:KEY_TITLE];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:szNormalImg] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:szHilightImg] forState:UIControlStateSelected];
        [button setTitle:szTitle forState:UIControlStateNormal];
        [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
        
        [button setTag:i];
        [button addTarget:self action:@selector(menuButtonClicked:Type:) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(imgXstart, ystart, imgWidth, imgHeight)];
        
        float lblYStart = ystart + imgHeight + vSeperate;
        UILabel *lblDesc = [[UILabel alloc] initWithFrame:CGRectMake(curXStart, lblYStart, itemWidth, lblHeight)];
        lblDesc.text = szTitle;
        lblDesc.font = [UIFont fontOfApp:20.0 / SCREEN_SCALAR];
        lblDesc.textColor = [UIColor grayColor];
        lblDesc.textAlignment = NSTextAlignmentCenter;
        [lblDesc setTag:i];
        [lblDesc setUserInteractionEnabled:YES];
        
        [mMenuScrollView addSubview:button];
        [mButtonArray addObject:button];
        [mMenuScrollView addSubview:lblDesc];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handTap:)];
        [lblDesc addGestureRecognizer:tap];
        
        i++;
        
        // 保存button资源
        NSMutableDictionary *newDic = [dic mutableCopy];
        [newDic setObject:[NSNumber numberWithFloat:curXStart] forKey:KEY_TOTAL_WIDTH];
        [mItemInfoArray addObject:newDic];
    }
    
    [mMenuScrollView setContentSize:CGSizeMake(usefulWidth, self.frame.size.height)];
    [self addSubview:mMenuScrollView];
    
    // 保存菜单总长度
    mMenuTotalWidth = usefulWidth;
    
    menuType = HORIZONTALMENU_TYPE_BUTTON_LABEL_DOWN;
}

- (void)createMenuItemsWithButtonAndRightLabel:(NSArray *)itemsArray imgSize:(CGSize)imgsize {
    
    // 初始化位置变量
    int i = 0;
    int itemcount = [itemsArray count];
    float badgeWidth = 30 / SCREEN_SCALAR;
    float imgWidth = imgsize.width;
    float imgHeight = imgsize.height;
    float lblWidth = 60 / SCREEN_SCALAR;
    float lblHeight = 30 / SCREEN_SCALAR;
    float usefulWidth = self.frame.size.width - badgeWidth * 2;
    float hSeperate = 24 / SCREEN_SCALAR;
    float itemWidth = usefulWidth / itemcount;
    
    for (NSDictionary *dic in itemsArray) {
        
        // 当前菜单的基础位置
        float curXStart = badgeWidth + i * itemWidth;
        float imgXstart = curXStart + (itemWidth - imgWidth - lblWidth - hSeperate) / 2.0;
        float imgYstart = self.frame.size.height / 2 - imgHeight / 2;
        
        NSString *szNormalImg = [dic objectForKey:KEY_NORMAL];
        NSString *szHilightImg = [dic objectForKey:KEY_HILIGHT];
        NSString *szTitle = [dic objectForKey:KEY_TITLE];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:szNormalImg] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:szHilightImg] forState:UIControlStateSelected];
        [button setTitle:szTitle forState:UIControlStateNormal];
        [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
        
        [button setTag:i];
        [button addTarget:self action:@selector(menuButtonClicked:Type:) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(imgXstart, imgYstart, imgWidth, imgHeight)];
        
        float lblXStart = imgXstart + imgWidth + hSeperate;
        float lblYStart = self.frame.size.height / 2 - lblHeight / 2;
        UILabel *lblDesc = [[UILabel alloc] initWithFrame:CGRectMake(lblXStart, lblYStart, lblWidth, lblHeight)];
        lblDesc.text = szTitle;
        lblDesc.font = [UIFont fontOfApp:30.0 / SCREEN_SCALAR];
        lblDesc.textColor = [UIColor grayColor];
        lblDesc.textAlignment = NSTextAlignmentCenter;
        [lblDesc setTag:i];
        [lblDesc setUserInteractionEnabled:YES];
        
        [mMenuScrollView addSubview:button];
        [mButtonArray addObject:button];
        [mMenuScrollView addSubview:lblDesc];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handTap:)];
        [lblDesc addGestureRecognizer:tap];
        
        i++;
        
        // 保存button资源
        NSMutableDictionary *newDic = [dic mutableCopy];
        [newDic setObject:[NSNumber numberWithFloat:curXStart] forKey:KEY_TOTAL_WIDTH];
        [mItemInfoArray addObject:newDic];
    }
    
    [mMenuScrollView setContentSize:CGSizeMake(usefulWidth, self.frame.size.height)];
    [self addSubview:mMenuScrollView];
    
    // 白色背景
    [self setBackgroundColor:[UIColor whiteColor]];
    
    // 保存菜单总长度
    mMenuTotalWidth = usefulWidth;
    menuType = HORIZONTALMENU_TYPE_BUTTON_LABEL_RIGHT;
}

- (void)createMenuItemsWithButtonAndLeftLabel:(NSArray *)itemsArray imgSize:(CGSize)imgsize {
    
    // 初始化位置变量
    int i = 0;
    int itemcount = [itemsArray count];
    float badgeWidth = 30 / SCREEN_SCALAR;
    float imgWidth = imgsize.width;
    float imgHeight = imgsize.height;
    float lblWidth = 60 / SCREEN_SCALAR;
    float lblHeight = 30 / SCREEN_SCALAR;
    float usefulWidth = self.frame.size.width - badgeWidth * 2;
    float hSeperate = 0;
    float itemWidth = usefulWidth / itemcount;
    
    for (NSDictionary *dic in itemsArray) {
        
        // 当前菜单的基础位置
        float curXStart = badgeWidth + i * itemWidth;
        float imgXstart = curXStart + (itemWidth - imgWidth - lblWidth - hSeperate) / 2.0;
        float imgYstart = self.frame.size.height / 2 - imgHeight / 2;
        
        NSString *szNormalImg = [dic objectForKey:KEY_NORMAL];
        NSString *szHilightImg = [dic objectForKey:KEY_HILIGHT];
        NSString *szTitle = [dic objectForKey:KEY_TITLE];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:szNormalImg] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:szHilightImg] forState:UIControlStateSelected];
        [button setTitle:szTitle forState:UIControlStateNormal];
        [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
        
        [button setTag:i];
        [button addTarget:self action:@selector(menuButtonClicked:Type:) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(imgXstart, imgYstart, imgWidth, imgHeight)];
        
        float lblXStart = imgXstart + imgWidth + hSeperate;
        float lblYStart = self.frame.size.height / 2 - lblHeight / 2;
        UILabel *lblDesc = [[UILabel alloc] initWithFrame:CGRectMake(lblXStart, lblYStart, lblWidth, lblHeight)];
        lblDesc.text = szTitle;
        lblDesc.font = [UIFont fontOfApp:30.0 / SCREEN_SCALAR];
        lblDesc.textColor = [UIColor grayColor];
        lblDesc.textAlignment = NSTextAlignmentCenter;
        [lblDesc setTag:i];
        [lblDesc setUserInteractionEnabled:YES];
        
        [mMenuScrollView addSubview:button];
        [mButtonArray addObject:button];
        [mMenuScrollView addSubview:lblDesc];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handTap:)];
        [lblDesc addGestureRecognizer:tap];
        
        i++;
        
        // 保存button资源
        NSMutableDictionary *newDic = [dic mutableCopy];
        [newDic setObject:[NSNumber numberWithFloat:curXStart] forKey:KEY_TOTAL_WIDTH];
        [mItemInfoArray addObject:newDic];
    }
    
    [mMenuScrollView setContentSize:CGSizeMake(usefulWidth, self.frame.size.height)];
    [self addSubview:mMenuScrollView];
    
    // 白色背景
    [self setBackgroundColor:[UIColor whiteColor]];
    
    // 保存菜单总长度
    mMenuTotalWidth = usefulWidth;
    menuType = HORIZONTALMENU_TYPE_BUTTON_LABEL_RIGHT;
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
- (void)menuClicked:(NSInteger)index Type:(NSInteger)type {
    
    [self changeButtonStateAtIndex:index];
    
    if ([_delegate respondsToSelector:@selector(didHorizontalMenuClickedButttonAtIndex:Type:)]) {
        
        [_delegate didHorizontalMenuClickedButttonAtIndex:index Type:menuType];
    }
}

- (void)menuButtonClicked:(UIButton *)button Type:(NSInteger)type {
    
    [self menuClicked:button.tag Type:type];
}

- (void)handTap:(UITapGestureRecognizer *)gesture {
    
    UILabel *view = (UILabel *)gesture.view;
    
    [self menuClicked:view.tag Type:menuType];
}

@end
