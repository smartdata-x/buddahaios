//
//  FeaturedActivitiesCell.h
//  Buddha
//
//  Created by Archer_LJ on 14/11/22.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@interface FeaturedActivitiesCell : UITableViewCell

@property (nonatomic, assign) IBOutlet EGOImageButton *avatarActivity0;
@property (nonatomic, assign) IBOutlet EGOImageButton *avatarActivity1;
@property (nonatomic, assign) IBOutlet EGOImageButton *avatarActivity2;

@property (nonatomic, assign) IBOutlet UILabel *lblActivity0;
@property (nonatomic, assign) IBOutlet UILabel *lblActivity1;
@property (nonatomic, assign) IBOutlet UILabel *lblActivity2;

@end
