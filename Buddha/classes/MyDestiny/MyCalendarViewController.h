//
//  MyCalendarViewController.h
//  Buddha
//
//  Created by Archer_LJ on 15/7/20.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQCalendarLogic.h"
#import "WQDraggableCalendarView.h"
#import "WQScrollCalendarWrapperView.h"
#import "Stdinc.h"

@interface MyCalendarViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, WQScrollCalendarWrapperViewDelegate>

@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) WQDraggableCalendarView *calendarView;
@property (nonatomic, strong) WQCalendarLogic *calendarLogic;
@property (nonatomic, strong) WQScrollCalendarWrapperView *scrollCalendarView;

@end
