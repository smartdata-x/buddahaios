//
//  FeaturedNewsCell.m
//  Buddha
//
//  Created by Archer_LJ on 14/11/22.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "FeaturedNewsCell.h"

@implementation FeaturedNewsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)imageButtonFailedToLoadImage:(EGOImageButton *)imageButton error:(NSError *)error {
    
    NSLog(@"failed load image");
}

- (void)imageButtonLoadedImage:(EGOImageButton *)imageButton {
    
    NSLog(@"load image succeed");
}

@end
