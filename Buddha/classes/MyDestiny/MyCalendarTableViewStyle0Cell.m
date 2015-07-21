//
//  MyCalendarTableViewStyle0Cell.m
//  Buddha
//
//  Created by Archer_LJ on 15/7/21.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "MyCalendarTableViewStyle0Cell.h"

@implementation MyCalendarTableViewStyle0Cell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setData:(NSString *)name {
    [_lblName setText:name];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
