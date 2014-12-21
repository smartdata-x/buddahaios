//
//  TwoPageMenuVIew.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/21.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "TwoPageMenuVIew.h"
#import "LeftMenuTableViewCell.h"
#import "RightMenuTableViewCell.h"

@implementation TwoPageMenuVIew

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        float leftX = 0;
        float leftY = 0;
        float leftWidth = 134;
        float leftHeight = 558 / SCREEN_SCALAR;
        
        float rightX = leftWidth;
        float rightY = leftY;
        float rightWidth = 186;
        float rightHeight = leftHeight;
        
        _leftMenu = [[UITableView alloc] initWithFrame:CGRectMake(leftX, leftY, leftWidth, leftHeight)];
        _leftMenu.delegate = self;
        _leftMenu.dataSource = self;
        
        _rightMenu = [[UITableView alloc] initWithFrame:CGRectMake(rightX, rightY, rightWidth, rightHeight)];
        _rightMenu.delegate = self;
        _rightMenu.dataSource = self;
    }
    
    return self;
}


// UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _leftMenu) {
        
        return 6;
    }
    else if (tableView == _rightMenu) {
        
        return 6;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _leftMenu) {
        
        NSString *cellIdentifier = @"LeftMenuTableViewCell";
        LeftMenuTableViewCell *cell = (LeftMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = (LeftMenuTableViewCell *)[nibContents objectAtIndex:0];
            cell.backgroundColor = [UIColor clearColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            cell.lblContent.text = @"附近";
            cell.lblContent.textColor = [UIColor blackColor];
            cell.lblContent.textAlignment = NSTextAlignmentLeft;
        }
        
        return cell;
    }
    else if (tableView == _rightMenu) {
        
        NSString *cellIdentifier = @"RightMenuTableViewCell";
        RightMenuTableViewCell *cell = (RightMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = (RightMenuTableViewCell *)[nibContents objectAtIndex:0];
            cell.backgroundColor = [UIColor clearColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            cell.lblContent.text = @"1000米";
            cell.lblContent.textColor = [UIColor blackColor];
            cell.lblContent.textAlignment = NSTextAlignmentLeft;
        }
        
        return cell;
    }
    
    return nil;
}

@end
