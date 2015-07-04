//
//  PersonalCenterHeaderTableViewCell.m
//  Buddha
//
//  Created by Archer_LJ on 15/6/30.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "PersonalCenterHeaderTableViewCell.h"

@implementation PersonalCenterHeaderTableViewCell

@synthesize avatar = _avatar;

- (void)awakeFromNib {
    // Initialization code
    float headerwidth = CGRectGetWidth([_avatar frame]);
    [_avatar.layer setCornerRadius:headerwidth / 2.0];
    [_avatar.layer setMasksToBounds:YES];
}

- (void)setData:(id)data {
    
    [_avatar setImageURL:[NSURL URLWithString:data]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
