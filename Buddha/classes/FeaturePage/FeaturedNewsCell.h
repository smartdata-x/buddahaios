//
//  FeaturedNewsCell.h
//  Buddha
//
//  Created by Archer_LJ on 14/11/22.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@interface FeaturedNewsCell : UITableViewCell<EGOImageButtonDelegate>

@property (nonatomic, assign) IBOutlet EGOImageButton *avatarImg;
@property (nonatomic, assign) IBOutlet UILabel *lblTitle;
@property (nonatomic, assign) IBOutlet UILabel *lblDetail;

@end
