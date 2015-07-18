//
//  DestinyNavView.m
//  Buddha
//
//  Created by Archer_LJ on 15/7/16.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "DestinyNavView.h"
#import "Stdinc.h"

@implementation DestinyNavView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        NSArray *namearr = [[NSArray alloc] initWithObjects:@"我的佛语", @"我的功课", @"我的佛历", nil];
        int i = 0;
        int itemcount = [namearr count];
        _itemArray = [[NSMutableArray alloc] initWithCapacity:itemcount];
        
        for (NSString *name in namearr) {
            float width = frame.size.width / 3.0;
            float height = frame.size.height;
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(width * i, 0, width, height)];
            [btn setTitle:name forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont fontOfApp:26 / 2]];
            
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [btn setTag:i];
            [btn addTarget:self action:@selector(itemclicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [_itemArray addObject:btn];
            
            i++;
        }
    }
    
    [self setSelected:0];
    
    return self;
}

- (void)setSelected:(NSInteger)index {
    for (int i=0; i<[_itemArray count]; i++) {
        UIButton *btn = [_itemArray objectAtIndex:i];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[Utilities colorWithHex:0xFF36423D]];
        
        if (i == index) {
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor whiteColor]];
        }
    }
}

- (IBAction)itemclicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag;
    [self setSelected:index];
    
    if([_delegate respondsToSelector:@selector(didDestinyNavClickedAtIndex:)]) {
        [_delegate didDestinyNavClickedAtIndex:index];
    }
}

@end
