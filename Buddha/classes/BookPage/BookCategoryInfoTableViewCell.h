//
//  BookCategoryInfoTableViewCell.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/28.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"
#import "EGOImageButton.h"
#import "BookIntroduceTableViewCell.h"

@interface BookCategoryInfoTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet EGOImageButton *avatarImg;
@property (nonatomic, retain) IBOutlet UILabel *lblName;
@property (nonatomic, retain) IBOutlet UILabel *lblDetail;

- (void)initialize:(migsBookIntroduce *)bookIntro;

@end
