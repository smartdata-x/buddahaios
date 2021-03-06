//
//  LoginViewController.m
//  Buddha
//
//  Created by Archer_LJ on 14/11/25.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginTableViewCell.h"
#import "LoginManager.h"
#import "BookDetailViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        self.titleText = @"登录";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doLoginSuccess) name:MigLocalNameLoginSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doLoginFailed) name:MigLocalNameLoginFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doGetBookListFailed:) name:MigNetNameGetBookListFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doGetBookListSuccess:) name:MigNetNameGetBookListSuccess object:nil];
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigLocalNameLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigLocalNameLoginFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetBookListFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetBookListSuccess object:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 改变背景色
    [self.view setBackgroundColor:MIG_COLOR_FBFBFB];
    
    // logo
    float ystart = mMainFrame.origin.y + 52.0 / SCREEN_SCALAR;
    float logoHeight = 219.0 / SCREEN_SCALAR;
    float logoWidth = 345.0 / SCREEN_SCALAR;
    float logoxstart = (mMainFrame.size.width - logoWidth) / 2.0;
    UIImageView *logoImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_LOGIN_LOGO]];
    logoImgView.frame = CGRectMake(logoxstart, ystart, logoWidth, logoHeight);
    [self.view addSubview:logoImgView];
    
    ystart += logoHeight + 52.0 / SCREEN_SCALAR;
    
    // 登陆框
    if (tableInfoArray == nil) {
        
        NSArray *infoArray = @[@{KEY_IMAGE:IMG_LOGIN_QQ,
                                 KEY_TITLE:@"QQ登录"},
                               
                               @{KEY_IMAGE:IMG_LOGIN_WEIBO,
                                 KEY_TITLE:@"新浪微博登录"},
                               
                               @{KEY_IMAGE:IMG_LOGIN_WEIXIN,
                                 KEY_TITLE:@"微信登录"}
                               ];
        tableInfoArray = [[NSMutableArray alloc] init];
        [tableInfoArray addObjectsFromArray:infoArray];
    }
    
    if (loginMenuTableView == nil) {
        
        loginMenuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ystart, mMainFrame.size.width, 88 * 3 / SCREEN_SCALAR)];
        loginMenuTableView.delegate = self;
        loginMenuTableView.dataSource = self;
        [loginMenuTableView setBackgroundColor:[UIColor whiteColor]];
    }
    
    [self.view addSubview:loginMenuTableView];
}

- (void)doBack:(id)sender {
    
    // 如果用户登录或者采用快速登录, 登录成功后才能返回
    if ([UserLoginInfoManager GetInstance].isLogin ||
        [UserLoginInfoManager GetInstance].isQuickLogin) {
        
        [super doBack:sender];
    }
    else {
        
        [SVProgressHUD showErrorWithStatus:MIGTIP_LOGIN_NOTLOGIN];
    }
}

- (void)doLoginSuccess {
    
    // 登陆成功, 更新一次书单
    [self doGetBookList];
    
    [SVProgressHUD showSuccessWithStatus:MIGTIP_LOGIN_SUCCESS];
    [[NSNotificationCenter defaultCenter] postNotificationName:MigLocalNameLoginSuccessReturn object:nil userInfo:nil];
}

- (void)doLoginFailed {
    
    [SVProgressHUD showErrorWithStatus:MIGTIP_LOGIN_FAILED];
}

- (void)doGetBookList {
    
    AskNetDataApi *api = [[AskNetDataApi alloc] init];
    [api doGetBookList];
}

- (void)doGetBookListFailed:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取书单失败");
    
    // 无论成功与否都需要返回
    [self doBack:nil];
}

- (void)doGetBookListSuccess:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取书单成功");
    // 清除原有书单信息
    [[DatabaseManager GetInstance] removeAllBooks];
    
    NSDictionary *userinfo = notification.userInfo;
    NSDictionary *result = [userinfo objectForKey:@"result"];
    NSDictionary *list = [result objectForKey:@"list"];
    
    for (NSDictionary *dic in list) {
        
        int nbookid = [[dic objectForKey:@"id"] intValue];
        int ntype = [[dic objectForKey:@"type"] intValue];
        NSString *bookid = [NSString stringWithFormat:@"%d", nbookid];
        NSString *booktype = [NSString stringWithFormat:@"%d", ntype];
        NSString *bookname = [dic objectForKey:@"name"];
        NSString *bookurl = [dic objectForKey:@"pic"];
        NSString *booktoken = [dic objectForKey:@"booktoken"];
        
        migsBookDetailInformation *detail = [[migsBookDetailInformation alloc] init];
        detail.bookname = bookname;
        detail.bookid = bookid;
        detail.booktype = booktype;
        detail.booktoken = booktoken;
        detail.imgURL = bookurl;
        
        [[DatabaseManager GetInstance] insertBookInfo:detail];
    }
    
    // 无论成功与否都需要返回
    [self doBack:nil];
}

// UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 88.0 / SCREEN_SCALAR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int curRow = indexPath.row;
    NSDictionary *dicInfo = [tableInfoArray objectAtIndex:curRow];
    NSString *imgName = [dicInfo objectForKey:KEY_IMAGE];
    NSString *title = [dicInfo objectForKey:KEY_TITLE];
    NSString *cellIdentifier = @"LoginTableViewCell";
    
    LoginTableViewCell *cell = (LoginTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (LoginTableViewCell *)[nibContents objectAtIndex:0];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.lblTitle.text = title;
        cell.lblTitle.font = [UIFont fontOfApp:30.0 / SCREEN_SCALAR];
        cell.lblTitle.textColor = MIG_COLOR_333333;
        cell.lblTitle.textAlignment = NSTextAlignmentLeft;
        
        cell.logoImgView.image = [UIImage imageNamed:imgName];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = indexPath.row;
    
    switch (row) {
        case 0:
            [[LoginManager GetInstance] doTencentQQLogin];
            //[[LoginManager GetInstance] doQuickLogin];
            break;
            
        case 1:
            [[LoginManager GetInstance] doSinaWeiboLogin];
            break;
            
        case 2:
            [[LoginManager GetInstance] doTencentWeixinLogin];
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [tableInfoArray count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
