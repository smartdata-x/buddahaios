//
//  BookDetailViewController.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/28.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "BookDetailViewController.h"
#import "BookShellViewController.h"
#import "ReadingViewController.h"
#import "DatabaseManager.h"
#import "LoginManager.h"

@implementation migsBookDetailInformation

+ (migsBookDetailInformation *)setupBookDetailByDictionary:(NSDictionary *)dic {
    
    migsBookDetailInformation *detail = [[migsBookDetailInformation alloc] init];
    detail.labels = [[NSMutableArray alloc] init];
    
    NSDictionary *dicSummary = [dic objectForKey:@"summary"];
    int nchapter = [[dicSummary objectForKey:@"chapter"] intValue];
    NSString *author = [dicSummary objectForKey:@"author"];
    NSString *pubtime = [dicSummary objectForKey:@"pubtime"];
    NSString *chapters = [NSString stringWithFormat:@"%d", nchapter];
    NSString *summary = [dicSummary objectForKey:@"summary"];
    NSString *freeurl = [dicSummary objectForKey:@"free"];
    NSString *fullurl = [dicSummary objectForKey:@"full"];
    
    detail.author = author;
    detail.publicTime = pubtime;
    detail.Chapters = chapters;
    detail.bookSummary = summary;
    detail.freeContentUrl = freeurl;
    detail.fullContentUrl = fullurl;
    
    NSDictionary *dicUser = [dic objectForKey:@"user"];
    int issave = [[dicUser objectForKey:@"issave"] intValue];
    detail.issaved = issave;
    
    NSArray *dicLabel = [dic objectForKey:@"label"];
    int count = [dicLabel count];
    for (int i=0; i<count; i++) {
    
        NSString *curLabel = [dicLabel objectAtIndex:i];
        [detail.labels addObject:curLabel];
    }
    
    return detail;
}

@end

@interface BookDetailViewController ()

@end

@implementation BookDetailViewController

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doGetBookSummaryFailed:) name:MigNetNameGetBookSummaryFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doGetBookSummarySuccess:) name:MigNetNameGetBookSummarySuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doGetBookTokenFailed:) name:MigNetNameGetBookTokenFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doGetBookTokenSuccess:) name:MigNetNameGetBookTokenSuccess object:nil];
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetBookSummaryFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetBookSummarySuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetBookTokenFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetBookTokenSuccess object:nil];
}

- (void)initialize:(migsBookIntroduce *)bookIntro {
    
    _bookInfo = bookIntro;
    
    [self doGetBookSummary:_bookInfo.bookid];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (rootViewWrapper == nil) {
        
        rootViewWrapper = [[UIView alloc] initWithFrame:self.view.frame];
    }
    [self.view addSubview:rootViewWrapper];
    
    if (viewWrapper == nil) {
        
        viewWrapper = [[UIScrollView alloc] initWithFrame:self.view.frame];
    }
    [rootViewWrapper addSubview:viewWrapper];
    
    [self initNavView];
    [self reloadView];
}

- (void)reloadView {
    
    if (_bookDetailInfo == nil) {
        
        return;
    }
    
    float yStart = 0.0;
    [self initBookCellView:yStart];
    
    yStart += 80 + 32 / SCREEN_SCALAR;
    [self initMenuView:yStart];
    
    yStart += (80 + 32) / SCREEN_SCALAR;
    [self initDetailInfoView:&yStart];
    
    yStart += 32 / SCREEN_SCALAR;
    [self initShareView:yStart];
    
    yStart += (94 + 32) / SCREEN_SCALAR;
    [self initTagView:&yStart];
    
    [self initBookShareView];
    
    [viewWrapper setContentSize:CGSizeMake(self.view.frame.size.width, yStart + 32)];
}

- (void)doGetBookSummary:(NSString *)bookid {
    
    AskNetDataApi *api = [[AskNetDataApi alloc] init];
    [api doGetBookSummary:bookid];
}

- (void)doGetBookSummaryFailed:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取书籍详情失败");
}

