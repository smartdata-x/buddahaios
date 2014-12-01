//
//  BaseViewController.m
//  Buddha
//
//  Created by Archer_LJ on 14/11/26.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        self.mFirstLoad = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    if (self.askApi == nil) {
        
        self.askApi = [[AskNetDataApi alloc] init];
    }
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
