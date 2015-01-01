//
//  GeneralShareView.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/28.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"

@protocol GeneralShareViewDelegate <NSObject>

@optional
- (void)didGeneralShareViewClicked:(NSInteger)index;

@end

@interface GeneralShareView : UIView

@property (nonatomic, retain) id<GeneralShareViewDelegate> delegate;

- (void)initView:(CGRect)frame;

- (IBAction)btnClicked:(id)sender;

@end
