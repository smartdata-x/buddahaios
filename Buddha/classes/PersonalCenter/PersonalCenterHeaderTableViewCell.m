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
}

- (void)setData:(id)data {
    
    [_avatar setImageURL:[NSURL URLWithString:data]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
