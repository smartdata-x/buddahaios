//
//  ArtDisplayViewController.m
//  Buddha
//
//  Created by Archer_LJ on 15/1/11.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "ArtDisplayViewController.h"

@interface ArtDisplayViewController ()

@end

@implementation ArtDisplayViewController

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getArtFailed:) name:MigNetNameGetArtFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getArtSuccess:) name:MigNetNameGetArtSuccess object:nil];
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetArtFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetArtSuccess object:nil];
}

- (void)initialize:(NSString *)introid Title:(NSString *)title {
    
    introID = introid;
    titleName = title;
    
    [self getArt:introID];
    
#if MIG_DEBUG_TEST
#if 0
    titleName = @"艺术品展示";
    infoString = @"fdafddsafffffffffffff";
    imageName = @"";
    [self reloadData];
#endif
#endif
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (viewWrapper == nil) {
        
        viewWrapper = [[UIView alloc] initWithFrame:self.view.frame];
    }
    [self.view addSubview:viewWrapper];
    
    [self initView];
}

- (void)initView {
    
    [self initNavView];
    
    float originy = NAVIGATION_HEIGHT + 60 / SCREEN_SCALAR;
    [self initImageDisplayView:&originy];
    
    originy += 40 / SCREEN_SCALAR;
    [self initInfoView:&originy];
}

- (void)initNavView {
    
    [self.navigationItem setTitle:titleName];
}

- (void)initImageDisplayView:(float *)originY {
    
    float yStart = *originY;
    float height = 200;
    
    if (imageDisplayView == nil) {
        
        CGRect frame = CGRectMake(0, yStart, self.view.frame.size.width, height);
        imageDisplayView = [[EGOImageView alloc] initWithFrame:frame];
    }
    imageDisplayView.imageURL = [NSURL URLWithString:imageName];
    [viewWrapper addSubview:imageDisplayView];
    
    // 输出当前高度
    *originY += height;
}

- (void)initInfoView:(float *)originY {
    
    float yStart = *originY;
    float height = 160;
    
    if (infoView == nil) {
        
        CGRect frame = CGRectMake(40 / SCREEN_SCALAR, yStart, self.view.frame.size.width - 40, height);
        infoView = [[UILabel alloc] initWithFrame:frame];
        
        [infoView setTextAlignment:NSTextAlignmentLeft];
        [infoView setTextColor:[Utilities colorWithHex:0x5c5c5c]];
        [infoView setFont:[UIFont fontOfApp:22 / SCREEN_SCALAR]];
        [infoView setNumberOfLines:0];
    }
    [infoView setText:infoString];
    [viewWrapper addSubview:infoView];
}

- (void)getArt:(NSString *)introid {
    
    AskNetDataApi *api = [[AskNetDataApi alloc] init];
    [api doGetArt:introid];
}

- (void)getArtFailed:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取艺术品失败");
}

- (void)getArtSuccess:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取艺术品成功");
    
    NSDictionary *userinfo = notification.userInfo;
    NSDictionary *result = [userinfo objectForKey:@"result"];
    NSDictionary *summary = [result objectForKey:@"summary"];
    
    imageName = [summary objectForKey:@"pic"];
    infoString = [summary objectForKey:@"summary"];
    
    [self reloadData];
}

- (void)reloadData {
    
    [self initNavView];
    imageDisplayView.imageURL = [NSURL URLWithString:imageName];
    [infoView setText:infoString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
