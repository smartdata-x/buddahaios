//
//  CustomNavView.h
//  Buddha
//
//  Created by Archer_LJ on 14/11/23.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"

@protocol CustomNavViewDelegate <NSObject>

@optional

- (void)didCustomNavViewClicked;

@end

@interface CustomNavView : UIView

@property (nonatomic, assign) id <CustomNavViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;

@end
