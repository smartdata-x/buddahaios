//
//  BookInfoTableViewCell.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/26.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"
#import "EGOImageButton.h"

@interface migsBookList : NSObject

@property (nonatomic, retain) NSString *bookid0;
@property (nonatomic, retain) NSString *booktype0;
@property (nonatomic, retain) NSString *summary0;
@property (nonatomic, retain) NSString *imgURL0;
@property (nonatomic, retain) NSString *name0;

@property (nonatomic, retain) NSString *bookid1;
@property (nonatomic, retain) NSString *booktype1;
@property (nonatomic, retain) NSString *summary1;
@property (nonatomic, retain) NSString *imgURL1;
@property (nonatomic, retain) NSString *name1;

@property (nonatomic, retain) NSString *bookid2;
@property (nonatomic, retain) NSString *booktype2;
@property (nonatomic, retain) NSString *summary2;
@property (nonatomic, retain) NSString *imgURL2;
@property (nonatomic, retain) NSString *name2;

+ (migsBookList *)setupBookListByDictionary:(NSDictionary *)dicGroup;

@end

@interface BookInfoTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet EGOImageButton *avatarBook0;
@property (nonatomic, retain) IBOutlet EGOImageButton *avatarBook1;
@property (nonatomic, retain) IBOutlet EGOImageButton *avatarBook2;
@property (nonatomic, retain) IBOutlet UILabel *lblBook0;
@property (nonatomic, retain) IBOutlet UILabel *lblBook1;
@property (nonatomic, retain) IBOutlet UILabel *lblBook2;


- (void)initialize:(migsBookList *)bookinfo;

@end
