//
//  BookStoreViewController.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/26.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "BookStoreViewController.h"
#import "BookInfoTableViewCell.h"
#import "BookCategoryViewController.h"
#import "BookDetailViewController.h"

@interface BookStoreViewController ()

@end

@implementation BookStoreViewController

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBookFailed:) name:MigNetNameGetBookFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBookSuccess:) name:MigNetNameGetBookSuccess object:nil];
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetBookFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetBookSuccess object:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initClassicView];
    [self initTableView];
}

- (void)initClassicView {
    
    if (classicWrapper == nil) {
        
        classicWrapper = [[UIView alloc] initWithFrame:self.mFrame];
    }
    [classicWrapper setBackgroundColor:[UIColor clearColor]];
    
    NSArray *bookarray = @[@{KEY_TITLE:@"佛经",
                              KEY_IMAGE:IMG_BOOK_FOJING},
                            
                            @{KEY_TITLE:@"仪轨",
                              KEY_IMAGE:IMG_BOOK_FOLV},
                            
                            @{KEY_TITLE:@"佛伦",
                              KEY_IMAGE:IMG_BOOK_FOLUN},
                            
                            @{KEY_TITLE:@"近代佛著",
                              KEY_IMAGE:IMG_BOOK_FOZHU}];
    
    if (classicInfo == nil) {
        
        classicInfo = [[NSMutableArray alloc] init];
    }
    
    [classicInfo addObjectsFromArray:bookarray];
    
    // 排列图标
    float initGap = 32.0;
    float xstart = initGap / SCREEN_SCALAR;
    float ystart = initGap / SCREEN_SCALAR;
    float iconsize = 125.0 / SCREEN_SCALAR;
    float hSeperatespace = (self.mFrame.size.width - initGap / SCREEN_SCALAR * 2 - iconsize * 4) / 3.0;
    float vSeperatespace = 32.0 / SCREEN_SCALAR;
    
    for (int i=0; i<[classicInfo count]; i++) {
        
        int x = i % 4;
        int y = i / 4;
        float tmpX = xstart + (hSeperatespace + iconsize) * x;
        float tmpY = ystart + (vSeperatespace + iconsize) * y;
        
        NSDictionary *dic = [classicInfo objectAtIndex:i];
        NSString *image = [dic objectForKey:KEY_IMAGE];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(tmpX, tmpY, iconsize, iconsize)];
        [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(doGotoBookCategory:) forControlEvents:UIControlEventTouchUpInside];
        
        //[self.view addSubview:button];
        [classicWrapper addSubview:button];
    }
    
    int row = ceil([classicInfo count] / 4.0);
    tableYStart = ystart + row * (vSeperatespace + iconsize);
    
    [self.view addSubview:classicWrapper];
}

- (void)initTableView {
    
    if (tableBookFojingInfo == nil) {
        
        tableBookFojingInfo = [[NSMutableArray alloc] init];
    }
    
    if (tableBookYiguiInfo == nil) {
        
        tableBookYiguiInfo = [[NSMutableArray alloc] init];
    }
    
    if (tableBookFolunInfo == nil) {
        
        tableBookFolunInfo = [[NSMutableArray alloc] init];
    }
    
    if (tableIntroInfo == nil) {

        tableIntroInfo = [[NSMutableArray alloc] init];
    }
    
    NSArray *sectionArray = [NSArray arrayWithObjects:@"热门推荐", @"佛经", @"仪轨", @"佛伦", nil];
    if (tableSectionInfo == nil) {
        
        tableSectionInfo = [[NSMutableArray alloc] init];
    }
    [tableSectionInfo addObjectsFromArray:sectionArray];
    
    if (bookTableView == nil) {
        
        CGRect tableframe = CGRectMake(0, self.mFrame.origin.y + tableYStart, self.mFrame.size.width, self.mFrame.size.height - tableYStart);
        bookTableView = [[UITableView alloc] initWithFrame:tableframe];
    }
    bookTableView.dataSource = self;
    bookTableView.delegate = self;
    [self.view addSubview:bookTableView];
    
#if MIG_DEBUG_TEST
    
    migsBookIntroduce *bookintro = [[migsBookIntroduce alloc] init];
    bookintro.imgUrl = @"http://face.miu.miyomate.com/system.jpg";
    bookintro.name = @"hehe";
    bookintro.introduce = @"这是一个介绍";
    
    [tableIntroInfo addObject:bookintro];
    [tableIntroInfo addObject:bookintro];
    
    migsBookList *booklist = [[migsBookList alloc] init];
    booklist.imgURL0 = @"http://face.miu.miyomate.com/system.jpg";
    booklist.name0 = @"书籍";
    booklist.imgURL1 = @"http://face.miu.miyomate.com/system.jpg";
    booklist.name1 = @"书籍";
    booklist.imgURL2 = @"http://face.miu.miyomate.com/system.jpg";
    booklist.name2 = @"书籍";
    
    [tableBookFojingInfo addObject:booklist];
    [tableBookFolunInfo addObject:booklist];
    [tableBookYiguiInfo addObject:booklist];
    
    [self reloadData];
#endif
}

