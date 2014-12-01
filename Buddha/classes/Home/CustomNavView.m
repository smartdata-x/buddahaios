//
//  CustomNavView.m
//  Buddha
//
//  Created by Archer_LJ on 14/11/23.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "CustomNavView.h"

@implementation CustomNavView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        float bgSize = 26;
        UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_HOME_NORMAL_BG]];
        bgImg.frame = CGRectMake(0, (frame.size.height - bgSize) / 2.0, frame.size.width, bgSize);
        // 背景图设为圆角
        CALayer *layer = [bgImg layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:(bgSize / 2.0)];
        
        float btnSize = 20;
        UIButton *btnSearch = [[UIButton alloc] initWithFrame:CGRectMake(5, (frame.size.height - btnSize) / 2.0, btnSize, btnSize)];
        [btnSearch setBackgroundImage:[UIImage imageNamed:IMG_HOME_SEARCH] forState:UIControlStateNormal];
        
        UILabel *placeHolderText = [[UILabel alloc] initWithFrame:CGRectMake(5 + btnSize + 5, (frame.size.height - btnSize) / 2.0, 100, btnSize)];
        placeHolderText.text = @"搜索你的佛缘";
        placeHolderText.textColor = [UIColor lightGrayColor];
        placeHolderText.backgroundColor = [UIColor clearColor];
        placeHolderText.font = [UIFont fontOfApp:24.0 / SCREEN_SCALAR];
        
        [self addSubview:bgImg];
        [self addSubview:btnSearch];
        [self addSubview:placeHolderText];
        
        // 添加手势识别
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCustomNav)];
        [self addGestureRecognizer:gesture];
    }
    
    return self;
}

- (void)clickCustomNav {
    
    MIGDEBUG_PRINT(@"Custom nav view clicked");
    
    if ([_delegate respondsToSelector:@selector(didCustomNavViewClicked)]) {
        
        [_delegate didCustomNavViewClicked];
    }
}

@end
