//
//  MyCalendarTableViewStyle1Cell.m
//  Buddha
//
//  Created by Archer_LJ on 15/7/21.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "MyCalendarTableViewStyle1Cell.h"

@implementation MyCalendarTableViewStyle1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setData:(NSString *)name cando:(BOOL)canDo {
    [_lblName setText:name];
    if (canDo) {
        [_lblName setTextColor:[UIColor greenColor]];
        [_imgHead setImage:[UIImage imageNamed:@"can_ico.png"]];
    }
    else {
        [_lblName setTextColor:[UIColor redColor]];
        [_imgHead setImage:[UIImage imageNamed:@"cannot_ico.png"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
