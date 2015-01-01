//
//  BookInfoTableViewCell.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/26.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "BookInfoTableViewCell.h"

@implementation migsBookList

+ (migsBookList *)setupBookListByDictionary:(NSDictionary *)dicGroup {
    
    int i = 0;
    migsBookList *booklist = [[migsBookList alloc] init];
    
    for (NSDictionary *dic in dicGroup) {
        
        int nid = [[dic objectForKey:@"id"] intValue];
        int ntype = [[dic objectForKey:@"type"] intValue];
        
        NSString *name = [dic objectForKey:@"name"];
        NSString *pic = [dic objectForKey:@"pic"];
        NSString *summary = [dic objectForKey:@"summary"];
        NSString *bookid = [NSString stringWithFormat:@"%d", nid];
        NSString *booktype = [NSString stringWithFormat:@"%d", ntype];
        
        if (i == 0) {
            
            booklist.name0 = name;
            booklist.imgURL0 = pic;
            booklist.bookid0 = bookid;
            booklist.booktype0 = booktype;
            booklist.summary0 = summary;
        }
        else if (i == 1) {
            
            booklist.name1 = name;
            booklist.imgURL1 = pic;
            booklist.bookid1 = bookid;
            booklist.booktype1 = booktype;
            booklist.summary1 = summary;
        }
        else if (i == 2) {
            
            booklist.name2 = name;
            booklist.imgURL2 = pic;
            booklist.bookid2 = bookid;
            booklist.booktype2 = booktype;
            booklist.summary2 = summary;
        }
        
        i++;
    }
    
    return booklist;
}

@end

@implementation BookInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initialize:(migsBookList *)bookinfo {
    
    _avatarBook0.imageURL = [NSURL URLWithString:bookinfo.imgURL0];
    _lblBook0.text = bookinfo.name0;
    [_lblBook0 setTextColor:MIG_COLOR_808080];
    [_lblBook0 setTextAlignment:NSTextAlignmentCenter];
    [_lblBook0 setFont:[UIFont fontOfApp:28 / SCREEN_SCALAR]];
    
    _avatarBook1.imageURL = [NSURL URLWithString:bookinfo.imgURL1];
    _lblBook1.text = bookinfo.name1;
    [_lblBook1 setTextColor:MIG_COLOR_808080];
    [_lblBook1 setTextAlignment:NSTextAlignmentCenter];
    [_lblBook1 setFont:[UIFont fontOfApp:28 / SCREEN_SCALAR]];
    
    _avatarBook2.imageURL = [NSURL URLWithString:bookinfo.imgURL2];
    _lblBook2.text = bookinfo.name2;
    [_lblBook2 setTextColor:MIG_COLOR_808080];
    [_lblBook2 setTextAlignment:NSTextAlignmentCenter];
    [_lblBook2 setFont:[UIFont fontOfApp:28 / SCREEN_SCALAR]];
}

@end
