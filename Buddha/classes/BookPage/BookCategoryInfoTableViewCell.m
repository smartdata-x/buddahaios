//
//  BookCategoryInfoTableViewCell.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/28.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "BookCategoryInfoTableViewCell.h"

@implementation BookCategoryInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initialize:(migsBookIntroduce *)bookIntro {
    
    _avatarImg.imageURL = [NSURL URLWithString:bookIntro.imgUrl];
    
    [_lblName setText:bookIntro.name];
    [_lblName setFont:[UIFont fontOfApp:30 / SCREEN_SCALAR]];
    [_lblName setTextAlignment:NSTextAlignmentLeft];
    [_lblName setTextColor:MIG_COLOR_111111];
    
    [_lblDetail setText:bookIntro.introduce];
    [_lblDetail setTextColor:MIG_COLOR_808080];
    [_lblDetail setTextAlignment:NSTextAlignmentLeft];
    [_lblDetail setNumberOfLines:0];
    [_lblDetail setFont:[UIFont fontOfApp:26 / SCREEN_SCALAR]];
}

@end
