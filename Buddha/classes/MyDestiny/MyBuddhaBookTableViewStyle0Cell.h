//
//  MyBuddhaBookTableViewStyle0Cell.h
//  Buddha
//
//  Created by Archer_LJ on 15/7/18.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@interface MyBuddhaBookTableViewStyle0Cell : UITableViewCell

@property (nonatomic, retain) IBOutlet EGOImageButton *avatar;
@property (nonatomic, retain) IBOutlet UILabel *lblName;
@property (nonatomic, retain) IBOutlet UILabel *lblAuthor;
@property (nonatomic, retain) IBOutlet UILabel *lblRead;
@property (nonatomic, retain) IBOutlet UIImageView *imgLike;

- (void)setData:(NSString *)avatar name:(NSString *)name author:(NSString *)author read:(NSString *)read like:(BOOL)like;

@end
