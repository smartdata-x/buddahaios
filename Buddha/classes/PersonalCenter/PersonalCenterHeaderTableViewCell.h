//
//  PersonalCenterHeaderTableViewCell.h
//  Buddha
//
//  Created by Archer_LJ on 15/6/30.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EGOImageButton.h>

@interface PersonalCenterHeaderTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet EGOImageButton *avatar;

- (void)setData:(id)data;

@end
