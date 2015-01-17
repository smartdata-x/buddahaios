//
//  ReadingView.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/23.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "ReadingViewController.h"
#import "PFileDownLoadManager.h"
#import "BookDetailViewController.h"
#import "IntroduceChapterTableViewCell.h"
#import "DatabaseManager.h"

@implementation migsChapterInfo

+ (migsChapterInfo *)setupChapterinfoByDictionay:(NSDictionary *)dic {
    
    migsChapterInfo *ret = [[migsChapterInfo alloc] init];
    
    int nbookid = [[dic objectForKey:@"bookid"] intValue];
    int nchapterid = [[dic objectForKey:@"id"] intValue];
    NSString *bookid = [NSString stringWithFormat:@"%d", nbookid];
    NSString *chapterid = [NSString stringWithFormat:@"%d", nchapterid];
    NSString *chaptername = [dic objectForKey:@"name"];
    NSString *chapterurl = [dic objectForKey:@"url"];
    
    ret.bookid = bookid;
    ret.chapterid = chapterid;
    ret.chaptername = chaptername;
    ret.chapterurl = chapterurl;
    
    return ret;
}

@end

@implementation ReadingViewController

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getChapterListFailed:) name:MigNetNameGetChapterListFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getChapterListSuccess:) name:MigNetNameGetChapterListSuccess object:nil];
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetChapterListFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetChapterListSuccess object:nil];
}

- (void)initialize:(NSString *)bookname BookId:(NSString *)bookid BookToken:(NSString *)booktoken{
    
    fontSize = 36;
    isFullScreen = YES;
    curChapter = 0;
    curPage = 0;
    pageAnimate = YES;
    needDoNextInAppear = NO;
    
    mBookname = bookname;
    mBookid = bookid;
    mBooktoken = booktoken;
    
    viewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    if (_pfm == nil) {
        
        _pfm = [[PFileManager alloc] init];
    }
    
    if (_chapterArray == nil) {
        
        _chapterArray = [[NSMutableArray alloc] init];
    }
    
    // 开始获取章节内容，获取完章节内容后检查阅读进度
    [self getChapterList:booktoken ID:mBookid];
}

- (void)initWithChapterArray:(NSString *)bookname Chapter:(NSArray *)chapters StartChapter:(int)startchapter UseProcess:(BOOL)useprocess {
    
    fontSize = 36;
    isFullScreen = YES;
    curChapter = 0;
    curPage = 0;
    pageAnimate = YES;
    useProcess = useprocess;
    needDoNextInAppear = NO;
    
    mBookname = bookname;
    
    viewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    if (_pfm == nil) {
        
        _pfm = [[PFileManager alloc] init];
    }
    
    if (_chapterArray == nil) {
        
        _chapterArray = [[NSMutableArray alloc] init];
    }
    
    // 初始化章节信息
    for (int i=0; i<[chapters count]; i++) {
        
        migsIntroduceChapterInfo *curchapter = (migsIntroduceChapterInfo *)[chapters objectAtIndex:i];
            
        migsChapterInfo *chapterinfo = [[migsChapterInfo alloc] init];
        chapterinfo.chaptername = curchapter.name;
        chapterinfo.chapterurl = curchapter.url;
        chapterinfo.chapterid = curchapter.index;
        [_chapterArray addObject:chapterinfo];
    }
    allChapter = [_chapterArray count];
    
    // 从章节进入，则认为不需要进度信息，即从该章节开始
    if (useprocess) {
        
        // 获取阅读进度
        readingProcess = [self getReadingProcessByName:mBookname];
        if (readingProcess && readingProcess.chapter && readingProcess.page) {
            
            // 跳转到当前页面
            [self jumpToReadingProcess];
            
            return;
        }
    }
    
    // 没有阅读进度，开始第一章
    if ([_chapterArray count] > 0) {
        
        curChapter = startchapter - 1;
        [self doGotoNextChapter:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self setIsFullScreen];
    
    if (needDoNextInAppear) {
        
        [self doNextPage:nil];
        needDoNextInAppear = NO;
    }
}

- (void)doDownloadBook:(NSString *)url ToFile:(NSString *)tofile {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doDownloadBookFailed) name:MigLocalNameDownloadFileFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doDownloadBookSuccess) name:MigLocalNameDownloadFileSuccess object:nil];
    
    PFileDownLoadManager *downloader = [[PFileDownLoadManager alloc] init];
    [downloader downloadFromURL:url to:tofile indir:@"book"];
}

