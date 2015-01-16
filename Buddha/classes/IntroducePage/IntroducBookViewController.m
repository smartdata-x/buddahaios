//
//  IntroducBookViewController.m
//  Buddha
//
//  Created by Archer_LJ on 15/1/10.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "IntroducBookViewController.h"
#import "IntroduceChapterTableViewCell.h"
#import "LoginManager.h"
#import "ReadingViewController.h"

@interface IntroducBookViewController ()

@end

@implementation IntroducBookViewController

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doGetHisAndThrFailed:) name:MigNetNameGetHisAndThrFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doGetHisAndThrSuccess:) name:MigNetNameGetHisAndThrSuccess object:nil];
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetHisAndThrFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetHisAndThrSuccess object:nil];
}

- (void)initialize:(migsBookIntroduce *)bookIntro {
    
    _bookInfo = bookIntro;
    [self initNavView];
    
    if (bookIntro) {
        
        if (headerTableInfo == nil) {
            
            headerTableInfo = [[NSMutableArray alloc] init];
        }
        else {
            
            [headerTableInfo removeAllObjects];
        }
        [headerTableInfo addObject:bookIntro];
        [headerTableView reloadData];
    }
    
    [self doGetHisAndThr:_bookInfo.bookid];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (headerTableInfo == nil) {
        
        headerTableInfo = [[NSMutableArray alloc] init];
    }
    
    if (chapterTableInfo == nil) {
        
        chapterTableInfo = [[NSMutableArray alloc] init];
    }
    
    if (_bookDetailInfo == nil) {
        
        _bookDetailInfo = [[migsBookDetailInformation alloc] init];
    }
    
    if (rootViewWrapper == nil) {
        
        rootViewWrapper = [[UIView alloc] initWithFrame:self.view.frame];
    }
    [self.view addSubview:rootViewWrapper];
    
    if (viewWrapper == nil) {
        
        viewWrapper = [[UIScrollView alloc] initWithFrame:self.view.frame];
    }
    [rootViewWrapper addSubview:viewWrapper];
    
    [self initView];
}

- (void)initView {
    
    float ystart = 0.0;
    [self initHeaderTableView:ystart];
    
    ystart += 80 + 32 / SCREEN_SCALAR;
    [self initInfomationView:&ystart];
    
    [self initChapterTableView:ystart];
}

- (void)initNavView {
    
    self.title = _bookInfo.name;
}

- (void)initHeaderTableView:(float)ystart {
    
    if (headerTableInfo == nil) {
        
        headerTableInfo = [[NSMutableArray alloc] init];
    }
    
    if (headerTableView == nil) {

        CGRect frame = CGRectMake(0, ystart, self.view.frame.size.width, 80);
        headerTableView = [[UITableView alloc] initWithFrame:frame];
    }
    
    headerTableView.dataSource = self;
    headerTableView.delegate = self;
    [headerTableView setScrollEnabled:NO];
    [viewWrapper addSubview:headerTableView];
}

- (void)initInfomationView:(float*)ystart {
    
    // 阅读按钮
    float btnWidth = (self.view.frame.size.width - 32 - 10) / 2;
    float btnHeight = 80 / SCREEN_SCALAR;
    if (btnRead == nil) {
        
        CGRect frame = CGRectMake(32 / SCREEN_SCALAR, *ystart, btnWidth, btnHeight);
        btnRead = [[UIButton alloc] initWithFrame:frame];
        [btnRead setTitle:@"阅读" forState:UIControlStateNormal];
        [btnRead setBackgroundColor:MIG_COLOR_F6F6F6];
        [btnRead setTitleColor:MIG_COLOR_333333 forState:UIControlStateNormal];
        [btnRead.titleLabel setFont:[UIFont fontOfApp:30 / SCREEN_SCALAR]];
        [btnRead addTarget:self action:@selector(doGotoReadingView:) forControlEvents:UIControlEventTouchUpInside];
    }
    [viewWrapper addSubview:btnRead];
    
    // 分享按钮
    if (shareView == nil) {
        
        float xstart = 32 / SCREEN_SCALAR + btnWidth + 10;
        CGRect frame = CGRectMake(xstart, *ystart, btnWidth, btnHeight);
        shareView = [[GeneralSearchView alloc] initWithFrame:frame BgImg:IMG_COLOR_BG_FBFBFB IconImg:IMG_INTRO_SHARE Content:@"分享" Font:[UIFont fontOfApp:30 / SCREEN_SCALAR]];
    }
    shareView.delegate = self;
    [viewWrapper addSubview:shareView];
    
    if (detailInfoView == nil) {
        
        CGRect frame = CGRectMake(0, *ystart + 80 / SCREEN_SCALAR + 10, self.view.frame.size.width, 140);
        detailInfoView = [[UILabel alloc] initWithFrame:frame];
        [detailInfoView setTextColor:MIG_COLOR_808080];
        [detailInfoView setFont:[UIFont fontOfApp:26 / SCREEN_SCALAR]];
        [detailInfoView setTextAlignment:NSTextAlignmentLeft];
        [detailInfoView setNumberOfLines:0];
        
    }
    [viewWrapper addSubview:detailInfoView];
    [detailInfoView setText:_bookDetailInfo.bookSummary];
    
#if 0
    CGRect curFrame = CGRectMake(detailInfoView.frame.origin.x, detailInfoView.frame.origin.y, detailInfoView.frame.size.width, MAXFLOAT);
    float height = [Utilities heightForString:_bookDetailInfo.bookSummary Font:[UIFont fontOfApp:26 / SCREEN_SCALAR] Frame:curFrame];
    
    if (height < 240) {
        
        curFrame = CGRectMake(detailInfoView.frame.origin.x, detailInfoView.frame.origin.y, detailInfoView.frame.size.width, height);
        detailInfoView.frame = curFrame;
    }
#endif
    
    *ystart += 140;
}

