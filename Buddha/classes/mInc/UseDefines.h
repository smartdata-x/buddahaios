//
//  UseDefines.h
//  Monas
//
//  Created by Archer_LJ on 14/11/16.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#ifndef Monas_UseDefines_h
#define Monas_UseDefines_h

// 打印
#ifdef DEBUG
#define MIGDEBUG_PRINT(format, ...)                 NSLog(format, ## __VA_ARGS__)
#else
#define MIGDEBUG_PRINT(format, ...)
#endif

// 登陆类型
#define MIGLOGINTYPE_NONE                           @"0"
#define MIGLOGINTYPE_LOCAL                          @"0"
#define MIGLOGINTYPE_SINAWEIBO                      @"1"
#define MIGLOGINTYPE_TENCENTWEIXIN                  @"2"
#define MIGLOGINTYPE_TENCENTQQ                      @"3"

#define DATABASE_LOGOUT                             0
#define DATABASE_LOGIN                              1
#define DATABASE_QUICKLOGIN                         2

#define MIGGENDER_MALE                              @"1"
#define MIGGENDER_FEMALE                            @"0"

// 屏幕高宽
#define mainScreenFrame [[UIScreen mainScreen] bounds]
#define mainScreenWidth mainScreenFrame.size.width
#define mainScreenHeight mainScreenFrame.size.height

//app id
#define APPLE_ID 862410865

//判断系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_OS_5_OR_LATER                            ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER                            ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER                            ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER                            ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define IS_IOS7                                     SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
#define IS_IOS8                                     SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")

// 宏函数
#define MIG_IS_EMPTY_STRING(x)                      ((x) == nil || [x isEqualToString:@""])

// 大小定义
#define SCREEN_SCALAR                               2.0
#define NAV_BAR_HEIGHT                              44.0

#define TOP_MENU_BUTTON_WIDTH                       64
#define TOP_MENU_HEIGHT                             (72 / SCREEN_SCALAR)
#define HOME_BANNER_HEIGHT                          (230 / SCREEN_SCALAR)
#define BOTTOM_MENU_BUTTON_WIDTH                    100
#define BOTTOM_MENU_BUTTON_HEIGHT                   (96 / SCREEN_SCALAR)
#define SECTION_TITLE_HEIGHT                        (42 / SCREEN_SCALAR)
#define NAVIGATION_HEIGHT                           64
#define BOTTOM_AD_HEIGHT                            (50 / SCREEN_SCALAR)

#define LAST_LOGOUT                                 0
#define LAST_LOGIN                                  1

#define MIG_COLOR_111111                            [UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:1.0]
#define MIG_COLOR_808080                            [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0]
#define MIG_COLOR_53645E                            [UIColor colorWithRed:83.0/255.0 green:100.0/255.0 blue:94.0/255.0 alpha:1.0]
#define MIG_COLOR_F6F6F6                            [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0]
#define MIG_COLOR_FBFBFB                            [UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1.0]
#define MIG_COLOR_333333                            [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]
#define MIG_COLOR_D4D4D4                            [UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1.0]

// 地图
#define DEFAULT_DISTANCE_RADIUS                     10000
#define MAX_DISTANCE_RADIUS                         1000000000
#define DEFAULT_DISTANCE_FILTER                     2

// 书店
#define MIG_BOOKS_PER_ROW                           3
#define MIG_BOOKCELL_HEIGHT                         147.0
#define MIG_BOOK_DIR                                @"/books/"

// 字符串打印消息
#define MIGTIP_LOGIN_SUCCESS                        @"登录成功"
#define MIGTIP_LOGIN_FAILED                         @"对不起, 登录失败了"
#define MIGTIP_LOGIN_NOTLOGIN                       @"对不起，您还未登录"
#define MIGTIP_GETBUILDING_FAILED                   @"获取推荐建筑失败了"
#define MIGTIP_CANCEL                               @"取消"
#define MIGTIP_BOOKEND                              @"已经到书的最后一页了"
#define MIGTIP_CHAPTEREND                           @"本章结束"

// 字典匹配关键字
#define KEY_NORMAL                                  @"KeyNormal"
#define KEY_HILIGHT                                 @"KeyHilight"
#define KEY_TITLE                                   @"KeyTitle"
#define KEY_TITLE_WIDTH                             @"KeyTitleWidth"
#define KEY_TITLE_HEIGHT                            @"KeyTitleHeight"
#define KEY_TOTAL_WIDTH                             @"KeyTotalWidth"
#define KEY_TOTAL_HEIGHT                            @"KeyTotalHeight"
#define KEY_HEADER                                  @"KeyHeader"
#define KEY_FOOTER                                  @"KeyFooter"
#define KEY_NET_ADDRESS                             @"KeyNetAddress"
#define KEY_NET_SUCCESS                             @"KeyNetSuccess"
#define KEY_NET_FAILED                              @"KeyNetFailed"
#define KEY_IMAGE                                   @"KeyImage"

// 内部通信消息
#define MigLocalNameGetAdSuccess                    @"MigLocalNameGetAdSuccess"
#define MigLocalNameGetAdFailed                     @"MigLocalNameGetAdFailed"
#define MigLocalNameLoginSuccess                    @"MigLocalNameLoginSuccess"
#define MigLocalNameLoginFailed                     @"MigLocalNameLoginFailed"
#define MigLocalNameDownloadFileFailed              @"MigLocalNameDownloadFileFailed"
#define MigLocalNameDownloadFileSuccess             @"MigLocalNameDownloadFileSuccess"
#define MigLocalNameLoginSuccessReturn              @"MigLocalNameLoginSuccessReturn"
#define MigLocalNameLoginFailedReturn               @"MigLocalNameLoginFailedReturn"

// 新浪微博
//#define kAppKey                                     @"2045436852"
//#define kRedirectURL                                @"http://www.sina.com"

// MISC
#define AES256_SECRET                               @"ce6dd4ab9ae4f14aa7982a43453cc173"

#endif
