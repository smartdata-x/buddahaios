//
//  GeneralSearchView.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/27.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "GeneralSearchView.h"

@implementation GeneralSearchView

- (id)initWithFrame:(CGRect)frame BgImg:(NSString *)bgimg IconImg:(NSString *)iconimg Content:(NSString *)content Font:(UIFont *)font {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        float xMid = frame.size.width / 2;
        float yMid = frame.size.height / 2;
        
        if (_bgImgView == nil) {
            
            _bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bgimg]];
            _bgImgView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        }
        
        if (_searchIcon == nil) {
            
            _searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconimg]];
            
            float xStart = xMid - (14 + 32) / SCREEN_SCALAR;
            float yStart = yMid - 16 / SCREEN_SCALAR;
            _searchIcon.frame = CGRectMake(xStart, yStart, 16, 16);
        }
        
        if (_lblSearchContent == nil) {
            
            _lblSearchContent = [[UILabel alloc] initWithFrame:CGRectMake(xMid, yMid - 11, xMid, 21)];
            _lblSearchContent.text = content;
            [_lblSearchContent setTextColor:[UIColor lightGrayColor]];
            [_lblSearchContent setTextAlignment:NSTextAlignmentLeft];
            [_lblSearchContent setFont:font];
        }
        
        [self addSubview:_bgImgView];
        [self addSubview:_searchIcon];
        [self addSubview:_lblSearchContent];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfClicked)];
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

- (void)selfClicked {
    
    if ([_delegate respondsToSelector:@selector(didGeneralSearchViewClicked)]) {
        
        [_delegate didGeneralSearchViewClicked];
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
