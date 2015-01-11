//
//  BookCategoryViewController.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/27.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "BookCategoryViewController.h"
#import "GeneralSearchView.h"
#import "BookDetailViewController.h"

@interface BookCategoryViewController ()

@end

@implementation BookCategoryViewController

- (id)initWithTitle:(NSString *)title BookID:(NSString *)bookid From:(int)frompage {
    
    self = [super init];
    
    if (self) {
        
        [self initNavView:title];
        BookId = bookid;
        listType = MIG_BOOK_LISTTYPE_NEW;
        _fromPage = frompage;
        isLoadingNetData = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doGetBookByIDFailed:) name:MigNetNameSearchBookTypeFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doGetBookByIDSuccess:) name:MigNetNameSearchBookTypeSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doGetIntroSearchFailed:) name:MigNetNameGetIntroSearchFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doGetIntroSearchSuccess:) name:MigNetNameGetIntroSearchSuccess object:nil];
        
        if (_fromPage == FROMPAGE_BOOK) {
            
            [self doGetBookByID:BookId];
        }
        else if (_fromPage == FROMPAGE_INTRODUCE) {
            
            int index = 0;
            
            // 模拟点击一次
            if ([BookId isEqualToString:@"0"]) {
                
                // 佛教历史
                index = 1;
            }
            else if ([BookId isEqualToString:@"1"]) {
                
                // 宗教思想
                index = 0;
            }
            
            // 重新载入一次
            [self initTopMenuAndClick:index];
        }
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameSearchBookTypeFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameSearchBookTypeSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetIntroSearchFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetIntroSearchSuccess object:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (viewWrapper == nil) {
        
        viewWrapper = [[UIView alloc] initWithFrame:self.view.frame];
    }
    [self.view addSubview:viewWrapper];
    
    [self initSearchView];
    [self initTopMenu];
    [self initContentView];
}

- (void)initNavView:(NSString *)title {
    
    self.navigationItem.title = title;
}

- (void)initSearchView {
    
    if (_searchView == nil) {
        
        CGRect searchFrame = CGRectMake(0, NAVIGATION_HEIGHT, self.view.frame.size.width, 80 / SCREEN_SCALAR);
        _searchView = [[GeneralSearchView alloc] initWithFrame:searchFrame BgImg:IMG_ROUND_RECTANGLE IconImg:IMG_HOME_SEARCH Content:@"搜索" Font:[UIFont fontOfApp:24 / SCREEN_SCALAR]];
    }
    _searchView.delegate = self;
    [viewWrapper addSubview:_searchView];
}

- (void)initTopMenuAndClick:(int)index {
    
    float titleWidth = (self.view.frame.size.width - 38) / 2;
    float ystart = (80 + 32) / SCREEN_SCALAR + NAVIGATION_HEIGHT;
    NSArray *titlearray = nil;
    
    if (_fromPage == FROMPAGE_BOOK) {
        
        titlearray = [[NSArray alloc] initWithObjects:@"最新上架", @"热点最高", nil];
    }
    else if (_fromPage == FROMPAGE_INTRODUCE) {
        
        titlearray = [[NSArray alloc] initWithObjects:@"宗派思想", @"佛教历史", nil];
    }
    
    NSArray *topArray = @[@{KEY_NORMAL:IMG_HOME_NORMAL_BG,
                            KEY_HILIGHT:IMG_BOOK_SELECT_BG,
                            KEY_TITLE:[titlearray objectAtIndex:0],
                            KEY_TITLE_WIDTH:[NSNumber numberWithFloat:titleWidth]},
                          @{KEY_NORMAL:IMG_HOME_NORMAL_BG,
                            KEY_HILIGHT:IMG_BOOK_SELECT_BG,
                            KEY_TITLE:[titlearray objectAtIndex:1],
                            KEY_TITLE_WIDTH:[NSNumber numberWithFloat:titleWidth]}];
    
    if (_topMenuView != nil) {
        
        [_topMenuView removeFromSuperview];
    }
    
    // 初始化顶部菜单
    CGRect menuFrame = CGRectMake(38 / SCREEN_SCALAR, ystart, self.view.frame.size.width - 38, 80 / SCREEN_SCALAR);
    CGSize btnImaSize = CGSizeMake(0, 0);
    
    _topMenuView = [[HorizontalMenu alloc] initWithFrame:menuFrame ButtonItems:topArray buttonSize:btnImaSize ButtonType:HORIZONTALMENU_TYPE_BUTTON];
    _topMenuView.delegate = self;
    
    [viewWrapper addSubview:_topMenuView];
    
    [_topMenuView clickButtonAtIndex:index];
}

