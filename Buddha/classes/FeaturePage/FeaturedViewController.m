//
//  FeaturedViewController.m
//  Buddha
//
//  Created by Archer_LJ on 14/11/26.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "FeaturedViewController.h"
#import "AskNetDataApi.h"
#import "RootViewController.h"

@interface FeaturedViewController ()

@end

@implementation FeaturedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRecomFailed:) name:MigNetNameGetRecomFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRecomSuccess:) name:MigNetNameGetRecomSuccess object:nil];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (!self.mFirstLoad) {
        
        [self reloadTableViewDataSource];
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetRecomFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetRecomSuccess object:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (_tableInfoArray == nil) {
        
        _tableInfoArray = [[NSMutableArray alloc] init];
        [self initTableInfoArray];
    }
    
    if (_contentTableView == nil) {
        
        CGRect tableFrame = self.mFrame;
        
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(tableFrame.origin.x, tableFrame.origin.y, tableFrame.size.width, tableFrame.size.height)];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        [_contentTableView setBackgroundColor:[UIColor clearColor]];
        
        
        UIImageView *mBannerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_HOME_BANNER]];
        mBannerImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, HOME_BANNER_HEIGHT);
        _contentTableView.tableHeaderView = mBannerImageView;
    }
    
    if (booksName == nil) {
        
        booksName = [[NSMutableArray alloc] init];
    }
    
    if (booksPic == nil) {
        
        booksPic = [[NSMutableArray alloc] init];
    }
    
    if (activityTitle == nil) {
        
        activityTitle = [[NSMutableArray alloc] init];
    }
    
    if (activityPic == nil) {
        
        activityPic = [[NSMutableArray alloc] init];
    }
    
    [self.view addSubview:_contentTableView];
    
    // 请求首页数据
    [self.askApi doGetRecom];
    self.mFirstLoad = NO;
}

- (void)reloadTableViewDataSource {
    
    [_contentTableView reloadData];
}

- (void)forceRefreshData {
    
    
}

- (void)initTableInfoArray {
    
    NSArray *infoArray = @[@{KEY_HEADER:@"头条新闻",
                             KEY_TOTAL_HEIGHT:[NSNumber numberWithFloat:100]},
                           
                           @{KEY_HEADER:@"佛教书籍",
                             KEY_TOTAL_HEIGHT:[NSNumber numberWithFloat:140]},
                           
                           @{KEY_HEADER:@"佛教活动",
                             KEY_TOTAL_HEIGHT:[NSNumber numberWithFloat:(320 / SCREEN_SCALAR)]}];
    
    [_tableInfoArray addObjectsFromArray:infoArray];
}

- (void)doGotoBookPage {
    
    RootViewController *rootView = (RootViewController *)self.topViewController;
    [rootView doUpdateView:ROOTVIEWTAG_LIBRARY];
    [rootView.mTopMenu changeButtonStateAtIndex:ROOTVIEWTAG_LIBRARY];
}

- (void)doGotoActivity {
    
    RootViewController *rootView = (RootViewController *)self.topViewController;
    [rootView doUpdateView:ROOTVIEWTAG_ACTIVITY];
    [rootView.mTopMenu changeButtonStateAtIndex:ROOTVIEWTAG_ACTIVITY];
}

- (void)getRecomFailed:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取首页数据失败");
}

- (void)getRecomSuccess:(NSNotification *)notification {
    
    NSDictionary *userinfo = [notification userInfo];
    NSDictionary *result = [userinfo objectForKey:@"result"];
    
    NSDictionary *news = [result objectForKey:@"news"];
    newsTitle = [news objectForKey:@"title"];
    newsSummary = [news objectForKey:@"summary"];
    newsPic = [news objectForKey:@"pic"];
    
    // 获取成功，删除已有数据
    [booksName removeAllObjects];
    [booksPic removeAllObjects];
    [activityPic removeAllObjects];
    [activityTitle removeAllObjects];
    
    NSArray *books = [result objectForKey:@"books"];
    for (NSDictionary *dicBook in books) {
        
        [booksName addObject:[dicBook objectForKey:@"name"]];
        [booksPic addObject:[dicBook objectForKey:@"pic"]];
    }
    
    NSArray *activities = [result objectForKey:@"activities"];
    for (NSDictionary *dicActivity in activities) {
        
        [activityTitle addObject:[dicActivity objectForKey:@"title"]];
        [activityPic addObject:[dicActivity objectForKey:@"pic"]];
    }
    
    [self reloadTableViewDataSource];
}

