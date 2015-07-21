//
//  WQCalendarView.m
//  WQCalendar
//
//  Created by Jason Lee on 14-3-12.
//  Copyright (c) 2014年 Jason Lee. All rights reserved.
//

#import "WQCalendarView.h"

@interface WQCalendarView ()

@end

@implementation WQCalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *weeklyHeaderImage = [UIImage imageNamed:@"week_title.png"];
        self.weeklyHeader = [[UIImageView alloc] initWithImage:weeklyHeaderImage];
        self.weeklyHeader.frame = (CGRect){0, 0, self.bounds.size.width, 42};
        [self addSubview:self.weeklyHeader];
        
        CGFloat headerHeight = 42;
        CGRect gridRect = (CGRect){0, headerHeight, self.bounds.size.width, WQ_CALENDAR_ROW_HEIGHT * 6};
        self.gridView = [[WQCalendarGridView alloc] initWithFrame:gridRect];
        [self addSubview:self.gridView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