- (void)doDownloadBookFailed {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigLocalNameDownloadFileFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigLocalNameDownloadFileSuccess object:nil];
}

- (void)doDownloadBookSuccess {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigLocalNameDownloadFileFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigLocalNameDownloadFileSuccess object:nil];
    
    // 下载成功, 获取内容
    [self getFileContent:curChapterFilename];
    
    [self initView:viewFrame];
    
    if (!MIG_IS_EMPTY_STRING(curContent))
    {
        curPage = -1;
        [self doNextPage:nil];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:YES];
    
    if (viewWrapper == nil) {
        
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        viewWrapper = [[UIView alloc] initWithFrame:frame];
        [viewWrapper setBackgroundColor:MIG_COLOR_D4D4D4];
    }
    [self.view addSubview:viewWrapper];
    //[self.view.window addSubview:viewWrapper];
    
    [self initView:viewFrame];
    
    // 左翻页
    UISwipeGestureRecognizer *nextGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doNextPage:)];
    nextGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    nextGesture.delegate = self;
    [self.view addGestureRecognizer:nextGesture];
    
    // 右翻页
    UISwipeGestureRecognizer *prevGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doPreviousPage:)];
    prevGesture.direction = UISwipeGestureRecognizerDirectionRight;
    prevGesture.delegate = self;
    [self.view addGestureRecognizer:prevGesture];
    
    // 点击
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    // 退出之前记录阅读信息
    [self recordReadingProcess];
}

- (void)getFileContent:(NSString *)filename {
    
    NSString *fullpath = [_pfm getFullPathFromBookDir:filename];
    
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
    NSData *strdata = [NSData dataWithContentsOfFile:fullpath];
    
    MIGDEBUG_PRINT(@"文件路径:%@", fullpath);
    
    curContent = [[NSString alloc] initWithData:strdata encoding:encode];
    
    // 没有得到内容，采用其他编码
    if (MIG_IS_EMPTY_STRING(curContent)) {
        
        encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        curContent = [[NSString alloc] initWithData:strdata encoding:encode];
    }
    
    if (MIG_IS_EMPTY_STRING(curContent)) {
        
        encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_2312_80);
        curContent = [[NSString alloc] initWithData:strdata encoding:encode];
    }
    
    if (MIG_IS_EMPTY_STRING(curContent)) {
        
        encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGBK_95);
        curContent = [[NSString alloc] initWithData:strdata encoding:encode];
    }
}

- (void)doGotoNextChapter:(BOOL)forceDownload {
    
    if (curChapter >= allChapter - 1) {
        
        // 最后一章
        [SVProgressHUD showErrorWithStatus:MIGTIP_BOOKEND];
        MIGDEBUG_PRINT(@"最后一章");
        return;
    }
    
#if MIG_DEBUG_TEST
    //forceDownload = YES;
#endif
    
    curChapter++;
    migsChapterInfo *chapterinfo = [_chapterArray objectAtIndex:curChapter];
    curChapterFilename = [NSString stringWithFormat:@"%@_%d.txt", mBookname, curChapter];
    
    NSString *mension = nil;
    if (curChapter == 0) {
        
        mension = [NSString stringWithFormat:@"第一章\n%@", chapterinfo.chaptername];
    }
    else {
        
        mension = [NSString stringWithFormat:@"下一章\n%@", chapterinfo.chaptername];
    }
    [SVProgressHUD showSuccessWithStatus:mension];
    
    if (!forceDownload && [_pfm isFileExistInBookDir:curChapterFilename]) {
        
        [self getFileContent:curChapterFilename];
        [self initView:viewFrame];
        
        if (!MIG_IS_EMPTY_STRING(curContent))
        {
            curPage = -1;
            [self doNextPage:nil];
        }
        
        // 记录阅读进度
        [self recordReadingProcess];
    }
    else {
        
        migsChapterInfo *chapterinfo = [_chapterArray objectAtIndex:curChapter];
        [self doDownloadBook:chapterinfo.chapterurl ToFile:curChapterFilename];
    }
}

