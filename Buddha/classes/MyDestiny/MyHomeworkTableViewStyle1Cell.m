//
//  MyHomeworkTableViewStyle1Cell.m
//  Buddha
//
//  Created by Archer_LJ on 15/7/18.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "MyHomeworkTableViewStyle1Cell.h"

@implementation MyHomeworkTableViewStyle1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _view0 = [[HomeworkView1 alloc] initWithFrame:CGRectMake(8, 8, 150, 120)];
    [self addSubview:_view0];
    
    _view1 = [[HomeworkView1 alloc] initWithFrame:CGRectMake(self.frame.size.width - 150 - 8, 8, 150, 120)];
    [_view1 setHidden:YES];
    [self addSubview:_view1];
}

- (void)setData0:(NSString *)cover name:(NSString *)name class:(NSString *)classes charge:(NSString *)charge {
    [_view0 setData:cover name:name class:classes charge:charge];
}

- (void)setData1:(NSString *)cover name:(NSString *)name class:(NSString *)classes charge:(NSString *)charge {
    [_view1 setData:cover name:name class:classes charge:charge];
    [_view1 setHidden:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
