//
//  MapBuidingInfoViewController.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/17.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "MapBuidingInfoViewController.h"
#import "MapViewController.h"
#import "MapIconInfoTableViewCell.h"
#import "MapDetailInfoTableViewCell.h"

@interface MapBuidingInfoViewController ()

@end

@implementation MapBuidingInfoViewController

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        if (mBuildingInfo == nil) {
            
            mBuildingInfo = [[migsBuildingInfo alloc] init];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSummaryFailed:) name:MigNetNameGetSummaryFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSummarySuccess:) name:MigNetNameGetSummarySuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getActivitySummaryFailed:) name:MigNetNameGetActivitySummaryFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getActivitySummarySuccess:) name:MigNetNameGetActivitySummarySuccess object:nil];
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetSummaryFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetSummarySuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetActivitySummaryFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetActivitySummarySuccess object:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initNav];
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)initNav {
    
    // 导航键,分享
    CGRect viewFrame = CGRectMake(0, 0, 140, NAV_BAR_HEIGHT);
    UIView *viewWrapper = [[UIView alloc] initWithFrame:viewFrame];
    
    CGRect iconFrame = CGRectMake(160, 12, 42/SCREEN_SCALAR, 43/SCREEN_SCALAR);
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_SHARE_ICO]];
    iconView.frame = iconFrame;
    [viewWrapper addSubview:iconView];
    
    // 添加分享事件
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doSearchInMapView)];
    [viewWrapper addGestureRecognizer:gesture];
    
    self.navigationItem.titleView = viewWrapper;
    
    // 喜爱按钮
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(44, 0, 42/SCREEN_SCALAR, 43/SCREEN_SCALAR)];
    [btnRight setBackgroundImage:[UIImage imageNamed:IMG_FAV_ICO] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(doFav) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = item0;
}

- (void)initView {

    if (mMainTableView == nil) {
        
        CGRect tableframe = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        mMainTableView = [[UITableView alloc] initWithFrame:tableframe];
    }
    
    mMainTableView.dataSource = self;
    mMainTableView.delegate = self;
    mMainTableView.scrollEnabled = NO;
    
    [self.view addSubview:mMainTableView];
}

- (void)initialize:(migsBuildingInfo *)buildinfo PageType:(int)pageType {
    
    mBuildingInfo = buildinfo;
    _pageType = pageType;
    
    if (pageType == PAGETYPE_MAPBUILD) {
        
        [self getSummary];
    }
    else if (pageType == PAGETYPE_ACTIVITY) {
        
        [self getActivitySummary];
    }
    
    // 获取到值之后再更新一次
    [self reloadData];
}

- (void)reloadData {
    
    [mMainTableView reloadData];
}

- (void)doFav {
    
    
}

- (void)doShare {
    
    
}

- (void)doSearchInMapView {
    
    MapViewController *mapview = (MapViewController *)self.mParentMapView;
    
    if (mapview == nil) {
        
        // 如果mapview是空，则是活动页面跳转过来
        mapview = [[MapViewController alloc] init];
        mapview.topViewController = nil;
        
        // 扩大高度
        CGRect tmpRect = self.view.frame;;
        tmpRect.size.height += BOTTOM_MENU_BUTTON_HEIGHT;
        mapview.mFrame = tmpRect;
        
        // 隐藏navigation
        mapview.isHideNavagation = YES;
        mapview.fromWhichPage = FROMPAGE_ACTIVITY;
        
        [mapview viewDidLoad];
    }
    
    CLLocationCoordinate2D startLoc = [[MyLocationManager GetInstance] getLocation];
    CLLocationCoordinate2D endLoc = CLLocationCoordinate2DMake(mBuildingInfo.fLatitude, mBuildingInfo.fLongitude);
    
    // 存储本页的建筑详情
    mapview.mLastBuildingInfo = mBuildingInfo;
    mapview.mRouteSearchControl.mLastBuildingInfo = mBuildingInfo;
    
    // 主动调用地图显示
    if (_pageType == PAGETYPE_MAPBUILD) {
        
        [mapview viewWillAppear:YES];
    }
    
    // 切换地图的菜单模式
    mapview.isMainEntry = NO;
    [mapview updateBottomMenu];
    
    // 路线规划开始运作
    [mapview.mRouteSearchControl doRouteSearchByLastType:startLoc LocationEnd:endLoc];
    
    // 隐藏地图的推荐页
    [mapview hideBuildMenu:NO];
    
    // 如果是地图页面则返回地图页面
    // 如果是活动页面, TODO:
    if (_pageType == PAGETYPE_MAPBUILD) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (_pageType == PAGETYPE_ACTIVITY) {
        
        [self.navigationController pushViewController:mapview animated:YES];
    }
}

- (void)doCallPhoneNumber {
    
    NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@", mPhone];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phone]]];
    [self.view addSubview:callWebview];
}

- (void)getActivitySummary {
    
    AskNetDataApi *api = [[AskNetDataApi alloc] init];
    [api doGetActivitySummary:mBuildingInfo.buildId];
}

- (void)getActivitySummaryFailed:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取活动详情失败");
}

