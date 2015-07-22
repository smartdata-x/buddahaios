//
//  MyCalendarTableViewStyle2Cell.m
//  Buddha
//
//  Created by Archer_LJ on 15/7/22.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "MyCalendarTableViewStyle2Cell.h"

@implementation MyCalendarTableViewStyle2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setData:(NSString *)name bigversion:(BOOL)big {
    [_lblName setText:name];
    if (big) {
        [_lblName setTextColor:[UIColor blackColor]];
        [_lblName setFont:[UIFont fontOfApp:17]];
    }
    else {
        [_lblName setTextColor:[UIColor lightGrayColor]];
        [_lblName setFont:[UIFont fontOfApp:14]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