- (void)initTopMenu {
    
    [self initTopMenuAndClick:0];
}

- (void)initContentView {
    
    if (tableInfoNewArray == nil) {
        
        tableInfoNewArray = [[NSMutableArray alloc] init];
    }
    
    if (tableInfoHotArray == nil) {
        
        tableInfoHotArray = [[NSMutableArray alloc] init];
    }
    
    if (_contentTableView == nil) {
        
        float ystart = (80 + 32 + 80) / SCREEN_SCALAR + NAVIGATION_HEIGHT;
        CGRect tableFrame = CGRectMake(0, ystart, self.view.frame.size.width, self.view.frame.size.height - ystart);
        _contentTableView = [[UITableView alloc] initWithFrame:tableFrame];
    }
    
    _contentTableView.dataSource = self;
    _contentTableView.delegate = self;
    [viewWrapper addSubview:_contentTableView];
    
#if MIG_DEBUG_TEST
    migsBookIntroduce *intro = [[migsBookIntroduce alloc] init];
    intro.imgUrl = @"http://face.miu.miyomate.com/system.jpg";
    intro.name = @"书籍";
    intro.introduce = @"我靠这是一本书好不好";
    
    [tableInfoNewArray addObject:intro];
    [tableInfoNewArray addObject:intro];
    [tableInfoHotArray addObject:intro];
    [tableInfoHotArray addObject:intro];
    
    [self reloadData];
#endif
}

- (void)reloadData {
    
    [_contentTableView reloadData];
}

- (void)reloadDataByType:(int)type {
    
    listType = type;
    [self reloadData];
}

- (void)doGetIntroSearch:(NSString *)type {
    
    isLoadingNetData = YES;
    AskNetDataApi *api = [[AskNetDataApi alloc] init];
    [api doGetIntroSearch:type];
}

- (void)doGetIntroSearchFailed:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取思想和历史失败");
    
    isLoadingNetData = NO;
}

- (void)doGetIntroSearchSuccess:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取思想和历史成功");
    
    // 更新数据, 因为每次都会重新获取数据，所以可以把两组设置成一样
    NSDictionary *userinfo = notification.userInfo;
    NSDictionary *result = [userinfo objectForKey:@"result"];
    NSDictionary *list = [result objectForKey:@"list"];
    
    if ([list count] > 0) {
        
        [tableInfoHotArray removeAllObjects];
        [tableInfoNewArray removeAllObjects];
    }
    
    for (NSDictionary *dic in list) {
        
        migsBookIntroduce *bookintro = [migsBookIntroduce setupBookIntroduceByDictionary:dic];
        [tableInfoHotArray addObject:bookintro];
        [tableInfoNewArray addObject:bookintro];
    }
    
    [self reloadData];
    
    isLoadingNetData = NO;
}

- (void)doGetBookByID:(NSString *)bookid {
    
    AskNetDataApi *askApi = [[AskNetDataApi alloc] init];
    [askApi doSearchBookType:bookid];
}

- (void)doGetBookByIDFailed:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"根据类别获取书籍失败");
}