- (void)doGotoPreviousChapter {
    
    if (curChapter == 0) {
        
        MIGDEBUG_PRINT(@"第一章");
        return;
    }
    
    curChapter--;
    curChapterFilename = [NSString stringWithFormat:@"%@_%d.txt", mBookname, curChapter];
    
    // 上一章一定存在，直接载入
    [self getFileContent:curChapterFilename];
    [self initView:viewFrame];
    
    //[Utilities curlRight:self.view];
    
    curPage = allPage;
    [self doPreviousPage:nil];
    
    // 记录阅读进度
    [self recordReadingProcess];
}

- (void)initView:(CGRect)frame {
    
#if MIG_DEBUG_TEST
#if 0
    curContent = @"1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16\n17\n18\n19\n20\n21\n22\n23\n24\n25\n26\n27\n28\n29\n30\n31\n32\n33\n34\n35\n36\n37\n38\n39\n40\n41\n42\n43\n44\n45\n46\n47\n48\n49\n50\n51\n52\n53\n54\n55\n56\n57\n58\n59\n60\n61\n62\n63\n64\n65\n66\n67\n68\n69\n70\n";
#endif
#endif
    
    if (MIG_IS_EMPTY_STRING(curContent)) {
        
        // 没有内容则返回
        return;
    }
    
    float ystart = 31; // 为了给顶部留出空间的默认值
    float padding = 16; // UITextView的上下左右各有8个padding
    
    float maxViewHeight = frame.size.height - ystart - padding;
    int linenumber = maxViewHeight / fontSize; // 行数取整
    
    float realViewHeight = linenumber * fontSize + padding;
    ystart = frame.size.height - realViewHeight;
    
    float lineheight = fontSize; // 行间距和字体大小一样大
    UIFont *textfont = [UIFont fontOfApp:fontSize / SCREEN_SCALAR];
    
    if (_textView == nil) {
        
        CGRect textFrame = CGRectMake(0, ystart, frame.size.width, frame.size.height - ystart);
        _textView = [[UITextView alloc] initWithFrame:textFrame];
        [viewWrapper addSubview:_textView];
        //[self.view.window addSubview:_textView];
    }
    
    _textView.font = textfont;
    _textView.textColor = MIG_COLOR_111111;
    _textView.editable = NO;
    [_textView setUserInteractionEnabled:NO];
    [_textView setContentOffset:CGPointMake(0, 0)];
    [_textView setBackgroundColor:[UIColor clearColor]];
    _textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    NSMutableParagraphStyle *parastyle = [[NSMutableParagraphStyle alloc] init];
    parastyle.lineHeightMultiple = 20;
    parastyle.maximumLineHeight = lineheight;
    parastyle.minimumLineHeight = lineheight;
    parastyle.firstLineHeadIndent = 20;
    parastyle.alignment = NSTextAlignmentJustified;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontOfApp:fontSize / SCREEN_SCALAR], NSParagraphStyleAttributeName:parastyle, NSForegroundColorAttributeName:MIG_COLOR_111111};
    
    _textView.attributedText = [[NSAttributedString alloc] initWithString:curContent attributes:attributes];
    
    // 计算翻页大小和所有页数
    pageHeight = realViewHeight - padding; // 翻页大小和padding无关
    
    CGRect maxRect = CGRectMake(0, 0, frame.size.width, MAXFLOAT);
    float textheight = [Utilities heightForAttributedString:_textView.attributedText Font:textfont Frame:maxRect];
    //float textheight = [Utilities heightForString:curContent Font:textfont Frame:maxRect];
    
    allPage = ceilf(textheight / pageHeight + 0.5);
    
    [self initTopView:viewFrame];
}

