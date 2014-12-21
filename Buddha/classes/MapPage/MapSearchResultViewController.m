//
//  MapSearchResultViewController.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/20.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "MapSearchResultViewController.h"
#import "MapFeatureTableViewCell.h"
#import "MapViewController.h"
#import "MapBuidingInfoViewController.h"

@interface MapSearchResultViewController ()

@end

@implementation MapSearchResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTypeBuildingFailed:) name:MigNetNameSearchTypeBuildFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTypeBuildingSuccess:) name:MigNetNameSearchTypeBuildSuccess object:nil];
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameSearchTypeBuildFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameSearchTypeBuildSuccess object:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNav];
    [self initTopMenu];
    [self initTableView];
    [self initMiniMenu];
    
#if MIG_DEBUG_TEST
    [self testdata];
#endif
}

- (void)initNav {
    
    [self.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:IMG_BACK_ARROW]];
    self.navigationItem.title = @"搜索";
}

- (void)initTopMenu {
    
    float titleWidth = TOP_MENU_BUTTON_WIDTH;
    
    NSArray *bottomItemArray = @[@{KEY_NORMAL:IMG_ALLOW_UP,
                                   KEY_HILIGHT:IMG_ALLOW_UP,
                                   KEY_TITLE:@"附近",
                                   KEY_TITLE_WIDTH:[NSNumber numberWithFloat:titleWidth]
                                   },
                                 @{KEY_NORMAL:IMG_ALLOW_UP,
                                   KEY_HILIGHT:IMG_ALLOW_UP,
                                   KEY_TITLE:@"类别",
                                   KEY_TITLE_WIDTH:[NSNumber numberWithFloat:titleWidth]
                                   },
                                 @{KEY_NORMAL:IMG_ALLOW_UP,
                                   KEY_HILIGHT:IMG_ALLOW_UP,
                                   KEY_TITLE:@"智能",
                                   KEY_TITLE_WIDTH:[NSNumber numberWithFloat:titleWidth]
                                   }];
    
    if (_mTopMenu == nil) {
        
        CGRect menuFrame = CGRectMake(0, NAVIGATION_HEIGHT, self.view.frame.size.width, TOP_MENU_HEIGHT);
        
        CGSize imgSize = CGSizeMake(25 / SCREEN_SCALAR, 13 / SCREEN_SCALAR);
        _mTopMenu = [[HorizontalMenu alloc] initWithFrame:menuFrame ButtonItems:bottomItemArray buttonSize:imgSize ButtonType:HORIZONTALMENU_TYPE_BUTTON_LABEL_RIGHT];
    }
    _mTopMenu.delegate = self;
    
    [self.view addSubview:_mTopMenu];
}

- (void)initTableView {
    
    if (mBuildTableInfo == nil) {
        
        mBuildTableInfo = [[NSMutableArray alloc] init];
    }
    
    CGRect tableFrame = CGRectMake(0, NAVIGATION_HEIGHT + TOP_MENU_HEIGHT, self.view.frame.size.width, self.view.frame.size.height);
    
    if (mBuildTableView == nil) {
        
        mBuildTableView = [[UITableView alloc] initWithFrame:tableFrame];
    }
    
    [mBuildTableView setBackgroundColor:[UIColor clearColor]];
    mBuildTableView.delegate = self;
    mBuildTableView.dataSource = self;
    [self.view addSubview:mBuildTableView];
}

- (void)initMiniMenu {
    
    if (mNearbyMenu == nil) {
        
        mNearbyMenu = [[TwoPageMenuVIew alloc] init];
        mNearbyMenu.frame = CGRectMake(0, 0, self.view.frame.size.width, 558 / SCREEN_SCALAR);
        _isNearbyMenuShow = YES;
    }
    
    //[mNearbyMenu setHidden:YES];
    [self.view addSubview:mNearbyMenu];
}

- (void)reloadData {
    
    [mBuildTableView reloadData];
}

#if MIG_DEBUG_TEST
- (void)testdata {
    
    migsBuildingInfo *buildinfo = [[migsBuildingInfo alloc] init];
    buildinfo.headUrl = nil;
    buildinfo.name = @"万佛寺";
    buildinfo.address = @"我也不知道在哪里";
    buildinfo.distance = @"52km";
    
    [mBuildTableInfo addObject:buildinfo];
    
    [self reloadData];
}
#endif

- (void)getTypeBuildingFailed:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取建筑类型失败");
}

- (void)getTypeBuildingSuccess:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取建筑类型成功 :%@", notification);
    
    NSDictionary *userinfo = notification.userInfo;
    NSDictionary *result = [userinfo objectForKey:@"result"];
    NSDictionary *nearbuild = [result objectForKey:@"nearbuild"];
    
    for (NSDictionary *dic in nearbuild) {
        
        migsBuildingInfo *buildinfo = [migsBuildingInfo setupBuildingInfoFromDictionary:dic];
        
        [mBuildTableInfo addObject:buildinfo];
    }
    
    [self reloadData];
}

// HorizontalMenuDelegate
- (void)didHorizontalMenuClickedButttonAtIndex:(NSInteger)index Type:(NSInteger)type {
    
    if (type == HORIZONTALMENU_TYPE_BUTTON_LABEL_RIGHT) {
        
        if (index == 0) {
            
            [mNearbyMenu setHidden:NO];
        }
    }
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
        
        migsBuildingInfo *buildinfo = [mBuildTableInfo objectAtIndex:curRow];
        
        if (!buildinfo) {
            
            return nil;
        }
        
        [cell initCellWithData:buildinfo];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = indexPath.row;
    int allCount = [mBuildTableInfo count];
    
    if (allCount > 0 && allCount > row) {
        
        migsBuildingInfo *buildinfo = [mBuildTableInfo objectAtIndex:row];
        
        // 跳转到建筑详情
        MapBuidingInfoViewController *buildView = [[MapBuidingInfoViewController alloc] init];
        buildView.mParentMapView = self.mParentMapView;
        [buildView initialize:buildinfo];
        [self.navigationController pushViewController:buildView animated:YES];
        
    }
    
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
