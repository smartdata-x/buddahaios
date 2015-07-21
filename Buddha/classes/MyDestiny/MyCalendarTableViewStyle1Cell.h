//
//  MyCalendarTableViewStyle1Cell.h
//  Buddha
//
//  Created by Archer_LJ on 15/7/21.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCalendarTableViewStyle1Cell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *imgHead;
@property (nonatomic, retain) IBOutlet UILabel *lblName;

- (void)setData:(NSString *)name cando:(BOOL)canDo;

@end
