//
//  ActivityDetailTableViewCell.h
//  Buddha
//
//  Created by Archer_LJ on 15/1/6.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"
#import "EGOImageButton.h"

@interface ActivityDetailTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet EGOImageButton *avatarImg;

- (void)initialize:(NSString *)imagename;

@end