- (void)getBookFailed:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取书城首页信息失败");
}

- (void)getBookSuccess:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取书城首页信息成功");
    
    NSDictionary *userinfo = notification.userInfo;
    NSDictionary *result = [userinfo objectForKey:@"result"];
    
    // 热门推荐
    NSDictionary *dicHot = [result objectForKey:@"hot"];
    
    if ([dicHot count] > 0) {
        
        // 重新加载
        [tableIntroInfo removeAllObjects];
    }
    
    for (NSDictionary *dic in dicHot) {
        
        migsBookIntroduce *bookintro = [migsBookIntroduce setupBookIntroduceByDictionary:dic];
        
        [tableIntroInfo addObject:bookintro];
    }
    
    // 佛经
    NSDictionary *dicScript = [result objectForKey:@"scriptures"];
    
    if ([dicScript count] > 0) {
        
        [tableBookFojingInfo removeAllObjects];
    }
    
    migsBookList *fojinglist = [migsBookList setupBookListByDictionary:dicScript];
    [tableBookFojingInfo addObject:fojinglist];
    
    // 仪轨
    NSDictionary *dicRitual = [result objectForKey:@"ritual"];
    
    if ([dicRitual count] > 0) {
        
        [tableBookYiguiInfo removeAllObjects];
    }
    
    migsBookList *yiguilist = [migsBookList setupBookListByDictionary:dicRitual];
    [tableBookYiguiInfo addObject:yiguilist];
    
    // 佛伦
    NSDictionary *dicTheory = [result objectForKey:@"theory"];
    
    if ([dicTheory count] > 0) {
        
        [tableBookFolunInfo removeAllObjects];
    }
    
    migsBookList *folunlist = [migsBookList setupBookListByDictionary:dicTheory];
    [tableBookFolunInfo addObject:folunlist];
    
    [self reloadData];
}

- (void)reloadData {
    
    [bookTableView reloadData];
}

- (void)doGodoBookDetail:(migsBookIntroduce *)bookIntro {
    
    BookDetailViewController *bookdetail = [[BookDetailViewController alloc] init];
    [bookdetail initialize:bookIntro];
    [self.topViewController.navigationController pushViewController:bookdetail animated:YES];
}

- (IBAction)doGotoBookShell:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    MIGDEBUG_PRINT(@"第%d个按钮被触发", btn.tag);
}

- (IBAction)doGotoBookCategory:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    NSDictionary *array = [classicInfo objectAtIndex:btn.tag];
    NSString *name = [array objectForKey:KEY_TITLE];
    NSString *bookid = [NSString stringWithFormat:@"%d", btn.tag + 1];
    
    BookCategoryViewController *category = [[BookCategoryViewController alloc] initWithTitle:name BookID:bookid From:FROMPAGE_BOOK];
    [self.topViewController.navigationController pushViewController:category animated:YES];
}

- (void)onClickFojingCell {
    
    UIButton *btntmp = [[UIButton alloc] init];
    btntmp.tag = 0;
    [self doGotoBookCategory:btntmp];
}

- (void)onClickYiguiCell {
    
    UIButton *btntmp = [[UIButton alloc] init];
    btntmp.tag = 1;
    [self doGotoBookCategory:btntmp];
}

- (void)onClickFolunCell {
    
    UIButton *btntmp = [[UIButton alloc] init];
    btntmp.tag = 2;
    [self doGotoBookCategory:btntmp];
}

// UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // section 0:introduce, 1以后是书籍
    int section = indexPath.section;
    
    if (section == 0) {
        return 80;
    }
    
    return 164;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [tableSectionInfo count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return MIN(2, [tableIntroInfo count]);
    }
    else if (section == 1) {
        
        return MIN(1, [tableBookFojingInfo count]);
    }
    else if (section == 2) {
        
        return MIN(1, [tableBookYiguiInfo count]);
    }
    else if (section == 3) {
        
        return MIN(1, [tableBookFolunInfo count]);
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = (NSString *)[tableSectionInfo objectAtIndex:section];
    return title;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *title = (NSString *)[tableSectionInfo objectAtIndex:section];
    
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.frame = CGRectMake((30 / SCREEN_SCALAR), 4, self.view.frame.size.width - (30 / SCREEN_SCALAR), SECTION_TITLE_HEIGHT);
    lblTitle.text = title;
    lblTitle.textColor = [UIColor grayColor];
    lblTitle.font = [UIFont fontOfApp:20.0 / SCREEN_SCALAR];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:MIG_COLOR_F6F6F6];
    
    [headerView addSubview:lblTitle];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int section = indexPath.section;
    int row = indexPath.row;
    
    // 热门推荐
    if (section == 0) {
        
        NSString *cellIdentifier = @"BookIntroduceTableViewCell";
        BookIntroduceTableViewCell *cell = (BookIntroduceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = (BookIntroduceTableViewCell *)[nibContents objectAtIndex:0];
            cell.backgroundColor = [UIColor clearColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if ([tableIntroInfo count] <= 0) {
                
                return nil;
            }
            
            migsBookIntroduce *bookIntro = [tableIntroInfo objectAtIndex:row];
            [cell initialize:bookIntro];
        }
        
        return cell;
    }
    
    // 书籍
    NSString *cellIdentifier = @"BookInfoTableViewCell";
    BookInfoTableViewCell *cell = (BookInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (BookInfoTableViewCell *)[nibContents objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        // 都只用第一组的tableBookInfo数据
        if (section == 1) {
            
            if ([tableBookFojingInfo count] <= 0) {
                
                return nil;
            }
            
            migsBookList *bookIntro = (migsBookList *)[tableBookFojingInfo objectAtIndex:0];
            [cell initialize:bookIntro];
            
            // item响应cell事件
            [cell.avatarBook0 addTarget:self action:@selector(onClickFojingCell) forControlEvents:UIControlEventTouchUpInside];
            [cell.avatarBook1 addTarget:self action:@selector(onClickFojingCell) forControlEvents:UIControlEventTouchUpInside];
            [cell.avatarBook2 addTarget:self action:@selector(onClickFojingCell) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (section == 2) {
            
            if ([tableBookYiguiInfo count] <= 0) {
                
                return nil;
            }
            
            migsBookList *bookIntro = (migsBookList *)[tableBookYiguiInfo objectAtIndex:0];
            [cell initialize:bookIntro];
            
            // item响应cell事件
            [cell.avatarBook0 addTarget:self action:@selector(onClickYiguiCell) forControlEvents:UIControlEventTouchUpInside];
            [cell.avatarBook1 addTarget:self action:@selector(onClickYiguiCell) forControlEvents:UIControlEventTouchUpInside];
            [cell.avatarBook2 addTarget:self action:@selector(onClickYiguiCell) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (section == 3) {
            
            if ([tableBookFolunInfo count] <= 0) {
                
                return nil;
            }
            
            migsBookList *bookIntro = (migsBookList *)[tableBookFolunInfo objectAtIndex:0];
            [cell initialize:bookIntro];
            
            // item响应cell事件
            [cell.avatarBook0 addTarget:self action:@selector(onClickFolunCell) forControlEvents:UIControlEventTouchUpInside];
            [cell.avatarBook1 addTarget:self action:@selector(onClickFolunCell) forControlEvents:UIControlEventTouchUpInside];
            [cell.avatarBook2 addTarget:self action:@selector(onClickFolunCell) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = indexPath.row;
    int section = indexPath.section;
    
    //响应事件
    // 热门推荐
    if (section == 0) {
        
        migsBookIntroduce *bookintro = [tableIntroInfo objectAtIndex:row];
        [self doGodoBookDetail:bookintro];
    }
    else if (section == 1) {
        
        [self onClickFojingCell];
    }
    else if (section == 2) {
        
        [self onClickYiguiCell];
    }
    else if (section == 3) {
        
        [self onClickFolunCell];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
