//
//  MyBuddhaBookTableViewController.m
//  Buddha
//
//  Created by Archer_LJ on 15/7/16.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "MyBuddhaBookTableViewController.h"
#import "MyBuddhaBookTableViewStyle0Cell.h"

@interface MyBuddhaBookTableViewController ()

@end

@implementation MyBuddhaBookTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 去掉底部空cell
    self.tableView.tableFooterView = [[UIView alloc] init];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 143;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyBuddhaBookTableViewStyle0Cell"];
    
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"MyBuddhaBookTableViewStyle0Cell" owner:self options:nil];
        cell = [nibContents objectAtIndex:0];
    }
    
    if (cell) {
        MyBuddhaBookTableViewStyle0Cell *stylecell = (MyBuddhaBookTableViewStyle0Cell *)cell;
        [stylecell setData:@"" name:@"众生因缘法" author:@"谭彩庚" read:@"阅读:23K+" like:NO];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
