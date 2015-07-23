//
//  ChineseDate.m
//  Buddha
//
//  Created by Archer_LJ on 15/7/22.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import "ChineseDate.h"

@implementation JBCalendar

@synthesize day,year,month;


- (NSDate *)nsDate
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = self.year;
    components.month = self.month;
    components.day = self.day;
    
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}
@end

@implementation ChineseDate

//以YYYY年MMdd格式输出此时的农历年月日
+(NSString*)GetLunarDateTime{
    JBCalendar* date = [[JBCalendar alloc]init];
    date.year = [[self GetYear] intValue],date.month =[[self GetMonth] intValue],date.day = [[self GetDay] intValue];
    LunarCalendar *lunarCalendar = [[date nsDate] chineseCalendarDate];
    NSString * lunar = [[NSString alloc]initWithFormat:
                        @"%@%@年%@%@",lunarCalendar.YearHeavenlyStem,lunarCalendar.YearEarthlyBranch,lunarCalendar.MonthLunar,lunarCalendar.DayLunar];
    return lunar;
}

+(LunarCalendar *)GetLunarCalendar:(int)year month:(int)month day:(int)day {
    JBCalendar* date = [[JBCalendar alloc]init];
    date.year = year,date.month = month,date.day = day;
    LunarCalendar *lunarCalendar = [[date nsDate] chineseCalendarDate];
    return lunarCalendar;
}

+(LunarCalendar *)GetTodayLunarCalendar {
    JBCalendar* date = [[JBCalendar alloc]init];
    date.year = [[self GetYear] intValue],date.month =[[self GetMonth] intValue],date.day = [[self GetDay] intValue];
    LunarCalendar *lunarCalendar = [[date nsDate] chineseCalendarDate];
    return lunarCalendar;
}


//获取指定年份指定月份的星期排列表(农历)
+(NSArray *)GetLunarDayArrayByYear:(int) year andMonth:(int) month{
    NSMutableArray * dayArray = [[NSMutableArray alloc]init];
    for (int i = 0; i< 42; i++) {
        if (i < [self GetTheWeekOfDayByYera:year andByMonth:month]-1) {
            [dayArray addObject:@" "];
        }else if ((i>[self GetTheWeekOfDayByYera:year andByMonth:month]-1)&&(i<[self GetTheWeekOfDayByYera:year andByMonth:month]+[self GetNumberOfDayByYera:year andByMonth:month])){
            NSString * days = [self GetLunarDayByYear:year andMonth:month andDay:(i-[self GetTheWeekOfDayByYera:year andByMonth:month]+1)];
            [dayArray addObject:days];
        }else {
            [dayArray addObject:@" "];
        }
    }
    return dayArray;
}

//获取某年某月某日的对应农历日
+(NSString *)GetLunarDayByYear:(int) year
                      andMonth:(int) month
                        andDay:(int) day{
    JBCalendar* date = [[JBCalendar alloc]init];
    date.year = year,date.month = month,date.day = day;
    LunarCalendar *lunarCalendar = [[date nsDate] chineseCalendarDate];
    NSString * lunarday = [[NSString alloc]initWithString:lunarCalendar.DayLunar];
    return lunarday;
}



//计算year年month月第一天是星期几，周日则为0
+(int)GetTheWeekOfDayByYera:(int)year
                 andByMonth:(int)month{
    int numWeek = ((year-1)+ (year-1)/4-(year-1)/100+(year-1)/400+1)%7;//numWeek为years年的第一天是星期几
    //NSLog(@"%d",numWeek);
    int ar[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    int numdays = (((year/4==0&&year/100!=0)||(year/400==0))&&(month>2))?(ar[month-1]+1):(ar[month-1]);//numdays为month月years年的第一天是这一年的第几天
    //NSLog(@"%d",numdays);
    int dayweek = (numdays%7 + numWeek)%7;//month月第一天是星期几，周日则为0
    //NSLog(@"%d",dayweek);
    return dayweek;
}

//判断year年month月有多少天
+(int)GetNumberOfDayByYera:(int)year
                andByMonth:(int)month{
    int nummonth = 0;
    //判断month月有多少天
    if ((month == 1)|| (month == 3)||(month == 5)||(month == 7)||(month == 8)||(month == 10)||(month == 12))
        nummonth = 31;
    else if ((month == 4)|| (month == 6)||(month == 9)||(month == 11))
        nummonth = 30;
    else if (((year/4==0&&year/100!=0)||(year/400==0))&&(month>2))
        nummonth = 29;
    else nummonth = 28;
    return nummonth;
}

+(NSString *)GetYear{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}

+(NSString *)GetMonth{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}

+(NSString *)GetDay{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}

+(NSString *)GetHour{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}

+(NSString *)GetMinute{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"mm"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}

+(NSString *)GetSecond{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"ss"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}

@end
