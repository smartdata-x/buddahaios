//
//  MyCalendarViewController.m
//  Buddha
//
//  Created by Archer_LJ on 15/7/20.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "MyCalendarViewController.h"
#import "MyCalendarTableViewStyle2Cell.h"
#import "MyCalendarTableViewStyle1Cell.h"

@interface MyCalendarViewController ()

@end

@implementation MyCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[Utilities colorWithHex:0xFFF5F5F5]];
    
    _calendarLogic = [[WQCalendarLogic alloc] init];
    
    UILabel *lblYearMonth = [[UILabel alloc] initWithFrame:CGRectMake(15, NAV_BAR_HEIGHT - 24, mainScreenWidth - 30, 36)];
    [lblYearMonth setFont:[UIFont fontOfApp:17]];
    [self.view addSubview:lblYearMonth];
    
    [self showCalendar];
    
    [lblYearMonth setText:[NSString stringWithFormat:@"%lu年%lu月", (unsigned long)(_calendarLogic.selectedCalendarDay.year), (unsigned long)(_calendarLogic.selectedCalendarDay.month)]];
    
    float ystart = NAV_BAR_HEIGHT + 12 + _calendarView.frame.size.height + 36 + 42;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ystart, mainScreenWidth, mainScreenHeight - ystart)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showCalendar {
    CGRect calendarRect = CGRectMake(0, NAV_BAR_HEIGHT + 12, mainScreenWidth, 200);
    
    _calendarView = [[WQDraggableCalendarView alloc] initWithFrame:calendarRect];
    _calendarView.draggble = NO;
    [self.view addSubview:_calendarView];
    _calendarView.backgroundColor = [Utilities colorWithHex:0xFFF5F5F5];
    [_calendarLogic reloadCalendarView:_calendarView];
    
    CGRect scrollRect = CGRectMake(0, 350 + 50, mainScreenWidth, 40);
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

// tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellname = nil;
    NSArray *namearr = [[NSArray alloc] initWithObjects:@"MyCalendarTableViewStyle2Cell", @"MyCalendarTableViewStyle1Cell", nil];
    
    if (indexPath.row == 2 || indexPath.row == 3) {
        cellname = [namearr objectAtIndex:1];
    }
    else {
        cellname = [namearr objectAtIndex:0];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellname];
    
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:cellname owner:nil options:nil];
        cell = [nibContents objectAtIndex:0];
    }
    
    if (indexPath.row == 0) {
        MyCalendarTableViewStyle2Cell *stylecell = (MyCalendarTableViewStyle2Cell *)cell;
        [stylecell setData:@"农历五月二十一" bigversion:YES];
    }
    else if (indexPath.row == 1) {
        MyCalendarTableViewStyle2Cell *stylecell = (MyCalendarTableViewStyle2Cell *)cell;
        [stylecell setData:@"乙未年 [羊年]" bigversion:NO];
    }
    else if (indexPath.row == 2) {
        MyCalendarTableViewStyle1Cell *stylecell = (MyCalendarTableViewStyle1Cell *)cell;
        [stylecell setData:@"祭祀、祈福、开光、伐木" cando:YES];
    }
    else if (indexPath.row == 3) {
        MyCalendarTableViewStyle1Cell *stylecell = (MyCalendarTableViewStyle1Cell *)cell;
        [stylecell setData:@"祭祀、祈福、开光、伐木" cando:NO];
    }
    else if (indexPath.row == 4) {
        MyCalendarTableViewStyle2Cell *stylecell = (MyCalendarTableViewStyle2Cell *)cell;
        [stylecell setData:@"冲: 祭祀、祈福、开光、伐木" bigversion:NO];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
