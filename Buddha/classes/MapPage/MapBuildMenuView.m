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

@implementation MapBuildMenuView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initBuildInfo];
        [self initTableInfo];
        
        // test
        [self datatest];
        
        // 背景设为不透明白色
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
    return self;
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
        // TODO: 添加响应事件
        // test
        [button addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
        
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
    if (mInfoImage == nil) {
        
        mInfoImage = [[NSMutableArray alloc] init];
    }
    
    if (mInfoTitle == nil) {
        
        mInfoTitle = [[NSMutableArray alloc] init];
    }
    
    if (mInfoDetail == nil) {
        
        mInfoDetail = [[NSMutableArray alloc] init];
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

// test
- (void)datatest {
    
    NSArray *img = [[NSArray alloc] initWithObjects:@"book.png", @"book.png", @"book.png", nil];
    [mInfoImage addObjectsFromArray:img];
    
    NSArray *title = [[NSArray alloc] initWithObjects:@"hehe", @"haha", @"xixi", nil];
    [mInfoTitle addObjectsFromArray:title];
    
    NSArray *detail = [[NSArray alloc] initWithObjects:@"this", @"that", @"there", nil];
    [mInfoDetail addObjectsFromArray:detail];
    
    NSArray *dis = [[NSArray alloc] initWithObjects:@"1.0km", @"4.2km", @"2.5km", nil];
    [mInfoDistance addObjectsFromArray:dis];
    
    [self reloadTableData];
}

- (void)doBack {
    
    // 调用顶视图的隐藏, 并设置为路线菜单
    MapViewController *mapview = (MapViewController *)self.mTopMapView;
    mapview.isMainEntry = NO;
    [mapview updateBottomMenu];
    [mapview hideBuildMenu:YES];
}

// UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
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
        
        NSString *imageName = [mInfoImage objectAtIndex:curRow];
        NSString *title = [mInfoTitle objectAtIndex:curRow];
        NSString *detail = [mInfoDetail objectAtIndex:curRow];
        NSString *distance = [mInfoDistance objectAtIndex:curRow];
        
        // 图片
        //cell.avatarImg.imageURL = [NSURL URLWithString:imageName];
        cell.avatarImg.placeholderImage = [UIImage imageNamed:imageName];
        
        // 标题
        float titlecolor = 0.067;
        cell.lblTitle.text = title;
        cell.lblTitle.textAlignment = NSTextAlignmentLeft;
        cell.lblTitle.textColor = [UIColor colorWithRed:titlecolor green:titlecolor blue:titlecolor alpha:1.0];
        cell.lblTitle.font = [UIFont fontOfApp:30.0 / SCREEN_SCALAR];
        
        // 细节
        float detailcolor = 0.5;
        cell.lblDetail.text = detail;
        cell.lblDetail.textAlignment = NSTextAlignmentLeft;
        cell.lblDetail.textColor = [UIColor colorWithRed:detailcolor green:detailcolor blue:detailcolor alpha:1.0];
        cell.lblDetail.font = [UIFont fontOfApp:24.0 / SCREEN_SCALAR];
        
        // 距离
        cell.lblDistance.text = distance;
        cell.lblDistance.textAlignment = NSTextAlignmentRight;
        cell.lblDistance.textColor = [UIColor colorWithRed:detailcolor green:detailcolor blue:detailcolor alpha:1.0];
        cell.lblDistance.font = [UIFont fontOfApp:24.0 / SCREEN_SCALAR];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // TODO: 响应事件
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
