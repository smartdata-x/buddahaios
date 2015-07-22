//
//  MyCalendarTableViewStyle2Cell.h
//  Buddha
//
//  Created by Archer_LJ on 15/7/22.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCalendarTableViewStyle2Cell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *lblName;

- (void)setData:(NSString *)name bigversion:(BOOL)big;

@end