- (void)doGetBookSummarySuccess:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取书籍详情成功");
    
    NSDictionary *userinfo = notification.userInfo;
    NSDictionary *result = [userinfo objectForKey:@"result"];
    
    migsBookDetailInformation *detailinfo = [migsBookDetailInformation setupBookDetailByDictionary:result];
    _bookDetailInfo = detailinfo;
    
    // 其他初始化
    _bookDetailInfo.bookname = _bookInfo.name;
    _bookDetailInfo.bookid = _bookInfo.bookid;
    _bookDetailInfo.booktype = _bookInfo.booktype;
    _bookDetailInfo.imgURL = _bookInfo.imgUrl;
    
    // 初始化标题结构体
    [bookTitle removeAllObjects];
    NSString *authorandpublic = [NSString stringWithFormat:@"作者:%@\n出版时间:%@", _bookDetailInfo.author, _bookDetailInfo.publicTime];
    
    migsBookIntroduce *tmpIntro = [[migsBookIntroduce alloc] init];
    tmpIntro.name = _bookDetailInfo.bookname;
    tmpIntro.imgUrl = _bookDetailInfo.imgURL;
    tmpIntro.introduce = authorandpublic;
    
    if (bookTitle == nil) {
        
        bookTitle = [[NSMutableArray alloc] init];
    }
    [bookTitle addObject:tmpIntro];
    
    // 初始化标签
    tagInfo = _bookDetailInfo.labels;
    
    // 如果是之前保存过的，则自动保存一次
    if (_bookDetailInfo.issaved) {
        
        [[DatabaseManager GetInstance] insertBookInfo:_bookDetailInfo];
    }
    
    [self reloadView];
}

- (void)initNavView {
    
    self.navigationItem.title = @"书籍详情";
    
    // 书架按钮
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(44, 0, 60/SCREEN_SCALAR, 43/SCREEN_SCALAR);
    [btnRight setBackgroundColor:[UIColor clearColor]];
    [btnRight setTitle:@"书架" forState:UIControlStateNormal];
    [btnRight.titleLabel setFont:[UIFont fontOfApp:28 / SCREEN_SCALAR]];
    [btnRight.titleLabel setTextColor:[UIColor whiteColor]];
    [btnRight.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btnRight addTarget:self action:@selector(doGotoBookShell:isSaveToShelf:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = item0;
}

- (void)initBookCellView:(float)yStart {
    
    if (bookTitle == nil) {
        
        bookTitle = [[NSMutableArray alloc] init];
    }
    
    if (_titleTableView == nil) {
        
        CGRect tableFrame = CGRectMake(0, yStart, self.view.frame.size.width, 80);
        _titleTableView = [[UITableView alloc] initWithFrame:tableFrame];
    }
    _titleTableView.dataSource = self;
    _titleTableView.delegate = self;
    _titleTableView.scrollEnabled = NO;
    
    [viewWrapper addSubview:_titleTableView];
    
    [self reloadData];
}

- (void)reloadData {
    
    [_titleTableView reloadData];
}

- (void)initMenuView:(float)yStart {
    
    float titleWidth = (self.view.frame.size.width - 32) / 2;
    
    NSArray *topArray = @[@{KEY_NORMAL:IMG_HOME_NORMAL_BG,
                            KEY_HILIGHT:IMG_BOOK_SELECT_BG,
                            KEY_TITLE:@"免费试读",
                            KEY_TITLE_WIDTH:[NSNumber numberWithFloat:titleWidth]},
                          @{KEY_NORMAL:IMG_HOME_NORMAL_BG,
                            KEY_HILIGHT:IMG_BOOK_SELECT_BG,
                            KEY_TITLE:@"保存书架",
                            KEY_TITLE_WIDTH:[NSNumber numberWithFloat:titleWidth]}];
    
    // 初始化顶部菜单
    if (_menuView == nil) {
        
        CGRect menuFrame = CGRectMake(32 / SCREEN_SCALAR, yStart, self.view.frame.size.width - 32, 80 / SCREEN_SCALAR);
        CGSize btnImaSize = CGSizeMake(0, 0);
        
        _menuView = [[HorizontalMenu alloc] initWithFrame:menuFrame ButtonItems:topArray buttonSize:btnImaSize ButtonType:HORIZONTALMENU_TYPE_BUTTON];
        _menuView.delegate = self;
    }
    
    [viewWrapper addSubview:_menuView];
}

- (void)initDetailInfoView:(float *)yStart {
    
    NSString *content = _bookDetailInfo.bookSummary;
    
    if (_lblDetailInfo == nil) {
        
        CGRect frame = CGRectMake(32 / SCREEN_SCALAR, *yStart, self.view.frame.size.width - 32, 140);
        float realHeight = [Utilities heightForString:content Font:[UIFont fontOfApp:26 / SCREEN_SCALAR] Frame:frame];
        realHeight += 4;
        CGRect realFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, realHeight);
        _lblDetailInfo = [[UILabel alloc] initWithFrame:realFrame];
        *yStart += realHeight;
    }
    
    _lblDetailInfo.text = content;
    [_lblDetailInfo setTextColor:MIG_COLOR_808080];
    [_lblDetailInfo setFont:[UIFont fontOfApp:26 / SCREEN_SCALAR]];
    [_lblDetailInfo setTextAlignment:NSTextAlignmentLeft];
    [_lblDetailInfo setNumberOfLines:0];
    
    [viewWrapper addSubview:_lblDetailInfo];
}

- (void)initShareView:(float)yStart {
    
    float height = 94 / SCREEN_SCALAR;
    
    if (_chapterView == nil) {
        
        NSString *chapter = [NSString stringWithFormat:@"共%@章", _bookDetailInfo.Chapters];
        CGRect chapterFrame = CGRectMake(0, yStart, self.view.frame.size.width / 2, height);
        _chapterView = [[GeneralSearchView alloc] initWithFrame:chapterFrame BgImg:IMG_COLOR_BG_FBFBFB IconImg:IMG_BOOK_BOOKMARK Content:chapter Font:[UIFont fontOfApp: 30 / SCREEN_SCALAR]];
    }
    [viewWrapper addSubview:_chapterView];
    
    if (_shareView == nil) {
        
        CGRect frame = CGRectMake(self.view.frame.size.width / 2, yStart, self.view.frame.size.width / 2, height);
        _shareView = [[GeneralSearchView alloc] initWithFrame:frame BgImg:IMG_COLOR_BG_FBFBFB IconImg:IMG_BOOK_SHARE Content:@"分享" Font:[UIFont fontOfApp:30 / SCREEN_SCALAR]];
    }
    _shareView.delegate = self;
    [viewWrapper addSubview:_shareView];
}

- (void)initBookShareView {
    
    float height = 250 / SCREEN_SCALAR;
    
    if (_bookShareView == nil) {
        
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, height);
        _bookShareView = [[GeneralShareView alloc] initWithFrame:frame];
    }
    _bookShareView.delegate = self;
}

