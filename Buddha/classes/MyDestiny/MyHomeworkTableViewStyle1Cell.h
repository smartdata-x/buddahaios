//
//  MyHomeworkTableViewStyle1Cell.h
//  Buddha
//
//  Created by Archer_LJ on 15/7/18.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkView1.h"

@interface MyHomeworkTableViewStyle1Cell : UITableViewCell

@property (nonatomic, retain) HomeworkView1 *view0;
@property (nonatomic, retain) HomeworkView1 *view1;

- (void)setData0:(NSString *)cover name:(NSString *)name class:(NSString *)classes charge:(NSString *)charge;
- (void)setData1:(NSString *)cover name:(NSString *)name class:(NSString *)classes charge:(NSString *)charge;

@end
