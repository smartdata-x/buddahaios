//
//  BookIntroduceTableViewCell.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/26.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "BookIntroduceTableViewCell.h"

@implementation migsBookIntroduce

+ (migsBookIntroduce *)setupBookIntroduceByDictionary:(NSDictionary *)dic {
    
    int nid = [[dic objectForKey:@"id"] intValue];
    int ntype = [[dic objectForKey:@"type"] intValue];
    
    NSString *name = [dic objectForKey:@"name"];
    NSString *pic = [dic objectForKey:@"pic"];
    NSString *summary = [dic objectForKey:@"summary"];
    NSString *bookid = [NSString stringWithFormat:@"%d", nid];
    NSString *booktype = [NSString stringWithFormat:@"%d", ntype];
    
    migsBookIntroduce *bookintro = [[migsBookIntroduce alloc] init];
    bookintro.bookid = bookid;
    bookintro.booktype = booktype;
    bookintro.name = name;
    bookintro.imgUrl = pic;
    bookintro.introduce = summary;
    
    return bookintro;
}

@end

@implementation BookIntroduceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initialize:(migsBookIntroduce *)bookIntro {
    
    _avatarImg.imageURL = [NSURL URLWithString:bookIntro.imgUrl];
    
    _lblName.text = bookIntro.name;
    [_lblName setTextColor:MIG_COLOR_111111];
    [_lblName setFont:[UIFont fontOfApp:30 / SCREEN_SCALAR]];
    [_lblName setTextAlignment:NSTextAlignmentLeft];
    
    _lblIntroduce.text = bookIntro.introduce;
    [_lblIntroduce setTextAlignment:NSTextAlignmentLeft];
    [_lblIntroduce setNumberOfLines:0];
    [_lblIntroduce setFont:[UIFont fontOfApp:22 / SCREEN_SCALAR]];
    [_lblIntroduce setTextColor:MIG_COLOR_808080];
}

@end
