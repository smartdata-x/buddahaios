//
//  ActivityViewController.m
//  Buddha
//
//  Created by Archer_LJ on 15/1/6.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityTableViewCell.h"
#import "MapBuidingInfoViewController.h"
#import "RootViewController.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getActivityFailed:) name:MigNetNameGetActivityFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getActivitySuccess:) name:MigNetNameGetActivitySuccess object:nil];
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetActivityFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetActivitySuccess object:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (topActivityInfo == nil) {
        
        topActivityInfo = [[NSMutableArray alloc] init];
    }
    
    if (otherActTableInfo == nil) {
        
        otherActTableInfo = [[NSMutableArray alloc] init];
    }
    
    [self initView];
}

- (void)initView {
    
    float ystart = NAVIGATION_HEIGHT + 32;
    
    [self initClassicView:0.0];
    ystart += 196 / SCREEN_SCALAR + 20;
    
    [self initTableView:ystart];
}

#if 0
- (void)initTopActivityView:(float)ystart {
    
    float actWidth = (self.mFrame.size.width - 24 - 5) / 2;
    float actHeight = 196 / SCREEN_SCALAR;
    
    NSMutableArray *topActivityArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[topActivityInfo count]; i++) {
        
        migsImgWithTitleAndDetail *infodata = (migsImgWithTitleAndDetail *)([topActivityInfo objectAtIndex:i]);
        NSString *imgName = infodata.imgName;
        NSString *titleName = infodata.imgTitle;
        NSString *formatName = [NSString stringWithFormat:@"\n\n%@", titleName];
        
        NSArray *oneitem = @[@{KEY_NORMAL:imgName,
                               KEY_HILIGHT:imgName,
                               KEY_TITLE:formatName,
                               KEY_TITLE_WIDTH:[NSNumber numberWithFloat:actWidth]}];
        [topActivityArray addObjectsFromArray:oneitem];
    }
    
    if ([topActivityArray count] <= 0) {
        
        return;
    }
    
    // 初始化顶部菜单
    if (topActivityView != nil) {
        
        [topActivityView removeFromSuperview];
    }
    
    CGRect menuFrame = CGRectMake(24 / SCREEN_SCALAR, ystart + 32 / SCREEN_SCALAR, actWidth * 2, actHeight);
    CGSize btnImaSize = CGSizeMake(0, 0);
    
    topActivityView = [[HorizontalMenu alloc] initWithFrame:menuFrame ButtonItems:topActivityArray buttonSize:btnImaSize ButtonType:HORIZONTALMENU_TYPE_BUTTON];
    topActivityView.delegate = self;
    
    [self.view addSubview:topActivityView];
}
#endif

- (void)initClassicView:(float)ystart {
    
    if (topActivityInfo == nil || [topActivityInfo count] <= 0) {
        
        return;
    }
    
    if (classicWrapper != nil) {
        
        // 如果不是空，删除所有子视图，重新加载
        [classicWrapper removeFromSuperview];
    }
        
    classicWrapper = [[UIView alloc] initWithFrame:self.mFrame];
    [self.view addSubview:classicWrapper];
    
    [classicWrapper setBackgroundColor:[UIColor clearColor]];
    NSMutableArray *topActivityArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[topActivityInfo count]; i++) {
        
        migsImgWithTitleAndDetail *infodata = (migsImgWithTitleAndDetail *)([topActivityInfo objectAtIndex:i]);
        NSString *imgName = infodata.imgName;
        NSString *titleName = infodata.imgTitle;
        NSString *formatName = [NSString stringWithFormat:@"\n\n%@", titleName];
        
        NSArray *oneitem = @[@{KEY_IMAGE:imgName,
                               KEY_TITLE:formatName}];
        [topActivityArray addObjectsFromArray:oneitem];
    }
    
    if ([topActivityArray count] <= 0) {
        
        return;
    }
    
    // 排列图标
    float initGap = 24;
    float actWidth = (self.mFrame.size.width - 24 - 5) / 2;
    float actHeight = 196 / SCREEN_SCALAR;
    float xstart = initGap / SCREEN_SCALAR;
    float hSeperatespace = 10 / SCREEN_SCALAR;
    float vSeperatespace = 32 / SCREEN_SCALAR;
    ystart += 16 / SCREEN_SCALAR;
    
    for (int i=0; i<[topActivityArray count]; i++) {
        
        int x = i % 2;
        int y = i / 2;
        float tmpX = xstart + (hSeperatespace + actWidth) * x;
        float tmpY = ystart + (vSeperatespace + actHeight) * y;
        
        NSDictionary *dic = [topActivityArray objectAtIndex:i];
        NSString *image = [dic objectForKey:KEY_IMAGE];
        
        EGOImageButton *button = [[EGOImageButton alloc] initWithFrame:CGRectMake(tmpX, tmpY, actWidth, actHeight)];
        button.imageURL = [NSURL URLWithString:image];
        button.tag = i;
        [button addTarget:self action:@selector(doGotoBuildingView:) forControlEvents:UIControlEventTouchUpInside];
        
        [classicWrapper addSubview:button];
    }
    
    classicWrapper.frame = CGRectMake(self.mFrame.origin.x, self.mFrame.origin.y, self.mFrame.size.width, actHeight + 32);
}

