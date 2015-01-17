//
//  CenterBaseViewController.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/3.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "CenterBaseViewController.h"

@interface CenterBaseViewController ()

@end

@implementation CenterBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nil bundle:nibBundleOrNil];
    
    if (self) {
        
        //
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 修改导航栏的背景色
    //[self.navigationController.navigationBar setBarTintColor:MIG_COLOR_53645E];
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    // 导航栏的标题栏
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, NAV_BAR_HEIGHT)];
    lblTitle.text = _titleText;
    lblTitle.font = [UIFont fontOfApp:32.0 / SCREEN_SCALAR];
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lblTitle;
    
    // 左返回键
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(24, 0, 25.0 / SCREEN_SCALAR, 44.0 / SCREEN_SCALAR)];
    [backButton setBackgroundImage:[UIImage imageNamed:IMG_BACK_ARROW] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    // 右边键
    self.navigationItem.rightBarButtonItem = nil;
    
    mMainFrame = CGRectMake(0, self.view.frame.origin.y + NAV_BAR_HEIGHT + 20, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)doBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
