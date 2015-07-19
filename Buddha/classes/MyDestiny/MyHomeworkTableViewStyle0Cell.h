//
//  MyHomeworkTableViewStyle0Cell.h
//  Buddha
//
//  Created by Archer_LJ on 15/7/18.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface MyHomeworkTableViewStyle0Cell : UITableViewCell

@property (nonatomic, retain) IBOutlet EGOImageView *imgCover;
@property (nonatomic, retain) IBOutlet UILabel *lblName;
@property (nonatomic, retain) IBOutlet UILabel *lblClass;
@property (nonatomic, retain) IBOutlet UILabel *lblCharge;

- (void)setData:(NSString *)cover name:(NSString *)name class:(NSString *)classes charge:(NSString *)charge;

@end
