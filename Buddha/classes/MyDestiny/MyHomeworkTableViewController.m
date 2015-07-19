//
//  MyHomeworkTableViewController.m
//  Buddha
//
//  Created by Archer_LJ on 15/7/18.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "MyHomeworkTableViewController.h"
#import "MyHomeworkTableViewStyle0Cell.h"
#import "MyHomeworkTableViewStyle1Cell.h"

@interface MyHomeworkTableViewController ()

@end

@implementation MyHomeworkTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 去掉底部空cell
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 117;
    }
    return 128;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellname = nil;
    if (indexPath.section == 0) {
        cellname = @"MyHomeworkTableViewStyle0Cell";
    }
    else {
        cellname = @"MyHomeworkTableViewStyle1Cell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellname];
    
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:cellname owner:self options:nil];
        cell = [nibContents objectAtIndex:0];
    }
    
    if (indexPath.section == 0) {
        MyHomeworkTableViewStyle0Cell *stylecell = (MyHomeworkTableViewStyle0Cell *)cell;
        [stylecell setData:@"" name:@"正信的佛教" class:@"12" charge:@"18K"];
    }
    else {
        MyHomeworkTableViewStyle1Cell *stylecell = (MyHomeworkTableViewStyle1Cell *)cell;
        [stylecell setData0:@"" name:@"正信的佛教" class:@"12" charge:@"18K"];
        [stylecell setData1:@"" name:@"正信的佛教" class:@"12" charge:@"18K"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
