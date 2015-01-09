//
//  ActivityTableViewCell.m
//  Buddha
//
//  Created by Archer_LJ on 15/1/6.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "ActivityTableViewCell.h"

@implementation ActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initialize:(migsImgWithTitleAndDetail *)infos {
    
    if (infos == nil) {
        
        return;
    }
    
    NSString *imgName = infos.imgName;
    NSString *title = infos.imgTitle;
    NSString *detail = infos.imgDetail;
    
    _avatarImg.imageURL = [NSURL URLWithString:imgName];
    
    [_lblTitle setText:title];
    [_lblTitle setFont:[UIFont fontOfApp:30 / SCREEN_SCALAR]];
    [_lblTitle setTextAlignment:NSTextAlignmentLeft];
    [_lblTitle setTextColor:MIG_COLOR_111111];
    
    [_lblDetail setText:detail];
    [_lblDetail setFont:[UIFont fontOfApp:26 / SCREEN_SCALAR]];
    [_lblDetail setTextAlignment:NSTextAlignmentLeft];
    [_lblDetail setTextColor:[UIColor lightGrayColor]];
    [_lblDetail setNumberOfLines:0];
}

@end
