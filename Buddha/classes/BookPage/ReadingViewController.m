//
//  ReadingView.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/23.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "ReadingViewController.h"
#import "PFileManager.h"
#import "PFileDownLoadManager.h"
#import "BookDetailViewController.h"

@implementation ReadingViewController

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        
    }
    
    return self;
}

- (void)initialize:(NSString *)filename fileurl:(NSString *)fileURL{
    
    _fileName = filename;
    _fileURL = fileURL;
    isFullScreen = YES;
    
    // 检查文件是否存在，如果存在则继续，不存在就下载
    PFileManager *pfm = [[PFileManager alloc] init];
    if ([pfm isFileExistInDocument:_fileName]) {
        
        [self initView:self.view.frame];
    }
    else {
        
        [self doDownloadBook];
    }
}

- (void)doDownloadBook {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doDownloadBookFailed) name:MigLocalNameDownloadFileFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doDownloadBookSuccess) name:MigLocalNameDownloadFileSuccess object:nil];
    
    PFileDownLoadManager *downloader = [[PFileDownLoadManager alloc] init];
    [downloader downloadFromURL:_fileURL to:_fileName];
}

- (void)doDownloadBookFailed {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigLocalNameDownloadFileFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigLocalNameDownloadFileSuccess object:nil];
}

- (void)doDownloadBookSuccess {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigLocalNameDownloadFileFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigLocalNameDownloadFileSuccess object:nil];
    
    [self initView:self.view.frame];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (viewWrapper == nil) {
        
        viewWrapper = [[UIView alloc] initWithFrame:self.view.frame];
        [viewWrapper setBackgroundColor:[UIColor clearColor]];
    }
    [self.view addSubview:viewWrapper];
    
    [self initView:self.view.frame];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self setIsFullScreen];
}

- (void)getFileContent {
    
    PFileManager *pfm = [[PFileManager alloc] init];
    NSString *fullpath = [pfm getFullPathFromDocument:_fileName];
    
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *strdata = [NSData dataWithContentsOfFile:fullpath];
    
    MIGDEBUG_PRINT(@"文件路径:%@", fullpath);
    
    _mainContent = [[NSString alloc] initWithData:strdata encoding:encode];
    // MIGDEBUG_PRINT(@"文件内容:%@", _mainContent);
}

- (void)initView:(CGRect)frame {
    
    if (_fileName == nil) {
        
        return;
    }
    
    // 获取文件内容
    PFileManager *pfm = [[PFileManager alloc] init];
    if ([pfm isFileExistInDocument:_fileName]) {
        
        [self getFileContent];
    }
    else {
        
        return;
    }
    
#if MIG_DEBUG_TEST
#if 0
    _mainContent = @"1<Title>三体</Title>\n2\n3<Author>刘慈欣</Author>\n4\n5\n6\n7\n8\n9<Chapter>第一部</Chapter>\n10\n11\n12\n13\n14\n15\n16\n17\n18\n19<Content>\n20\n21\n22\n23\n24\n25\n26\n27\n28\n29\n30\n31\n32\n33\n34\n35\n36\n37\n38\n39\n40\n41\n42\n43\n44\n45\n46\n47\n48\n49\n50\n51\n52\n53\n54\n55\n56\n57\n58\n59\n60\n61\n62\n63\n64\n65\n66\n67\n68\n69\n70</Content>\n";
#endif
#endif
    
    // 创建属性化显示字符串
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_mainContent];
    NSUInteger length = [_mainContent length];
    
    // 内容
    UIFont *baseFont = [UIFont fontOfApp:26 / SCREEN_SCALAR];
    [attrString addAttribute:NSFontAttributeName value:baseFont range:NSMakeRange(0, length)];
    // 作者
    UIFont *autherFont = [UIFont fontOfApp:50 / SCREEN_SCALAR];
    [attrString addAttribute:NSFontAttributeName value:autherFont range:NSMakeRange(0, length)];
    // 题目
    UIFont *titleFont = [UIFont fontOfApp:40 / SCREEN_SCALAR];
    [attrString addAttribute:NSFontAttributeName value:titleFont range:NSMakeRange(0, length)];
    // 章节
    UIFont *chapterFont = [UIFont fontOfApp:30 / SCREEN_SCALAR];
    [attrString addAttribute:NSFontAttributeName value:chapterFont range:NSMakeRange(0, length)];
    
    UIFont *textfont = [UIFont fontOfApp:26 / SCREEN_SCALAR];
    CGRect maxRect = CGRectMake(0, 0, frame.size.width, MAXFLOAT);
    float textheight = [Utilities heightForString:_mainContent Font:textfont Frame:maxRect];
    
    _pageHeight = frame.size.height + contentoffset;
    _allPage = ceilf(textheight / _pageHeight + 0.5) + 1;
    _curPage = 0;
    
    if (_textView == nil) {
        
        CGRect textFrame = frame;
        _textView = [[UITextView alloc] initWithFrame:textFrame];
    }
    _textView.text = _mainContent;
    _textView.font = textfont;
    _textView.textColor = MIG_COLOR_111111;
    _textView.editable = NO;
    [_textView setUserInteractionEnabled:NO];
    [_textView setContentOffset:CGPointMake(0, 0)];
    [_textView setBackgroundColor:[UIColor whiteColor]];
    _textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [viewWrapper addSubview:_textView];
    
    // 上翻页
    UISwipeGestureRecognizer *downToUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doNextPage:)];
    downToUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
    downToUpGesture.delegate = self;
    [self.view addGestureRecognizer:downToUpGesture];
    
    // 下翻页
    UISwipeGestureRecognizer *upToDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doPreviousPage:)];
    upToDownGesture.direction = UISwipeGestureRecognizerDirectionDown;
    upToDownGesture.delegate = self;
    [self.view addGestureRecognizer:upToDownGesture];
    
    // 点击
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)doNextPage:(UISwipeGestureRecognizer *)swipGesture {
    
    // 设置textview的显示区域
    if (_curPage >= _allPage - 1) {
        
        // 最后一页
        return;
    }
    
    _curPage++;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    CGPoint offset = CGPointMake(0, contentoffset + _curPage * _pageHeight);
    [_textView setContentOffset:offset animated:YES];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    [UIView commitAnimations];
}

- (void)doPreviousPage:(UISwipeGestureRecognizer *)swipGesture {
    
    if (_curPage == 0) {
        
        // 第一页
        return;
    }
    
    _curPage--;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    CGPoint offset = CGPointMake(0, contentoffset + _curPage * _pageHeight);
    if (_curPage == 0) {
        
        //offset = CGPointMake(0, -NAVIGATION_HEIGHT);
    }
    [_textView setContentOffset:offset animated:YES];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    [UIView commitAnimations];
}

- (void)doTap:(UITapGestureRecognizer *)tapGesture {
    
    isFullScreen = !isFullScreen;
    
    [self setIsFullScreen];
}

- (void)setIsFullScreen {
    
    if (isFullScreen) {
        
        contentoffset = 0;
    }
    else {
        
        contentoffset = -NAVIGATION_HEIGHT;
    }
    _pageHeight = self.view.frame.size.height + contentoffset;
    
    self.navigationController.navigationBarHidden = isFullScreen;
    [[UIApplication sharedApplication] setStatusBarHidden:isFullScreen withAnimation:YES];
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
