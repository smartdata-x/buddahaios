//
//  MapBuildMenuView.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/14.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "MapBuildMenuView.h"
#import "MapFeatureTableViewCell.h"
#import "MapViewController.h"
#import "MapBuidingInfoViewController.h"
#import "MapSearchResultViewController.h"

@implementation MapBuildMenuView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBuildingFailed:) name:MigNetNameGetRecomBuildFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBuildingSuccess:) name:MigNetNameGetRecomBuildSuccess object:nil];
        
        [self initBuildInfo];
        [self initTableInfo];
        
        // 背景设为不透明白色
        [self setBackgroundColor:[UIColor whiteColor]];
        
#if MIG_DEBUG_TEST
        migsBuildingInfo *build = [[migsBuildingInfo alloc] init];
        build.name = @"afjkdsafdsa";
        build.address = @"fafadsaf";
        build.distance = @"gfsdg";
        [mBuildTableInfo addObject:build];
        [self reloadTableData];
#endif
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetRecomBuildFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetRecomBuildSuccess object:nil];
}

- (void)initBuildInfo {
    
    NSArray *buildarray = @[@{KEY_TITLE:@"寺庙",
                              KEY_IMAGE:@"temple.png"},
                            
                            @{KEY_TITLE:@"书店",
                              KEY_IMAGE:@"book.png"},
                            
                            @{KEY_TITLE:@"素食馆",
                              KEY_IMAGE:@"food.png"},
                            
                            @{KEY_TITLE:@"佛具馆",
                              KEY_IMAGE:@"fojv.png"},
                            
                            @{KEY_TITLE:@"服装",
                              KEY_IMAGE:@"clothes.png"}];
    
    if (mBuildInfoArray == nil) {
        
        mBuildInfoArray = [[NSMutableArray alloc] init];
    }
    
    [mBuildInfoArray addObjectsFromArray:buildarray];
    
    // 排列图标
    float xstart = 20.0 / SCREEN_SCALAR;
    float ystart = 38.0 / SCREEN_SCALAR;
    float iconsize = 125.0 / SCREEN_SCALAR;
    float hSeperatespace = (self.frame.size.width - 20.0 / SCREEN_SCALAR * 2 - iconsize * 4) / 3.0;
    float vSeperatespace = 38.0 / SCREEN_SCALAR;
    float lableYSeperate = 14 / SCREEN_SCALAR;
    float lableheight = 20.0;
    
    for (int i=0; i<[mBuildInfoArray count]; i++) {
        
        int x = i % 4;
        int y = i / 4;
        float tmpX = xstart + (hSeperatespace + iconsize) * x;
        float tmpY = ystart + (vSeperatespace + iconsize + lableheight + lableYSeperate) * y;
        
        NSDictionary *dic = [mBuildInfoArray objectAtIndex:i];
        NSString *title = [dic objectForKey:KEY_TITLE];
        NSString *image = [dic objectForKey:KEY_IMAGE];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(tmpX, tmpY, iconsize, iconsize)];
        [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(doSearchAction:) forControlEvents:UIControlEventTouchUpInside];
        
        tmpY += iconsize + lableYSeperate;
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(tmpX, tmpY, iconsize, lableheight)];
        lable.text = title;
        lable.textColor = [UIColor blackColor];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont fontOfApp:20.0 / SCREEN_SCALAR];
        
        [self addSubview:button];
        [self addSubview:lable];
    }
    
    int row = ceil([mBuildInfoArray count] / 4.0);
    mTableStartY = ystart + row * (vSeperatespace + iconsize + lableheight + lableYSeperate);
}