- (void)doShowShareView {
    
    // 分享
    MIGDEBUG_PRINT(@"点击分享");

    if (IS_OS_8_OR_LATER) {
        
        _shareAlertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n"  message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        //取消
        [_shareAlertController addAction:[UIAlertAction actionWithTitle:MIGTIP_CANCEL
                                                                  style:UIAlertActionStyleCancel
                                                                handler:^(UIAlertAction *action) {
                                                                }]];
        
        [_shareAlertController.view addSubview:_bookShareView];
        [self presentViewController:_shareAlertController animated:YES completion:nil];
    }
    else{
        _shareAchtionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n" delegate:self cancelButtonTitle:MIGTIP_CANCEL destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        
        [_shareAchtionSheet addSubview:_bookShareView];
        [_shareAchtionSheet showInView:self.view];
    }
}

- (void)initTagView:(float *)yStart {
    
    if (tagInfo == nil) {
        
        tagInfo = [[NSMutableArray alloc] init];
    }
    
    float height = 24;
    
    if (_lblTag == nil) {
        
        _lblTag = [[UILabel alloc] initWithFrame:CGRectMake(32 / SCREEN_SCALAR, *yStart, 150, height)];
    }
    [_lblTag setText:@"图书标签"];
    [_lblTag setTextColor:MIG_COLOR_111111];
    [_lblTag setTextAlignment:NSTextAlignmentLeft];
    [_lblTag setFont:[UIFont fontOfApp:32 / SCREEN_SCALAR]];
    [viewWrapper addSubview:_lblTag];
    
    // 初始化标签
    float xStart = 32 / SCREEN_SCALAR;
    *yStart += (24 + 32) / SCREEN_SCALAR;
    float lblWidth = (self.view.frame.size.width - xStart * 2 - 24) / 3;
    float lblHeight = 80 / SCREEN_SCALAR;
    int count = [tagInfo count];
    
    for (int i=0; i<count; i++) {
        
        int x = i % 3;
        int y = i / 3;
        
        CGRect frame = CGRectMake(xStart + x * (lblWidth + 24 / SCREEN_SCALAR),
                                  *yStart + y * (lblHeight + 32 / SCREEN_SCALAR),
                                  lblWidth,
                                  lblHeight);
        UILabel *lbltag = [[UILabel alloc] initWithFrame:frame];
        [lbltag setText:[tagInfo objectAtIndex:i]];
        [lbltag setTextColor:MIG_COLOR_333333];
        [lbltag setTextAlignment:NSTextAlignmentCenter];
        [lbltag setFont:[UIFont fontOfApp:28 / SCREEN_SCALAR]];
        [lbltag setBackgroundColor:MIG_COLOR_FBFBFB];
        
        [viewWrapper addSubview:lbltag];
    }
}

