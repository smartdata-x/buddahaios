//
//  HomeworkView1.h
//  Buddha
//
//  Created by Archer_LJ on 15/7/19.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface HomeworkView1 : UIView

@property (nonatomic, retain) EGOImageView *imgCover;
@property (nonatomic, retain) UILabel *lblName;
@property (nonatomic, retain) UILabel *lblClass;
@property (nonatomic, retain) UILabel *lblCharge;

- (void)setData:(NSString *)cover name:(NSString *)name class:(NSString *)classes charge:(NSString *)charge;

@end
