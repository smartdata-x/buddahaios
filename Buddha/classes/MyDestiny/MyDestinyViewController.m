//
//  MyDestinyViewController.m
//  Buddha
//
//  Created by Archer_LJ on 15/7/16.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "MyDestinyViewController.h"
#import "Stdinc.h"
#import "MyBuddhaBookTableViewController.h"
#import "MyHomeworkTableViewController.h"
#import "MyCalendarViewController.h"

@interface MyDestinyViewController ()

@end

@implementation MyDestinyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 左返回键
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(24, 0, 25.0 / SCREEN_SCALAR, 44.0 / SCREEN_SCALAR)];
    [backButton setBackgroundImage:[UIImage imageNamed:IMG_BACK_ARROW] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    // 中间键
    DestinyNavView *navView = [[DestinyNavView alloc] initWithFrame:CGRectMake(0, 0, 180, NAV_BAR_HEIGHT - 13)];
    navView.delegate = self;
    self.navigationItem.titleView = navView;
    
    _dicViewCache = [[NSMutableDictionary alloc] initWithCapacity:DESTINYNAV_CURRENT];
    [self updateView:DESTINYNAV_BUDDHABOOK];
}

- (IBAction)doBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIViewController *)getViewControllerByTag:(NSInteger)tag {
    NSNumber *numIndex = [NSNumber numberWithInteger:tag];
    UIViewController *controller = [_dicViewCache objectForKey:numIndex];
    
    switch (tag) {
        case DESTINYNAV_BUDDHABOOK:
        {
            if (controller) {
                MyBuddhaBookTableViewController *buddhabook = (MyBuddhaBookTableViewController *)controller;
                [buddhabook viewWillAppear:YES];
            }
            else {
                MyBuddhaBookTableViewController *buddhabook = [[MyBuddhaBookTableViewController alloc] initWithNibName:@"MyBuddhaBookTableViewController" bundle:nil];
                [buddhabook.view setFrame:CGRectMake(0, NAV_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - NAV_BAR_HEIGHT)];
                [buddhabook viewWillAppear:YES];
                [_dicViewCache setObject:buddhabook forKey:numIndex];
                controller = buddhabook;
            }
        }
        break;
            
        case DESTINYNAV_HOMEWORK:
        {
            if (controller) {
                MyHomeworkTableViewController *homework = (MyHomeworkTableViewController *)controller;
                [homework viewWillAppear:YES];
            }
            else {
                MyHomeworkTableViewController *homework = [[MyHomeworkTableViewController alloc] initWithNibName:@"MyHomeworkTableViewController" bundle:nil];
                [homework.view setFrame:CGRectMake(0, NAV_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - NAV_BAR_HEIGHT)];
                [homework viewWillAppear:YES];
                [_dicViewCache setObject:homework forKey:numIndex];
                controller = homework;
            }
        }
        break;
            
        case DESTINYNAV_CALENDAR:
        {
            if (controller) {
                MyCalendarViewController *calendar = (MyCalendarViewController *)controller;
                [calendar viewWillAppear:YES];
            }
            else {
                MyCalendarViewController *calendar = [[MyCalendarViewController alloc] initWithNibName:@"MyCalendarViewController" bundle:nil];
                [calendar.view setFrame:CGRectMake(0, NAV_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - NAV_BAR_HEIGHT)];
                [calendar viewWillAppear:YES];
                [_dicViewCache setObject:calendar forKey:numIndex];
                controller = calendar;
            }
        }
        break;
            
        default: break;
    }
    
    return controller;
}

- (void)updateView:(NSInteger)viewTag {
    UIView *oldview = [self.view viewWithTag:DESTINYNAV_CURRENT];
    [oldview removeFromSuperview];
    
    _curViewTag = viewTag;
    
    UIViewController *controller = [self getViewControllerByTag:_curViewTag];
    UIView *newView = controller.view;
    newView.tag = DESTINYNAV_CURRENT;
    [self.view insertSubview:newView atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didDestinyNavClickedAtIndex:(NSInteger)index {
    [self updateView:index+DESTINYNAV_BUDDHABOOK];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
