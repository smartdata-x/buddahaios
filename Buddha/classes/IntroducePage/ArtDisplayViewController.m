//
//  ArtDisplayViewController.m
//  Buddha
//
//  Created by Archer_LJ on 15/1/11.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "ArtDisplayViewController.h"
#import "UIImage+BlurredFrame.h"

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
    isFullScreen = YES;
    
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
    
    // 点击
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [Utilities setFullScreen:self.navigationController FullScreen:isFullScreen];
}

- (void)initView {
    
    [self initNavView];
    
    float originy = 0;
    [self initImageDisplayView:&originy];
    
    originy += 40 / SCREEN_SCALAR;
    [self initInfoView:&originy];
}

- (void)initNavView {
    
    [self.navigationItem setTitle:titleName];
}

- (void)initImageDisplayView:(float *)originY {
    
    // 全屏
    float yStart = *originY;
    float height = self.view.frame.size.height - yStart;
    
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
    
    // 信息从底部向上延伸
    float yStart = *originY;
    float height = 160;
    
    if (infoView == nil) {
        
        CGRect frame = CGRectMake(0, yStart, self.view.frame.size.width, height);
        infoView = [[UILabel alloc] initWithFrame:frame];
        
        [infoView setTextAlignment:NSTextAlignmentLeft];
        [infoView setTextColor:[UIColor whiteColor]];
        [infoView setFont:[UIFont fontOfApp:22 / SCREEN_SCALAR]];
        [infoView setNumberOfLines:0];
    }
    [infoView setText:infoString];
    [infoView setHidden:isFullScreen];
    [viewWrapper addSubview:infoView];
}

- (void)doTap:(UITapGestureRecognizer *)tapGesture {
    
    [self changeFullScreen];
}

- (void)changeFullScreen {
    
    isFullScreen = !isFullScreen;
    
    [infoView setHidden:isFullScreen];
    [Utilities setFullScreen:self.navigationController FullScreen:isFullScreen];
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
    
    // 重新计算infoview高度
    float maxheight = self.view.frame.size.height;
    CGRect orgframe = infoView.frame;
    CGRect maxframe = CGRectMake(0, 0, orgframe.size.width, maxheight);
    float stringheight = [Utilities heightForString:infoString Font:[UIFont fontOfApp:22/SCREEN_SCALAR] Frame:maxframe];
    float newYStart = self.view.frame.origin.y + self.view.frame.size.height - stringheight - 16;
    if (newYStart < 0) {
        
        newYStart = 0;
    }
    CGRect realframe = CGRectMake(orgframe.origin.x, newYStart, orgframe.size.width, stringheight + 16);
    infoView.frame = realframe;
    [infoView setHidden:isFullScreen];
    
    // 设置黑色透明背景色
    [infoView setBackgroundColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.7f]];
    
#if 0
    // 设置模糊背景色
    UIImage *bgImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
    CGRect bgFrame = CGRectMake(0, 0, realframe.size.width, realframe.size.height);
    UIImage *partBgImg = [Utilities getPartOfImage:bgImg Rect:bgFrame];
    CGRect imgFrame = CGRectMake(0, 0, partBgImg.size.width, partBgImg.size.height);
    partBgImg = [partBgImg applyLightEffectAtFrame:imgFrame];
    [infoView setBackgroundColor:[UIColor colorWithPatternImage:partBgImg]];
#endif
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
