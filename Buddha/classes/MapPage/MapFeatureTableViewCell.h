//
//  MapFeatureTableViewCell.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/12.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@interface MapFeatureTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet EGOImageButton *avatarImg;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UILabel *lblDetail;
@property (nonatomic, retain) IBOutlet UILabel *lblDistance;

@end
