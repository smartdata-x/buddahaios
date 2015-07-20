//
//  MyCalendarViewController.m
//  Buddha
//
//  Created by Archer_LJ on 15/7/20.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "MyCalendarViewController.h"

@interface MyCalendarViewController ()

@end

@implementation MyCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _calendarLogic = [[WQCalendarLogic alloc] init];
    
    [self showCalendar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showCalendar {
    CGRect calendarRect = CGRectMake(0, 0, mainScreenWidth, 350);
    calendarRect.origin.y += 52;
    calendarRect.size.height -= 52;
    
    _calendarView = [[WQDraggableCalendarView alloc] initWithFrame:calendarRect];
    _calendarView.draggble = NO;
    [self.view addSubview:_calendarView];
    _calendarView.backgroundColor = [Utilities colorWithHex:0xFFF5F5F5];
    [_calendarLogic reloadCalendarView:_calendarView];
    
    CGRect scrollRect = self.view.frame;
    scrollRect.origin.y = 400;
    scrollRect.size.height = 40;
    _scrollCalendarView = [[WQScrollCalendarWrapperView alloc] initWithFrame:scrollRect];
    _scrollCalendarView.backgroundColor = [UIColor greenColor];
    _scrollCalendarView.delegate = self;
    //[self.view addSubview:_scrollCalendarView];
    //[_scrollCalendarView reloadData];
}

- (void)goToNextMonth:(id)sender
{
    [self.calendarLogic goToNextMonthInCalendarView:self.calendarView];
    self.monthLabel.text = [NSString stringWithFormat:@"%lu年%lu月", (unsigned long)self.calendarLogic.selectedCalendarDay.year, (unsigned long)self.calendarLogic.selectedCalendarDay.month];
    
    if (sender != nil) {
        [self.scrollCalendarView moveToDate:[self.calendarLogic.selectedCalendarDay date]];
    }
}

- (void)goToPreviousMonth:(id)sender
{
    [self.calendarLogic goToPreviousMonthInCalendarView:self.calendarView];
    self.monthLabel.text = [NSString stringWithFormat:@"%lu年%lu月", (unsigned long)self.calendarLogic.selectedCalendarDay.year, (unsigned long)self.calendarLogic.selectedCalendarDay.month];
    
    if (sender != nil) {
        [self.scrollCalendarView moveToDate:[self.calendarLogic.selectedCalendarDay date]];
    }
}

#pragma mark - WQScrollCalendarWrapperViewDelegate

- (void)monthDidChangeFrom:(NSInteger)fromMonth to:(NSInteger)toMonth
{
    if (fromMonth == 12 && toMonth == 1) {
        [self goToNextMonth:nil];
    } else if (toMonth < fromMonth || (fromMonth == 1 && toMonth == 12)) {
        [self goToPreviousMonth:nil];
    } else {
        [self goToNextMonth:nil];
    }
}

- (void)calendarViewDidScroll
{
    ;
}

#pragma mark - UIPickerViewDelegate

#if 0
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.view.frame.size.width / 7.0;
}
#endif

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = nil;
    
    switch (component) {
        case 0:
            title = [NSString stringWithFormat:@"%ld 时", (long)row];
            break;
            
        case 1:
            title = [NSString stringWithFormat:@"%ld 分", (long)row];
            break;
            
        default:
            break;
    }
    
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    ;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rows = 0;
    
    switch (component) {
        case 0:
            rows = 24;
            break;
            
        case 1:
            rows = 60;
            break;
            
        default:
            break;
    }
    
    return rows;
}

@end
