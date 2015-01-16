//
//  IntroducePageViewController.m
//  Buddha
//
//  Created by Archer_LJ on 15/1/10.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "IntroducePageViewController.h"
#import "BookCategoryViewController.h"
#import "IntroducBookViewController.h"
#import "ArtDisplayViewController.h"

@interface IntroducePageViewController ()

@end

@implementation IntroducePageViewController

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getIntroFailed:) name:MigNetNameGetIntroFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getIntroSuccess:) name:MigNetNameGetIntroSuccess object:nil];
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetIntroFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MigNetNameGetIntroSuccess object:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (classicInfo == nil) {
        
        classicInfo = [[NSMutableArray alloc] init];
    }
    
    if (tableHistroyInfo == nil) {
        
        tableHistroyInfo = [[NSMutableArray alloc] init];
    }
    
    if (tableThoughtInfo == nil) {
        
        tableThoughtInfo = [[NSMutableArray alloc] init];
    }
    
    if (tableSectionInfo == nil) {
        
        tableSectionInfo = [[NSMutableArray alloc] init];
    }
    
    [self initView];
}

- (void)initView {
    
    float ystart = 32 / SCREEN_SCALAR;
    [self initClassicView:ystart];
    
    ystart += (125 + 32) / SCREEN_SCALAR;
    [self initTableView:ystart];
}

- (void)initClassicView:(float)ystart {
    
    if (classicWrapper == nil) {
        
        classicWrapper = [[UIView alloc] initWithFrame:self.mFrame];
    }
    [classicWrapper setBackgroundColor:[UIColor clearColor]];
    
    NSArray *bookarray = @[@{KEY_TITLE:@"佛教历史",
                             KEY_IMAGE:IMG_INTRO_HISTORY},
                           
                           @{KEY_TITLE:@"宗派思想",
                             KEY_IMAGE:IMG_INTRO_THOUGHT},
                           
                           @{KEY_TITLE:@"艺术浏览",
                             KEY_IMAGE:IMG_INTRO_ART}];
    
    if (classicInfo == nil) {
        
        classicInfo = [[NSMutableArray alloc] init];
    }
    
    [classicInfo addObjectsFromArray:bookarray];
    
    // 排列图标
    int itemOneRow = 3;
    float initGap = 52.0;
    float xstart = initGap / SCREEN_SCALAR;
    float iconsize = 125.0 / SCREEN_SCALAR;
    float hSeperatespace = (self.mFrame.size.width - initGap / SCREEN_SCALAR * 2 - iconsize * itemOneRow) / (itemOneRow - 1);
    float vSeperatespace = 32.0 / SCREEN_SCALAR;
    
    for (int i=0; i<[classicInfo count]; i++) {
        
        int x = i % itemOneRow;
        int y = i / itemOneRow;
        float tmpX = xstart + (hSeperatespace + iconsize) * x;
        float tmpY = ystart + (vSeperatespace + iconsize) * y;
        
        NSDictionary *dic = [classicInfo objectAtIndex:i];
        NSString *image = [dic objectForKey:KEY_IMAGE];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(tmpX, tmpY, iconsize, iconsize)];
        [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(onClickClassicMenu:) forControlEvents:UIControlEventTouchUpInside];
        
        [classicWrapper addSubview:button];
    }
    
    [self.view addSubview:classicWrapper];
    classicWrapper.frame = CGRectMake(self.mFrame.origin.x, self.mFrame.origin.y, self.mFrame.size.width, 125 / SCREEN_SCALAR + 32);
}

- (void)initTableView:(float)ystart {
    
    if (introTableView == nil) {
        
        CGRect frame = CGRectMake(0, self.mFrame.origin.y + ystart, self.mFrame.size.width, self.mFrame.size.height - ystart);
        introTableView = [[UITableView alloc] initWithFrame:frame];
    }
    
    introTableView.delegate = self;
    introTableView.dataSource = self;
    [self.view addSubview:introTableView];
    
    
    // 初始化Section
    [tableSectionInfo addObject:@"佛教历史"];
    [tableSectionInfo addObject:@"宗派思想"];
}

- (void)reloadData {
    
    [introTableView reloadData];
}

- (void)doGotoIntroduceBookView:(migsBookIntroduce *)bookintro {
    
    IntroducBookViewController *bookdetail = [[IntroducBookViewController alloc] init];
    [bookdetail initialize:bookintro];
    [self.topViewController.navigationController pushViewController:bookdetail animated:YES];
}