- (void)initTableInfo {
    
    // 初始化数据
    if (mBuildTableInfo == nil) {
        
        mBuildTableInfo = [[NSMutableArray alloc] init];
    }
    
    // 初始化列表表头
    if (titleView == nil) {
        
        // 添加table的label
        UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(30 / SCREEN_SCALAR, 0, self.frame.size.width - 30 / SCREEN_SCALAR, SECTION_TITLE_HEIGHT)];
        lblHeader.text = @"推荐";
        lblHeader.textColor = [UIColor grayColor];
        lblHeader.font = [UIFont fontOfApp:20.0 / SCREEN_SCALAR];
        [lblHeader setBackgroundColor:[UIColor clearColor]];
        
        titleView = [[UIView alloc] initWithFrame:CGRectMake(0, mTableStartY, self.frame.size.width, SECTION_TITLE_HEIGHT)];
        [titleView setBackgroundColor:[UIColor colorWithRed:(246.0 / 255.0) green:(246.0 / 255.0) blue:(246.0 / 255.0) alpha:1.0]];
        [titleView addSubview:lblHeader];
    }
    
    [self addSubview:titleView];
    
    // 初始化列表
    if (mFeatureTableView == nil) {
        
        mFeatureTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.origin.x, mTableStartY + SECTION_TITLE_HEIGHT, self.frame.size.width, self.frame.size.height - mTableStartY)];
        mFeatureTableView.delegate = self;
        mFeatureTableView.dataSource = self;
    }
    
    [self addSubview:mFeatureTableView];
}

- (void)reloadTableData {
    
    [mFeatureTableView reloadData];
}

- (void)doBack {
    
    // 调用顶视图的隐藏, 并设置为路线菜单
    MapViewController *mapview = (MapViewController *)self.mParentMapView;
    mapview.isMainEntry = NO;
    [mapview updateBottomMenu];
    [mapview hideBuildMenu:YES];
}

- (void)doSearch:(NSString *)type {
    
    AskNetDataApi *askApi = [[AskNetDataApi alloc] init];
    [askApi doSearchTypeBuild:type];
}

- (IBAction)doSearchAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    NSString *type = [NSString stringWithFormat:@"%d", button.tag + 1]; // tag从0开始的，而type从1开始
    [self doSearch:type];
    
    // 跳转到搜索界面
    MapSearchResultViewController *searchView = [[MapSearchResultViewController alloc] init];
    searchView.mParentMapView = self.mParentMapView;
    [_mTopViewController.navigationController pushViewController:searchView animated:YES];
}

// 消息处理
- (void)getBuildingFailed:(NSNotification *)notification {
    
    [SVProgressHUD showErrorWithStatus:MIGTIP_GETBUILDING_FAILED];
}

- (void)getBuildingSuccess:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取推荐建筑成功 %@", notification);
    
    NSDictionary *userinfo = notification.userInfo;
    NSDictionary *result = [userinfo objectForKey:@"result"];
    NSDictionary *nearbuild = [result objectForKey:@"nearbuild"];
    
    for (NSDictionary *dic in nearbuild) {
        
        migsBuildingInfo *buildinfo = [migsBuildingInfo setupBuildingInfoFromDictionary:dic];
        
        [mBuildTableInfo addObject:buildinfo];
    }
    
    [self reloadTableData];
}

// UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [mBuildTableInfo count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 67;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int curRow = indexPath.row;
    
    NSString *cellIdentifier = @"MapFeatureTableViewCell";
    MapFeatureTableViewCell *cell = (MapFeatureTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (MapFeatureTableViewCell *)[nibContents objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if ([mBuildTableInfo count] <= 0) {
            
            return cell;
        }
        
        migsBuildingInfo *buildinfo = [mBuildTableInfo objectAtIndex:curRow];
        [cell initCellWithData:buildinfo];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = indexPath.row;
    int count = [mBuildTableInfo count];
    
    if (count > 0 && row < count) {
        
        migsBuildingInfo *buildinfo = [mBuildTableInfo objectAtIndex:row];
        
        // 跳转到建筑详情
        MapBuidingInfoViewController *buildView = [[MapBuidingInfoViewController alloc] init];
        [buildView initialize:buildinfo];
        buildView.mParentMapView = self.mParentMapView;
        
        [_mTopViewController.navigationController pushViewController:buildView animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
