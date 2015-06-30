//
//  PersonalCenterTableViewController.m
//  Buddha
//
//  Created by Archer_LJ on 15/6/29.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "PersonalCenterTableViewController.h"
#import "Stdinc.h"
#import "PersonalCenterHeaderTableViewCell.h"
#import "PersonalCenterStyle0TableViewCell.h"

@interface PersonalCenterTableViewController ()

@end

@implementation PersonalCenterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"个人中心"];
    [self.view setBackgroundColor:[Utilities colorWithHex:0xfff8f8f8]];
    
    // 左返回键
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(24, 0, 25.0 / SCREEN_SCALAR, 44.0 / SCREEN_SCALAR)];
    [backButton setBackgroundImage:[UIImage imageNamed:IMG_BACK_ARROW] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    // 去掉底部空cell
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (IBAction)doBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doJoin:(id)sender {
    
}

- (IBAction)doAdvise:(id)sender {
    
}

- (IBAction)doVersionCheck:(id)sender {
    
}

- (IBAction)doComment:(id)sender {
    
}

- (IBAction)doConcern:(id)sender {
    
}

- (IBAction)doAbout:(id)sender {
    
}
     
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 1; break;
        case 1: return 2; break;
        case 2: return 4; break;
        default: break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: return 108 / SCREEN_SCALAR; break;
        default: return 88.0 / SCREEN_SCALAR; break;
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 21.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 21)];
    [headerview setBackgroundColor:[UIColor clearColor]];
    return headerview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellname = nil;
    
    switch (indexPath.section) {
        case 0: cellname = @"PersonalCenterHeaderTableViewCell"; break;
        default: cellname = @"PersonalCenterStyle0TableViewCell"; break;
    }
    
    if (cellname != nil) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellname];
        
        if (cell == nil) {
            
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:cellname owner:self options:nil];
            cell = [nibContents objectAtIndex:0];
        }
    
        if (indexPath.section == 0) {
            PersonalCenterHeaderTableViewCell *headercell = (PersonalCenterHeaderTableViewCell *)cell;
            [headercell setData:@""];
        }
        else if (indexPath.section == 1) {
            NSArray *nameArray = [NSArray arrayWithObjects:@"意见反馈", @"版本检查", nil];
            PersonalCenterStyle0TableViewCell *stylecell = (PersonalCenterStyle0TableViewCell *)cell;
            [stylecell setData:[nameArray objectAtIndex:indexPath.row]];
        }
        else if (indexPath.section == 2) {
            NSArray *nameArray = [NSArray arrayWithObjects:@"去评分", @"关注我们", @"关于我们", @"版本号", nil];
            PersonalCenterStyle0TableViewCell *stylecell = (PersonalCenterStyle0TableViewCell *)cell;
            [stylecell setData:[nameArray objectAtIndex:indexPath.row]];
            [stylecell hideNavGo:YES];
        }
    
        return cell;
    }
    
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [self doJoin:nil];
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self doAdvise:nil];
        }
        else if (indexPath.row == 1) {
            [self doVersionCheck:nil];
        }
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self doComment:nil];
        }
        else if (indexPath.row == 1) {
            [self doConcern:nil];
        }
        else if (indexPath.row == 2) {
            [self doAbout:nil];
        }
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