- (void)initChapterTableView:(float)ystart {
    
    if (chapterTableInfo == nil) {
        
        chapterTableInfo = [[NSMutableArray alloc] init];
    }
    
    if (chapterTableView == nil) {
        
        CGRect frame = CGRectMake(0, ystart, self.view.frame.size.width, self.view.frame.size.height - ystart);
        chapterTableView = [[UITableView alloc] initWithFrame:frame];
        chapterTableView.delegate = self;
        chapterTableView.dataSource = self;
        
        [viewWrapper addSubview:chapterTableView];
    }
}

- (void)reloadData {
    
    [headerTableView reloadData];
    [chapterTableView reloadData];
    [detailInfoView setText:_bookDetailInfo.bookSummary];
}

- (IBAction)doGotoReadingView:(id)sender {
    
    MIGDEBUG_PRINT(@"前往阅读");
    
    BOOL useprocess = NO;
    
    // 有sender的话，则是阅读按钮
    if (sender != nil) {
        
        startChapter = 0;
        // 阅读按钮需要进度
        useprocess = YES;
    }
    
    ReadingViewController *readingView = [[ReadingViewController alloc] init];
    [readingView initWithChapterArray:_bookInfo.name Chapter:chapterTableInfo StartChapter:startChapter UseProcess:useprocess];
    [self.navigationController pushViewController:readingView animated:YES];
}

- (void)doGotoShare:(UIGestureRecognizer *)gesture {
    
    MIGDEBUG_PRINT(@"分享");
    
    if (_bookShareView == nil) {
        
        float height = 250 / SCREEN_SCALAR;
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, height);
        _bookShareView = [[GeneralShareView alloc] initWithFrame:frame];
        _bookShareView.delegate = self;
    }
    
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

- (void)doGetHisAndThr:(NSString *)type {
    
    AskNetDataApi *api = [[AskNetDataApi alloc] init];
    [api doGetHisAndThr:type];
}

- (void)doGetHisAndThrFailed:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取介绍书籍失败");
}

- (void)doGetHisAndThrSuccess:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取介绍书籍成功");
    
    NSDictionary *userinfo = notification.userInfo;
    NSDictionary *result = [userinfo objectForKey:@"result"];
    
    NSDictionary *summary = [result objectForKey:@"summary"];
    NSString *pic = [summary objectForKey:@"pic"];
    NSString *chapter = [summary objectForKey:@"chapter"];
    NSString *sum = [summary objectForKey:@"summary"];
    _bookDetailInfo.imgURL = pic;
    _bookDetailInfo.Chapters = chapter;
    _bookDetailInfo.bookSummary = sum;
    
    NSDictionary *list = [result objectForKey:@"list"];
    if ([list count] > 0) {
        
        [chapterTableInfo removeAllObjects];
    }
    for (NSDictionary *dic in list) {
        
        migsIntroduceChapterInfo *info = [migsIntroduceChapterInfo initWithDictionay:dic];
        [chapterTableInfo addObject:info];
    }
    
    [self reloadData];
}

// GeneralShareViewDelegate
- (void)didGeneralSearchViewClicked {
    
    [self doGotoShare:nil];
}

// UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == headerTableView) {
        
        return MIN(1, [headerTableInfo count]);
    }
    else if (tableView == chapterTableView) {
        
        return [chapterTableInfo count];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == headerTableView) {
        
        return 80;
    }
    else if (tableView == chapterTableView) {
        
        return 96 / SCREEN_SCALAR;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == headerTableView) {
        
        NSString *cellIdentifier = @"BookIntroduceTableViewCell";
        BookIntroduceTableViewCell *cell = (BookIntroduceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = (BookIntroduceTableViewCell *)[nibContents objectAtIndex:0];
            cell.backgroundColor = [UIColor clearColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if ([headerTableInfo count] <= 0) {
                
                return nil;
            }
            
            migsBookIntroduce *bookIntro = [headerTableInfo objectAtIndex:0];
            [cell initialize:bookIntro];
        }
        
        return cell;
    }
    else if (tableView == chapterTableView) {
        
        NSString *cellIdentifier = @"IntroduceChapterTableViewCell";
        IntroduceChapterTableViewCell *cell = (IntroduceChapterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = (IntroduceChapterTableViewCell *)[nibContents objectAtIndex:0];
            cell.backgroundColor = [UIColor clearColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if ([chapterTableInfo count] <= 0) {
                
                return nil;
            }
            
            migsIntroduceChapterInfo *chapterIntro = [chapterTableInfo objectAtIndex:indexPath.row];
            [cell initWithContent:chapterIntro.name];
        }
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = indexPath.row;
    
    if (tableView == headerTableView) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    else {
        
        // 进入阅读界面
        startChapter = row;
        [self doGotoReadingView:nil];
    
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