- (IBAction)onClickClassicMenu:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    int index = btn.tag;
    
    if (index < 2) {
        
        [self doGotoHistoryAndThought:sender];
    }
    else if (index == 2) {
        
        [self doGotoArt:sender];
    }
}

- (IBAction)doGotoArt:(id)sender {
    
#if 0
    // 不直接跳到艺术品浏览界面
    ArtDisplayViewController *artview = [[ArtDisplayViewController alloc] init];
    [artview initialize:@"5" Title:@"艺术品"];
    
    [self.topViewController.navigationController pushViewController:artview animated:YES];
#endif
    
    UIButton *btn = (UIButton *)sender;
    NSDictionary *array = [classicInfo objectAtIndex:btn.tag];
    NSString *name = [array objectForKey:KEY_TITLE];
    NSString *bookid = [NSString stringWithFormat:@"%d", 0];
    
    // 0:工艺品， 1：书画，这里要和跳转到的界面保持对应
    BookCategoryViewController *category = [[BookCategoryViewController alloc] initWithTitle:name BookID:bookid From:FROMPAGE_INTRODUCE_ART];
    [self.topViewController.navigationController pushViewController:category animated:YES];
}

- (IBAction)doGotoHistoryAndThought:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    NSDictionary *array = [classicInfo objectAtIndex:btn.tag];
    NSString *name = [array objectForKey:KEY_TITLE];
    NSString *bookid = [NSString stringWithFormat:@"%d", btn.tag];
    
    // 0:佛教历史， 1：宗教思想，这里要和跳转到的界面保持对应
    
    BookCategoryViewController *category = [[BookCategoryViewController alloc] initWithTitle:name BookID:bookid From:FROMPAGE_INTRODUCE_HISTHR];
    [self.topViewController.navigationController pushViewController:category animated:YES];
}

- (void)getIntroFailed:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取介绍失败");
}

- (void)getIntroSuccess:(NSNotification *)notification {
    
    MIGDEBUG_PRINT(@"获取介绍成功");
    
    NSDictionary *userinfo = notification.userInfo;
    NSDictionary *result = [userinfo objectForKey:@"result"];
    
    NSDictionary *his = [result objectForKey:@"his"];
    if ([his count] > 0) {
        
        [tableHistroyInfo removeAllObjects];
    }
    for (NSDictionary *dic in his) {
        
        migsBookIntroduce *intro = [migsBookIntroduce setupBookIntroduceByDictionary:dic];
        [tableHistroyInfo addObject:intro];
    }
    
    NSDictionary *thought = [result objectForKey:@"thought"];
    if ([thought count] > 0) {
        
        [tableThoughtInfo removeAllObjects];
    }
    for (NSDictionary *dic in thought) {
        
        migsBookIntroduce *intro = [migsBookIntroduce setupBookIntroduceByDictionary:dic];
        [tableThoughtInfo addObject:intro];
    }
    
    [self reloadData];
}

// UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [tableSectionInfo count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return [tableHistroyInfo count];
    }
    else if (section == 1) {
        
        return [tableThoughtInfo count];
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
    
    NSString *cellIdentifier = @"BookIntroduceTableViewCell";
    BookIntroduceTableViewCell *cell = (BookIntroduceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (BookIntroduceTableViewCell *)[nibContents objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (section == 0) {
            
            if ([tableHistroyInfo count] <= 0) {
                
                return nil;
            }
            
            migsBookIntroduce *bookIntro = [tableHistroyInfo objectAtIndex:row];
            [cell initialize:bookIntro];
        }
        else if (section == 1) {
            
            if ([tableThoughtInfo count] <= 0) {
                
                return nil;
            }
            
            migsBookIntroduce *bookIntro = [tableThoughtInfo objectAtIndex:row];
            [cell initialize:bookIntro];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int section = indexPath.section;
    int row = indexPath.row;
    
    migsBookIntroduce *bookintro = nil;
    
    if (section == 0) {
        
        bookintro = [tableHistroyInfo objectAtIndex:row];
    }
    else if (section == 1) {
        
        bookintro = [tableThoughtInfo objectAtIndex:row];
    }
    
    if (bookintro) {
        
        [self doGotoIntroduceBookView:bookintro];
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