// UITableViewDataSource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _tableInfoArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSDictionary *dic = _tableInfoArray[section];
    
    return [dic objectForKey:KEY_HEADER];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSDictionary *dic = _tableInfoArray[section];
    
    
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.frame = CGRectMake((30 / SCREEN_SCALAR), 4, self.view.frame.size.width - (30 / SCREEN_SCALAR), SECTION_TITLE_HEIGHT);
    lblTitle.text = [dic objectForKey:KEY_HEADER];
    lblTitle.textColor = [UIColor grayColor];
    lblTitle.font = [UIFont fontOfApp:20.0 / SCREEN_SCALAR];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:MIG_COLOR_F6F6F6];
    
    [headerView addSubview:lblTitle];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = _tableInfoArray[indexPath.section];
    float height = [[dic objectForKey:KEY_TOTAL_HEIGHT] floatValue];
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int currentSection = indexPath.section;
    
    if (currentSection == SECTION_NEWS) {
        
        NSString *cellIdentifier = @"FeaturedNewsCell";
        FeaturedNewsCell *cell = (FeaturedNewsCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = (FeaturedNewsCell *)[nibContents objectAtIndex:0];
            cell.backgroundColor = [UIColor clearColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            cell.lblTitle.textColor = [UIColor blackColor];
            cell.lblTitle.font = [UIFont fontOfApp:30.0 / SCREEN_SCALAR];
            cell.lblTitle.text = newsTitle;
            
            cell.lblDetail.textColor = [UIColor lightGrayColor];
            cell.lblDetail.font = [UIFont fontOfApp:24.0 / SCREEN_SCALAR];
            cell.lblDetail.lineBreakMode = NSLineBreakByWordWrapping;
            cell.lblDetail.numberOfLines = 5;
            cell.lblDetail.text = newsSummary;
            
            cell.avatarImg.imageURL = [NSURL URLWithString:newsPic];
        }
        
        return cell;
    }
    else if (currentSection == SECTION_BOOKS) {
        
        NSString *cellIdentifier = @"FeaturedBooksCell";
        FeaturedBooksCell *cell = (FeaturedBooksCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = (FeaturedBooksCell *)[nibContents objectAtIndex:0];
            cell.backgroundColor = [UIColor clearColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if ([booksPic count] >= 3) {
                
                cell.avatarBook0.imageURL = [NSURL URLWithString:[booksPic objectAtIndex:0]];
                cell.avatarBook1.imageURL = [NSURL URLWithString:[booksPic objectAtIndex:1]];
                cell.avatarBook2.imageURL = [NSURL URLWithString:[booksPic objectAtIndex:2]];
                
                // button响应cell单元事件
                [cell.avatarBook0 addTarget:self action:@selector(doGotoBookPage) forControlEvents:UIControlEventTouchUpInside];
                [cell.avatarBook1 addTarget:self action:@selector(doGotoBookPage) forControlEvents:UIControlEventTouchUpInside];
                [cell.avatarBook2 addTarget:self action:@selector(doGotoBookPage) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        return cell;
    }
    else if (currentSection == SECTION_ACTIVITIES) {
        
        NSString *cellIdentifier = @"FeaturedActivitiesCell";
        FeaturedActivitiesCell *cell = (FeaturedActivitiesCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = (FeaturedActivitiesCell *)[nibContents objectAtIndex:0];
            cell.backgroundColor = [UIColor clearColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if ([activityPic count] >= 3) {
                
                cell.avatarActivity0.imageURL = [NSURL URLWithString:[activityPic objectAtIndex:0]];
                cell.avatarActivity1.imageURL = [NSURL URLWithString:[activityPic objectAtIndex:1]];
                cell.avatarActivity2.imageURL = [NSURL URLWithString:[activityPic objectAtIndex:2]];
                
                cell.lblActivity0.text = [activityTitle objectAtIndex:0];
                cell.lblActivity0.textColor = [UIColor lightGrayColor];
                cell.lblActivity0.textAlignment = NSTextAlignmentCenter;
                cell.lblActivity0.font = [UIFont fontOfApp:20.0 / SCREEN_SCALAR];
                
                cell.lblActivity1.text = [activityTitle objectAtIndex:1];
                cell.lblActivity1.textColor = [UIColor lightGrayColor];
                cell.lblActivity1.textAlignment = NSTextAlignmentCenter;
                cell.lblActivity1.font = [UIFont fontOfApp:20.0 / SCREEN_SCALAR];
                
                cell.lblActivity2.text = [activityTitle objectAtIndex:2];
                cell.lblActivity2.textColor = [UIColor lightGrayColor];
                cell.lblActivity2.textAlignment = NSTextAlignmentCenter;
                cell.lblActivity2.font = [UIFont fontOfApp:20.0 / SCREEN_SCALAR];
                
                // button响应cell单元事件
                [cell.avatarActivity0 addTarget:self action:@selector(doGotoActivity) forControlEvents:UIControlEventTouchUpInside];
                [cell.avatarActivity1 addTarget:self action:@selector(doGotoActivity) forControlEvents:UIControlEventTouchUpInside];
                [cell.avatarActivity2 addTarget:self action:@selector(doGotoActivity) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 响应事件
    int section = indexPath.section;
    if (section == SECTION_BOOKS) {
        
        [self doGotoBookPage];
    }
    else if (section == SECTION_ACTIVITIES) {
        
        [self doGotoActivity];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 使HeaderView不黏在顶部
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y >= 0) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
