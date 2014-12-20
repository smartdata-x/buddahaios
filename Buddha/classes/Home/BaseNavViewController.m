//
//  BaseNavViewController.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/17.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "BaseNavViewController.h"

@interface BaseNavViewController ()

@end

@implementation BaseNavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        
        [self initNavigationView];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)initNavigationView {
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:83.0/255.0 green:100.0/255.0 blue:94.0/255.0 alpha:1.0]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    
    // 返回按钮
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 14, 17)];
    [leftButton setBackgroundImage:[UIImage imageNamed:IMG_BACK_ARROW] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (IBAction)doBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
