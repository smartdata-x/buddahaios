//
//  BookIntroduceTableViewCell.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/26.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"
#import "EGOImageButton.h"

@interface migsBookIntroduce : NSObject

@property (nonatomic, retain) NSString *imgUrl;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *introduce;
@property (nonatomic, retain) NSString *bookid;
@property (nonatomic, retain) NSString *booktype;

+ (migsBookIntroduce *)setupBookIntroduceByDictionary:(NSDictionary *)dic;

@end

@interface BookIntroduceTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet EGOImageButton *avatarImg;
@property (nonatomic, retain) IBOutlet UILabel *lblName;
@property (nonatomic, retain) IBOutlet UILabel *lblIntroduce;

- (void)initialize:(migsBookIntroduce *)bookIntro;

@end
