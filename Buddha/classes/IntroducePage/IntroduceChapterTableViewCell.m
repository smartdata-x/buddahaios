//
//  IntroduceChapterTableViewCell.m
//  Buddha
//
//  Created by Archer_LJ on 15/1/10.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "IntroduceChapterTableViewCell.h"

@implementation migsIntroduceChapterInfo

+ (migsIntroduceChapterInfo *)initWithDictionay:(NSDictionary *)dic {
    
    if (dic == nil) {
        
        return nil;
    }
    
    int nIndex = [[dic objectForKey:@"index"] intValue];
    NSString *name = [dic objectForKey:@"name"];
    NSString *url = [dic objectForKey:@"url"];
    NSString *index = [NSString stringWithFormat:@"%d", nIndex];
    
    migsIntroduceChapterInfo *info = [[migsIntroduceChapterInfo alloc] init];
    info.name = name;
    info.url = url;
    info.index = index;
    
    return info;
}

@end

@implementation IntroduceChapterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithContent:(NSString *)content {
    
    [_lblContent setText:content];
    [_lblContent setTextAlignment:NSTextAlignmentLeft];
    [_lblContent setTextColor:MIG_COLOR_111111];
    [_lblContent setFont:[UIFont fontOfApp:28 / SCREEN_SCALAR]];
}

@end
