//
//  ActivityDetailTableViewCell.m
//  Buddha
//
//  Created by Archer_LJ on 15/1/6.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "ActivityDetailTableViewCell.h"

@implementation ActivityDetailTableViewCell

- (void)initialize:(NSString *)imagename {
    
    _avatarImg.imageURL = [NSURL URLWithString:imagename];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