- (void)initTableView:(float)ystart {
    
    // 初始化列表表头
    if (titleView == nil) {
        
        // 添加table的label
        UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(30 / SCREEN_SCALAR, 0, self.mFrame.size.width - 30 / SCREEN_SCALAR, SECTION_TITLE_HEIGHT)];
        lblHeader.text = @"其他活动";
        lblHeader.textColor = [UIColor grayColor];
        lblHeader.font = [UIFont fontOfApp:20.0 / SCREEN_SCALAR];
        [lblHeader setBackgroundColor:[UIColor clearColor]];
        
        titleView = [[UIView alloc] initWithFrame:CGRectMake(0, ystart, self.mFrame.size.width, SECTION_TITLE_HEIGHT)];
        [titleView setBackgroundColor:MIG_COLOR_F6F6F6];
        [titleView addSubview:lblHeader];
        [self.view addSubview:titleView];
    }
    
    if (otherActTableInfo == nil) {
        
        otherActTableInfo = [[NSMutableArray alloc] init];
    }
    
    if (otherActTableView == nil) {
        
        float topHeight = (196 + 32) / SCREEN_SCALAR;
        CGRect frame = CGRectMake(0, ystart + SECTION_TITLE_HEIGHT, self.mFrame.size.width, self.mFrame.size.height - topHeight - SECTION_TITLE_HEIGHT);
        otherActTableView = [[UITableView alloc] initWithFrame:frame];
        
        otherActTableView.dataSource = self;
        otherActTableView.delegate = self;
        [self.view addSubview:otherActTableView];
    }
}

- (void)reloadData {
    
    [otherActTableView reloadData];
}

- (void)getActivityFailed:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取活动失败");
}

- (void)getActivitySuccess:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取活动成功");
    
    NSDictionary *userinfo = notification.userInfo;
    NSDictionary *result = [userinfo objectForKey:@"result"];
    
    NSDictionary *recomm = [result objectForKey:@"recomm"];
    if ([recomm count] > 0) {
        
        [topActivityInfo removeAllObjects];
    }
    for (NSDictionary *dic in recomm) {
        
        migsImgWithTitleAndDetail *detail = [migsImgWithTitleAndDetail initByDic:dic];
        [topActivityInfo addObject:detail];
    }
    
    NSDictionary *common = [result objectForKey:@"common"];
    if ([common count] > 0) {
        
        [otherActTableInfo removeAllObjects];
    }
    for (NSDictionary *dic in common) {
        
        migsImgWithTitleAndDetail *detail = [migsImgWithTitleAndDetail initByDic:dic];
        [otherActTableInfo addObject:detail];
    }
    
    [self initView];
    [self reloadData];
}

- (IBAction)doGotoBuildingView:(id)sender {
    
    migsImgWithTitleAndDetail *detailinfo = nil;
    
    if (sender == nil) {
        
        // 从cell调用
        detailinfo = choosedInfo;
    }
    else {
        
        // 从顶部菜单调用
        EGOImageButton *button = (EGOImageButton *)sender;
        int curTag = button.tag;
        
        detailinfo = [topActivityInfo objectAtIndex:curTag];
    }
    
    if (detailinfo == nil) {
        
        return;
    }
    
    // 先切换rootview到地图页面
    RootViewController *rootView = (RootViewController *)self.topViewController;
    //[rootView doUpdateView:ROOTVIEWTAG_MAP];
    
    migsBuildingInfo *build = [[migsBuildingInfo alloc] init];
    build.name = detailinfo.imgTitle;
    build.headUrl = detailinfo.imgName;
    build.detailInfo = detailinfo.imgDetail;
    build.buildId = detailinfo.ID;
    build.buildType = detailinfo.type;
    
    MapBuidingInfoViewController *buildinfo = [[MapBuidingInfoViewController alloc] init];
    [buildinfo initialize:build PageType:PAGETYPE_ACTIVITY];
    
    [rootView.navigationController pushViewController:buildinfo animated:YES];
}

// UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 106;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [otherActTableInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = indexPath.row;
    
    NSString *cellIdentifier = @"ActivityTableViewCell";
    ActivityTableViewCell *cell = (ActivityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (ActivityTableViewCell *)[nibContents objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if ([otherActTableInfo count] <= 0) {
            
            return nil;
        }
        
        migsImgWithTitleAndDetail *bookIntro = [otherActTableInfo objectAtIndex:row];
        [cell initialize:bookIntro];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 响应事件
    int row = indexPath.row;
    migsImgWithTitleAndDetail *detailinfo = [otherActTableInfo objectAtIndex:row];
    choosedInfo = detailinfo;
    
    [self doGotoBuildingView:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
