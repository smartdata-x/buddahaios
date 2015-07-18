//
//  MyBuddhaBookTableViewStyle0Cell.m
//  Buddha
//
//  Created by Archer_LJ on 15/7/18.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "MyBuddhaBookTableViewStyle0Cell.h"

@implementation MyBuddhaBookTableViewStyle0Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_lblName setFont:[UIFont fontOfApp:18]];
    [_lblAuthor setFont:[UIFont fontOfApp:15]];
    [_lblRead setFont:[UIFont fontOfApp:15]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSString *)avatar name:(NSString *)name author:(NSString *)author read:(NSString *)read like:(BOOL)like {
    [_avatar setImageURL:[NSURL URLWithString:avatar]];
    [_lblName setText:name];
    [_lblAuthor setText:author];
    [_lblRead setText:read];
    [_imgLike setImage:[UIImage imageNamed:like ? @"love_on_ico.png" : @"love_ico.png"]];
}

@end
