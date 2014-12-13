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

#define DEFAULT_DISTANCE_RADIUS                     10000
#define MAX_DISTANCE_RADIUS                         1000000000
#define DEFAULT_DISTANCE_FILTER                     2

#define LAST_LOGOUT                                 0
#define LAST_LOGIN                                  1

// 字符串打印消息
#define MIGTIP_LOGIN_SUCCESS                        @"登录成功"
#define MIGTIP_LOGIN_FAILED                         @"对不起, 登录失败了"
#define MIGTIP_LOGIN_NOTLOGIN                       @"对不起，您还未登录"

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

// 图片字符串
#define IMG_HOME_BANNER                             @"banner.jpg"
#define IMG_HOME_NORMAL_BG                          @"menu_normal.png"
#define IMG_HOME_HILIGHT_BG                         @"menu_select.png"
#define IMG_FOUND_FO                                @"found_fo.png"
#define IMG_FOUND_FO_ON                             @"found_fo_on.png"
#define IMG_MY_FO                                   @"my_fo.png"
#define IMG_MY_FO_ON                                @"my_fo_on.png"
#define IMG_USER_CENTER                             @"user_center.png"
#define IMG_USER_CENTER_ON                          @"user_center_on.png"
#define IMG_HOME_SEARCH                             @"home_search.png"
#define IMG_HOME_MESSAGE                            @"home_message.png"
#define IMG_PAGE_LOGO                               @"page_logo.png"
#define IMG_MYCENTER_BACK                           @"mycenter_back.png"
#define IMG_LOGIN_LOGO                              @"login_logo.png"
#define IMG_LOGIN_QQ                                @"qq_ico.png"
#define IMG_LOGIN_WEIBO                             @"weibo_ico.png"
#define IMG_LOGIN_WEIXIN                            @"weixin_ico.png"

// 内部通信消息
#define MigLocalNameGetAdSuccess                    @"MigLocalNameGetAdSuccess"
#define MigLocalNameGetAdFailed                     @"MigLocalNameGetAdFailed"
#define MigLocalNameLoginSuccess                    @"MigLocalNameLoginSuccess"
#define MigLocalNameLoginFailed                     @"MigLocalNameLoginFailed"

// 新浪微博
//#define kAppKey                                     @"2045436852"
//#define kRedirectURL                                @"http://www.sina.com"

// MISC
#define AES256_SECRET                               @"ce6dd4ab9ae4f14aa7982a43453cc173"

#endif
