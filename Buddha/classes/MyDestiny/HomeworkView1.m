//
//  HomeworkView1.m
//  Buddha
//
//  Created by Archer_LJ on 15/7/19.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "HomeworkView1.h"
#import "Stdinc.h"

@implementation HomeworkView1

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setBackgroundColor:[Utilities colorWithHex:0xFFF5F5F5]];
        
        _imgCover = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 80)];
        [self addSubview:_imgCover];
        
        _lblName = [[UILabel alloc] initWithFrame:CGRectMake(15, 59, self.frame.size.width - 30, 21)];
        [_lblName setTextColor:[UIColor whiteColor]];
        [_lblName setFont:[UIFont fontOfApp:11]];
        [self addSubview:_lblName];
        
        _lblClass = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, self.frame.size.width - 30, 21)];
        [_lblClass setTextColor:[UIColor lightGrayColor]];
        [_lblClass setFont:[UIFont fontOfApp:11]];
        [self addSubview:_lblClass];
        
        _lblCharge = [[UILabel alloc] initWithFrame:CGRectMake(15, 100, CGRectGetWidth(self.frame) - 30, 21)];
        [_lblCharge setTextColor:[UIColor lightGrayColor]];
        [_lblCharge setFont:[UIFont fontOfApp:11]];
        [self addSubview:_lblCharge];
    }
    
    return self;
}

- (void)setData:(NSString *)cover name:(NSString *)name class:(NSString *)classes charge:(NSString *)charge {
    [_imgCover setImageURL:[NSURL URLWithString:cover]];
    [_lblName setText:[NSString stringWithFormat:@"%@", name]];
    [_lblClass setText:[NSString stringWithFormat:@"课时:%@节", classes]];
    [_lblCharge setText:[NSString stringWithFormat:@"收费:%@", charge]];
}

@end
