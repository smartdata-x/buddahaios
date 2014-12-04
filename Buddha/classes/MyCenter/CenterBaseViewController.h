//
//  CenterBaseViewController.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/3.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stdinc.h"

@interface CenterBaseViewController : UIViewController
{
    CGRect mMainFrame;
}

@property (nonatomic, retain) NSString *titleText;

- (IBAction)doBack:(id)sender;

@end