- (void)getActivitySummarySuccess:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取活动详情成功");
    
    NSDictionary *userinfo = notification.userInfo;
    NSDictionary *result = [userinfo objectForKey:@"result"];
    
    NSDictionary *summary = [result objectForKey:@"summary"];
    mPhone = [summary objectForKey:@"phone"];
    mDetailInfo = [summary objectForKey:@"summary"];
    
    NSDictionary *location = [result objectForKey:@"location"];
    float fLatitude = [[location objectForKey:@"latitude"] floatValue];
    float fLongitude = [[location objectForKey:@"longitude"] floatValue];
    NSString *latitude = [NSString stringWithFormat:@"%f", fLatitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", fLongitude];
    NSString *address = [location objectForKey:@"address"];
    mBuildingInfo.address = address;
    mBuildingInfo.latitude = latitude;
    mBuildingInfo.longitude = longitude;
    mBuildingInfo.fLatitude = fLatitude;
    mBuildingInfo.fLongitude = fLongitude;
    
    [self reloadData];
}

- (void)getSummary {
    
    AskNetDataApi *askApi = [[AskNetDataApi alloc] init];
    [askApi doGetSummary:mBuildingInfo.buildId];
}

- (void)getSummaryFailed:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取建筑详情失败");
}

- (void)getSummarySuccess:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取建筑详情成功 :%@", notification);
    
    NSDictionary *userinfo = notification.userInfo;
    NSDictionary *result = [userinfo objectForKey:@"result"];
    NSDictionary *dic = [result objectForKey:@"summary"];
    
    mPhone = [dic objectForKey:@"phone"];
    mDetailInfo = [dic objectForKey:@"summary"];
    [self reloadData];
}

// UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // 一个是主题，一个是描述
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        // 信息，地址，电话栏
        return 3;
    }
    else if (section == 1) {
        
        return 1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = indexPath.row;
    int section = indexPath.section;
    
    if (section == 0) {
        
        if (row == 0) {
            
            // 第一栏，如果是地图建筑，显示地图，如果是活动建筑，显示一张图
            if (_pageType == PAGETYPE_MAPBUILD) {
                
                return 67;
            }
            else if (_pageType == PAGETYPE_ACTIVITY) {
                
                return 224 / SCREEN_SCALAR;
            }
        }
        else {
         
            return 59;
        }
    }
    else if (section == 1) {
        
        return 200;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int curRow = indexPath.row;
    int curSec = indexPath.section;
    
    if (curSec == 0) {
        
        if (curRow == 0) {
        
            if (_pageType == PAGETYPE_MAPBUILD) {
                
                NSString *cellIdentifier = @"MapFeatureTableViewCell";
                MapFeatureTableViewCell *cell = (MapFeatureTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                if (cell == nil) {
                    
                    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
                    cell = (MapFeatureTableViewCell *)[nibContents objectAtIndex:0];
                    cell.backgroundColor = [UIColor clearColor];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    
                    if (!mBuildingInfo) {
                        
                        return nil;
                    }
                    
                    [cell initCellWithData:mBuildingInfo];
                }
                
                return cell;
            }
            else if (_pageType == PAGETYPE_ACTIVITY) {
                
                NSString *cellIdentifier = @"ActivityDetailTableViewCell";
                ActivityDetailTableViewCell *cell = (ActivityDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                if (cell == nil) {
                    
                    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
                    cell = (ActivityDetailTableViewCell *)[nibContents objectAtIndex:0];
                    cell.backgroundColor = [UIColor clearColor];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    
                    if (!mBuildingInfo) {
                        
                        return nil;
                    }
                    
                    [cell initialize:mBuildingInfo.headUrl];
                }
                
                return cell;
            }
        }
        else if (curRow == 1 || curRow == 2) {
            
            NSString *cellIdentifier = @"MapIconInfoTableViewCell";
            MapIconInfoTableViewCell *cell = (MapIconInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil) {
                
                NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
                cell = (MapIconInfoTableViewCell *)[nibContents objectAtIndex:0];
                cell.backgroundColor = [UIColor clearColor];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                if (curRow == 1) {
                    
                    cell.imgIcon.image = [UIImage imageNamed:IMG_LOCATION_ICO];
                    cell.imgArrow.image = [UIImage imageNamed:IMG_NEXT_ARROW];
                    cell.lblContent.text = mBuildingInfo.address;
                }
                else if (curRow == 2) {
                    
                    cell.imgIcon.image = [UIImage imageNamed:IMG_PHONE_ICO];
                    cell.imgArrow = nil;
                    cell.lblContent.text = mPhone;
                }
                
                cell.lblContent.font = [UIFont fontOfApp:24.0 / SCREEN_SCALAR];
                cell.lblContent.textColor = MIG_COLOR_111111;
            }
            
            return cell;
        }
    }
    else if (curSec == 1) {
        
        if (curRow == 0) {
            
            NSString *cellIdentifier = @"MapDetailInfoTableViewCell";
            MapDetailInfoTableViewCell *cell = (MapDetailInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil) {
                
                NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
                cell = (MapDetailInfoTableViewCell *)[nibContents objectAtIndex:0];
                cell.backgroundColor = [UIColor clearColor];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                cell.lblDetail.text = mDetailInfo;
                [cell.lblDetail setNumberOfLines:0];
                cell.lblDetail.font = [UIFont fontOfApp:22 / SCREEN_SCALAR];
                cell.lblDetail.textColor = MIG_COLOR_808080;
            }
            
            return cell;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = indexPath.row;
    int section = indexPath.section;
    
    if (section == 0) {
        
        if (row == 1) {
            
            [self doSearchInMapView];
        }
        else if (row == 2) {
            
            [self doCallPhoneNumber];
        }
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
