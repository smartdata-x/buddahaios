//
//  MyHomeworkTableViewStyle0Cell.m
//  Buddha
//
//  Created by Archer_LJ on 15/7/18.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "MyHomeworkTableViewStyle0Cell.h"

@implementation MyHomeworkTableViewStyle0Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_lblCharge setFont:[UIFont fontOfApp:11]];
    [_lblClass setFont:[UIFont fontOfApp:11]];
    [_lblName setFont:[UIFont fontOfApp:11]];
}

- (void)setData:(NSString *)cover name:(NSString *)name class:(NSString *)classes charge:(NSString *)charge {
    [_imgCover setImageURL:[NSURL URLWithString:cover]];
    [_lblCharge setText:charge];
    [_lblClass setText:[NSString stringWithFormat:@"%@课时", classes]];
    [_lblName setText:[NSString stringWithFormat:@"课名:%@", name]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
