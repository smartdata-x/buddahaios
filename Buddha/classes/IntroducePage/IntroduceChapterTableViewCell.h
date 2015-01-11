//
//  IntroduceChapterTableViewCell.h
//  Buddha
//
//  Created by Archer_LJ on 15/1/10.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"

@interface migsIntroduceChapterInfo : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *index;

+ (migsIntroduceChapterInfo *)initWithDictionay:(NSDictionary *)dic;

@end

@interface IntroduceChapterTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *lblContent;

- (void)initWithContent:(NSString *)content;

@end
