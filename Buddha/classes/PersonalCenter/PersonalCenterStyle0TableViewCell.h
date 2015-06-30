//
//  PersonalCenterStyle0TableViewCell.h
//  Buddha
//
//  Created by Archer_LJ on 15/6/30.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalCenterStyle0TableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UIImageView *goimg;
@property (nonatomic, retain) IBOutlet UILabel *minorName;

- (void)setData:(id)data;
- (void)hideNavGo:(BOOL)hide;
- (void)setMinorData:(id)data;

@end
