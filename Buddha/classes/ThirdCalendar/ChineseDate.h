//
//  ChineseDate.h
//  Buddha
//
//  Created by Archer_LJ on 15/7/22.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LunarCalendar.h"

@interface JBCalendar : NSObject

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
- (NSDate *)nsDate;

@end

@interface ChineseDate : NSObject

//获取指定年份指定月份的星期排列表(农历)
+(NSArray *)GetLunarDayArrayByYear:(int) year
                          andMonth:(int) month;

//获取某年某月某日的对应农历
+(NSString *)GetLunarDayByYear:(int) year
                      andMonth:(int) month
                        andDay:(int) day;

//以YYYY年MMdd格式输出此时的农历年月日
+(NSString*)GetLunarDateTime;

+(LunarCalendar *)GetLunarCalendar:(int)year month:(int)month day:(int)day;
+(LunarCalendar *)GetTodayLunarCalendar;

@end
