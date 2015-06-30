//
//  PersonalCenterStyle0TableViewCell.m
//  Buddha
//
//  Created by Archer_LJ on 15/6/30.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "PersonalCenterStyle0TableViewCell.h"

@implementation PersonalCenterStyle0TableViewCell

@synthesize name = _name;
@synthesize goimg = _goimg;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setData:(id)data {
    
    [_name setText:data];
}

- (void)hideNavGo:(BOOL)hide {

    [_goimg setHidden:hide];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