- (void)initTopView:(CGRect)frame {
    
    if (_chapterArray == nil) {
        
        return;
    }
    float ystart = 0;
    
    float lblheight = 21;
    migsChapterInfo *chapterinfo = [_chapterArray objectAtIndex:curChapter];
    
    CGRect nameframe = CGRectMake(20, ystart, frame.size.width / 3, lblheight);
    CGRect chapterframe = CGRectMake( frame.size.width - frame.size.width / 3 - 20, ystart, frame.size.width / 3, lblheight);
    
    if (_lblBookName == nil) {
        
        _lblBookName = [[UILabel alloc] initWithFrame:nameframe];
        [_lblBookName setFont:[UIFont fontOfApp:25 / SCREEN_SCALAR]];
        [_lblBookName setTextColor:MIG_COLOR_111111];
        [_lblBookName setTextAlignment:NSTextAlignmentLeft];
        [viewWrapper addSubview:_lblBookName];
    }
    [_lblBookName setFrame:nameframe];
    NSString *bookname = [NSString stringWithFormat:@"《%@》", mBookname];
    [_lblBookName setText:bookname];
    
    if (_lblChapterName == nil) {
        
        _lblChapterName = [[UILabel alloc] initWithFrame:chapterframe];
        [_lblChapterName setFont:[UIFont fontOfApp:25 / SCREEN_SCALAR]];
        [_lblChapterName setTextColor:MIG_COLOR_111111];
        [_lblChapterName setTextAlignment:NSTextAlignmentRight];
        [viewWrapper addSubview:_lblChapterName];
    }
    [_lblChapterName setFrame:chapterframe];
    [_lblChapterName setText:chapterinfo.chaptername];
}

- (void)doNextPage:(UISwipeGestureRecognizer *)swipGesture {
    
    // 设置textview的显示区域
    if (curPage >= allPage - 1) {
        
        // 本章最后一页，载入下一章
        [SVProgressHUD showSuccessWithStatus:MIGTIP_CHAPTEREND];
        [self doGotoNextChapter:NO];
        return;
    }
    
    curPage++;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    CGPoint offset = CGPointMake(0, curPage * pageHeight);
    [_textView setContentOffset:offset animated:pageAnimate];
    [UIView commitAnimations];
    
    if (pageAnimate) {
        
        [Utilities curlLeft:self.view];
    }
}

- (void)doPreviousPage:(UISwipeGestureRecognizer *)swipGesture {
    
    if (curPage == 0) {
        
        // 第一页, 载入上一章
        [self doGotoPreviousChapter];
        return;
    }
    
    curPage--;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    CGPoint offset = CGPointMake(0, curPage * pageHeight);
    [_textView setContentOffset:offset animated:pageAnimate];
    [UIView commitAnimations];
    
    if (pageAnimate) {
        
        [Utilities curlRight:self.view];
    }
}

- (void)getChapterList:(NSString *)booktoken ID:(NSString *)bookid {
    
    AskNetDataApi *api = [[AskNetDataApi alloc] init];
    
    [api doGetChapterList:booktoken BookID:bookid];
}

- (void)getChapterListFailed:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取章节信息失败");
}

- (void)getChapterListSuccess:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取章节信息成功");
    
    NSDictionary *userinfo = notification.userInfo;
    NSDictionary *result = [userinfo objectForKey:@"result"];
    NSDictionary *list = [result objectForKey:@"list"];
    
    for (NSDictionary *dic in list) {
        
        migsChapterInfo *chapterinfo = [migsChapterInfo setupChapterinfoByDictionay:dic];
        [_chapterArray addObject:chapterinfo];
    }
    allChapter = [_chapterArray count];
    
    // 获取阅读进度
    readingProcess = [self getReadingProcessByID:mBookid];
    if (readingProcess && readingProcess.chapter && readingProcess.page) {
        
        // 跳转到当前页面
        [self jumpToReadingProcess];
        
        return;
    }
    
    // 没有进度，开始第一章
    if ([_chapterArray count] > 0) {
        
        curChapter = -1;
        [self doGotoNextChapter:NO];
    }
}