- (void)doGetBookByIDSuccess:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"根据类别获取书籍成功");
    
    NSDictionary *userinfo = notification.userInfo;
    NSDictionary *result = [userinfo objectForKey:@"result"];
    
    // 热门
    NSDictionary *dicHot = [result objectForKey:@"hot"];
    
    if ([dicHot count] > 0) {
        
        [tableInfoHotArray removeAllObjects];
    }
    
    for (NSDictionary *dic in dicHot) {
        
        migsBookIntroduce *bookintro = [migsBookIntroduce setupBookIntroduceByDictionary:dic];
        [tableInfoHotArray addObject:bookintro];
    }
    
    // 最新
    NSDictionary *dicNew = [result objectForKey:@"new"];
    
    if ([dicNew count] > 0) {
        
        [tableInfoNewArray removeAllObjects];
    }
    
    for (NSDictionary *dic in dicNew) {
        
        migsBookIntroduce *bookintro = [migsBookIntroduce setupBookIntroduceByDictionary:dic];
        [tableInfoNewArray addObject:bookintro];
    }
    
    [self reloadData];
}

- (void)doGodoBookDetail:(migsBookIntroduce *)bookIntro {
    
    BookDetailViewController *bookdetail = [[BookDetailViewController alloc] init];
    [bookdetail initialize:bookIntro];
    [self.navigationController pushViewController:bookdetail animated:YES];
}

// GeneralSearchViewDelegate
- (void)didGeneralSearchViewClicked {
    
    MIGDEBUG_PRINT(@"搜索按钮被点击");
}

// HorizontalMenuDelegate
- (void)didHorizontalMenuClickedButttonAtIndex:(NSInteger)index Type:(NSInteger)type {
    
    MIGDEBUG_PRINT(@"顶部菜单被点击");
    
    if (type == HORIZONTALMENU_TYPE_BUTTON) {
        
        if (_fromPage == FROMPAGE_BOOK) {
            
            if (index == 0) {
                
                listType = MIG_BOOK_LISTTYPE_NEW;
            }
            else if (index == 1) {
                
                listType = MIG_BOOK_LISTTYPE_HOT;
            }
            
            [self reloadData];
        }
        else if (_fromPage == FROMPAGE_INTRODUCE) {
            
            // 介绍页面的东西，每次重新加载
            
            if (isLoadingNetData) {
                
                [SVProgressHUD showErrorWithStatus:@"正在加载"];
                return;
            }
            
            NSString *type = nil;
            
            if (index == 0) {
                
                type = [NSString stringWithFormat:@"%d", INTROTYPE_THOUGHT];
            }
            else if (index == 1) {
                
                type = [NSString stringWithFormat:@"%d", INTROTYPE_HISTORY];
            }
            
            [self doGetIntroSearch:type];
        }
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (listType == MIG_BOOK_LISTTYPE_NEW) {
        
        return [tableInfoNewArray count];
    }
    else if (listType == MIG_BOOK_LISTTYPE_HOT){
        
        return [tableInfoHotArray count];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 128.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = indexPath.row;
    
    NSString *cellIdentifier = @"BookCategoryInfoTableViewCell";
    BookCategoryInfoTableViewCell *cell = (BookCategoryInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (BookCategoryInfoTableViewCell *)[nibContents objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (listType == MIG_BOOK_LISTTYPE_NEW) {
            
            if ([tableInfoNewArray count] <= 0) {
                
                return nil;
            }
            
            migsBookIntroduce *bookIntro = [tableInfoNewArray objectAtIndex:row];
            [cell initialize:bookIntro];
        }
        else if (listType == MIG_BOOK_LISTTYPE_HOT) {
            
            if ([tableInfoHotArray count] <= 0) {
                
                return nil;
            }
            
            migsBookIntroduce *bookIntro = [tableInfoHotArray objectAtIndex:row];
            [cell initialize:bookIntro];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 跳转到书籍详情
    migsBookIntroduce *bookintro = nil;
    int row = indexPath.row;
    
    if (listType == MIG_BOOK_LISTTYPE_NEW) {
        
        bookintro = [tableInfoNewArray objectAtIndex:row];
    }
    else if (listType == MIG_BOOK_LISTTYPE_HOT) {
        
        bookintro = [tableInfoHotArray objectAtIndex:row];
    }
    else {
        
        
    }
    
    [self doGodoBookDetail:bookintro];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
