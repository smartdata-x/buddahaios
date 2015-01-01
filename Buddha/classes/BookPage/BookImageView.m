//
//  BookImageView.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/23.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "BookImageView.h"

@implementation BookImageView

- (id)initWithFrame:(CGRect)frame BookInfo:(migsBookDetailInformation *)bookinfo {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _bookinfo = bookinfo;
        
        CGRect avatarFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        _avatarImg = [[EGOImageButton alloc] initWithFrame:avatarFrame];
        _avatarImg.imageURL = [NSURL URLWithString:_bookinfo.imgURL];
        
        [_avatarImg addTarget:self action:@selector(imageClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_avatarImg];
    }
    
    return self;
}

- (void)imageClicked {
    
    if ([_delegate respondsToSelector:@selector(didBookImageClicked:)]) {
        
        [_delegate didBookImageClicked:self];
    }
}

@end
