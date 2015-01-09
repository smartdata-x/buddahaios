//
//  ActivityTableViewCell.h
//  Buddha
//
//  Created by Archer_LJ on 15/1/6.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"
#import "EGOImageButton.h"

@interface ActivityTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet EGOImageButton *avatarImg;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UILabel *lblDetail;

- (void)initialize:(migsImgWithTitleAndDetail *)infos;

@end