- (IBAction)doGotoBookShell:(id)sender isSaveToShelf:(BOOL)issave {
    
    MIGDEBUG_PRINT(@"前往书架");
    
    // 没有sender，主动调用的
    if (sender == nil) {
        
        if (issave) {
            
            // 保存当前书籍信息
            [[DatabaseManager GetInstance] insertBookInfo:_bookDetailInfo];
        }
    }
    
    BookShellViewController *shelfView = [[BookShellViewController alloc] init];
    [self.navigationController pushViewController:shelfView animated:YES];
}

- (void)doGotoReadingView:(NSString *)bookname BookID:(NSString *)bookid BookToken:(NSString *)booktoken{
    
    ReadingViewController *readingView = [[ReadingViewController alloc] init];
    [readingView initialize:bookname BookId:bookid BookToken:booktoken];
    [self.navigationController pushViewController:readingView animated:YES];
}

- (void)doGetBookToken:(NSString *)bookid {
    
    AskNetDataApi *api = [[AskNetDataApi alloc] init];
    [api doGetBookToken:bookid];
}

- (void)doGetBookTokenFailed:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取书籍token失败");
}

- (void)doGetBookTokenSuccess:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取书籍token成功");
    
    NSDictionary *userinfo = notification.userInfo;
    NSDictionary *result = [userinfo objectForKey:@"result"];
    NSString *booktoken = [result objectForKey:@"book_token"];
    
    _bookDetailInfo.booktoken = booktoken;
    
    // 添加到书架
    [[DatabaseManager GetInstance] insertBookInfo:_bookDetailInfo];
    
    // 跳转到书架
    [self doGotoBookShell:nil isSaveToShelf:NO];
}

// HorizontalMenuDelegate
- (void)didHorizontalMenuClickedButttonAtIndex:(NSInteger)index Type:(NSInteger)type {
    
    if (type == HORIZONTALMENU_TYPE_BUTTON) {
        
        if (index == MIG_BOOK_DETAIL_FREEREAD) {
            
            // 这里进入的是免费阅读版本
            [self doGotoReadingView:_bookDetailInfo.bookname BookID:_bookDetailInfo.bookid BookToken:_bookDetailInfo.booktoken];
        }
        else if (index == MIG_BOOK_DETAIL_SAVETOSHELF) {
            
            // 申请添加到书架
            [self doGetBookToken:_bookDetailInfo.bookid];
        }
    }
}

// GeneralShareViewDelegate
- (void)didGeneralShareViewClicked:(NSInteger)index {
    
    MIGDEBUG_PRINT(@"第%d分享", index);
    
    if (index == 0) {
        
        [[LoginManager GetInstance] doTencentWeixinShare];
    }
    else if (index == 1) {
        
        [[LoginManager GetInstance] doTencentQQShare];
    }
    else if (index == 2) {
        
        [[LoginManager GetInstance] doSinaWeiboShare];
    }
    
    // 点击分享之后隐藏分享页面
    if (IS_OS_8_OR_LATER) {
    
        [_shareAlertController dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [_shareAchtionSheet dismissWithClickedButtonIndex:0 animated:YES];
    }
}

// GeneralSearchViewDelegate
- (void)didGeneralSearchViewClicked {
    
    [self doShowShareView];
}

// UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return MIN(1, [bookTitle count]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"BookIntroduceTableViewCell";
    BookIntroduceTableViewCell *cell = (BookIntroduceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (BookIntroduceTableViewCell *)[nibContents objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if ([bookTitle count] <= 0) {
            
            return nil;
        }
        
        migsBookIntroduce *bookIntro = [bookTitle objectAtIndex:0];
        [cell initialize:bookIntro];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
