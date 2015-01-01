//
//  GeneralShareView.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/28.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "GeneralShareView.h"

@implementation GeneralShareView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initView:frame];
    }
    
    return self;
}

- (void)initView:(CGRect)frame {
    
    int iconCount = 3;
    
    float iconWidth = 100 / SCREEN_SCALAR;
    float iconHeight = 100 / SCREEN_SCALAR;
    float btnXStart = 30 / SCREEN_SCALAR;
    float btnYStart = 50 / SCREEN_SCALAR;
    float yGap = 28 / SCREEN_SCALAR;
    float xGap = (self.frame.size.width - 38 - iconCount * iconWidth) / (iconCount - 1);
    float lblWidth = iconWidth;
    float lblHeight = 21.0;
    
    // 微信, QQ空间，微博
    NSArray *imageArray = [NSArray arrayWithObjects:IMG_SHARE_WEIXIN, IMG_SHARE_QQZONE, IMG_SHARE_WEIBO, nil];
    NSArray *strArray = [NSArray arrayWithObjects:@"微信", @"QQ空间", @"新浪微博", nil];
    
    for (int i=0; i<iconCount; i++) {
        
        NSString *img = [imageArray objectAtIndex:i];
        NSString *name = [strArray objectAtIndex:i];
        
        CGRect btnFrame = CGRectMake(btnXStart + i * (iconWidth + xGap),
                                     btnYStart,
                                     iconWidth,
                                     iconHeight);
        UIButton *btn = [[UIButton alloc] initWithFrame:btnFrame];
        [btn setBackgroundImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        
        CGRect lblFrame = CGRectMake(btnXStart + i * (lblWidth + xGap),
                                     btnYStart + iconHeight + yGap,
                                     lblWidth,
                                     lblHeight);
        UILabel *lbl = [[UILabel alloc] initWithFrame:lblFrame];
        [lbl setText:name];
        [lbl setFont:[UIFont fontOfApp:22 / SCREEN_SCALAR]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setTextColor:MIG_COLOR_808080];
        
        [self addSubview:btn];
        [self addSubview:lbl];
    }
}

- (IBAction)btnClicked:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    if ([_delegate respondsToSelector:@selector(didGeneralShareViewClicked:)]) {
        
        [_delegate didGeneralShareViewClicked:btn.tag];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