- (void)recordReadingProcess {
    
    if (readingProcess == nil) {
        
        readingProcess = [[migsReadingProcess alloc] init];
    }
    
    if (curChapter < 0) {
        
        curChapter = 0;
    }
    
    if (curPage > allPage - 1) {
        
        curPage = allPage - 1;
    }
    
    if (curPage < 0) {
        
        curPage = 0;
    }
    
    readingProcess.bookname = mBookname;
    readingProcess.bookid = mBookid;
    readingProcess.chapter = [NSString stringWithFormat:@"%d", curChapter];
    readingProcess.page = [NSString stringWithFormat:@"%d", curPage];
    
    [[DatabaseManager GetInstance] insertReadingProcess:readingProcess];
}

- (migsReadingProcess *)getReadingProcessByID:(NSString *)bookid {
    
    return [[DatabaseManager GetInstance] getReadingProcessByID:bookid];
}

- (migsReadingProcess *)getReadingProcessByName:(NSString *)bookname {
    
    return [[DatabaseManager GetInstance] getReadingProcessByName:bookname];
}

- (void)jumpToReadingProcess {
    
    if (readingProcess == nil) {
        
        return;
    }
    
    // 有阅读进度，则一定阅读了，所以本地存有文件，无需下载
    curChapter = [readingProcess.chapter intValue];
    curPage = [readingProcess.page intValue] - 1;
    int saveChapter = curChapter;
    int savePage = curPage;
    
    migsChapterInfo *chapterinfo = [_chapterArray objectAtIndex:curChapter];
    curChapterFilename = [NSString stringWithFormat:@"%@_%d.txt", mBookname, curChapter];
    
    NSString *mension = nil;
    if (curChapter == 0) {
        
        mension = [NSString stringWithFormat:@"第一章\n%@", chapterinfo.chaptername];
    }
    else {
        
        mension = [NSString stringWithFormat:@"开始\n%@", chapterinfo.chaptername];
    }
    [SVProgressHUD showSuccessWithStatus:mension];
    
    if ([_pfm isFileExistInBookDir:curChapterFilename]) {
        
#if 0
        // 重置一次章节
        curChapter = saveChapter - 1;
        [self doGotoNextChapter:NO];
        
        // 重置一次页数
        pageAnimate = NO;
        for (int i=0; i<savePage; i++) {
            
            [self doNextPage:nil];
        }
        pageAnimate = YES;
        
        // 回存一次数据
        readingProcess.chapter = [NSString stringWithFormat:@"%d", saveChapter];
        readingProcess.page = [NSString stringWithFormat:@"%d", savePage];
        [self recordReadingProcess];
#else
        
        [self getFileContent:curChapterFilename];
        [self initView:viewFrame];
        
        if (!MIG_IS_EMPTY_STRING(curContent))
        {
            // TODO: 检查是否越界
            if (curPage >= allPage - 1) {
                
                
            }
            
            //[UIView beginAnimations:nil context:nil];
            //[UIView setAnimationDuration:0.1];
            CGPoint offset = CGPointMake(0, curPage * pageHeight);
            [_textView setContentOffset:offset animated:NO];
            
            needDoNextInAppear = YES;
            //[UIView commitAnimations];
            
            //[Utilities curlLeft:self.view];
        }
#endif
    }
    else {
        
        // 从进度获取到的信息，所以此处应该不会执行
        migsChapterInfo *chapterinfo = [_chapterArray objectAtIndex:curChapter];
        [self doDownloadBook:chapterinfo.chapterurl ToFile:curChapterFilename];
    }
}

- (void)doTap:(UITapGestureRecognizer *)tapGesture {
    
    isFullScreen = !isFullScreen;
    
    [self setIsFullScreen];
}

- (void)setIsFullScreen {
    
    [self.navigationController setNavigationBarHidden:isFullScreen animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:isFullScreen withAnimation:YES];
    
    MIGDEBUG_PRINT(@"wrapper y:%f, text y:%f", viewWrapper.frame.origin.y, _textView.frame.origin.y);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
