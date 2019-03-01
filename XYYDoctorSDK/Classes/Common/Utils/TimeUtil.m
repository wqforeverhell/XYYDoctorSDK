//
//  TimeUtil.m
//  xinyaomeng
//
//  Created by 黄黎雯 on 2017/6/8.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import "TimeUtil.h"

@implementation TimeUtil
+ (id) getInstance {
    static TimeUtil *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[TimeUtil alloc] init];
    });
    return singleton;
}

- (NSInteger)currentSecond {
    NSDate *now = [NSDate date];
    return [now timeIntervalSince1970];
}

- (long long)currentMsec {
    NSDate *now = [NSDate date];
    //DLog(@"time : %.f", [now timeIntervalSince1970] * 1000);
    return [now timeIntervalSince1970] * 1000;
}

- (NSDateComponents *)currentDateCompoent {
    NSDate *now = [NSDate date];
    return [self dateCompoentFromDate:now];
}

- (NSDateComponents *)dateCompoentFromDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    return [calendar components:unitFlags fromDate:date];
}

- (NSInteger)dateIntegerFromDate:(NSDate *)date{
    return [date timeIntervalSince1970];
}

- (NSInteger)maxDayForYear:(NSInteger *)year month:(NSInteger)month {
    NSString *date = [NSString stringWithFormat:@"%04ld-%02ld-01", year, month];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *today = [formatter dateFromString:date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit
                                  inUnit:NSMonthCalendarUnit
                                 forDate:today];
    
    return days.length;
}

- (NSDate *)dateFromYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    NSDateComponents* components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    [components setHour:hour];
    [components setMinute:minute];
    [components setSecond:second];
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [calendar dateFromComponents:components];
}

- (NSString *)dateStringFromSecond:(NSInteger)second {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateComponents *dateComponent = [self dateCompoentFromDate:date];
    return [NSString stringWithFormat:@"%04ld-%02ld-%02ld %02ld:%02ld:%02ld", dateComponent.year, dateComponent.month, dateComponent.day, dateComponent.hour, dateComponent.minute, dateComponent.second];
}

- (NSString *)dateStringFromSecondYMR:(NSInteger)second {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateComponents *dateComponent = [self dateCompoentFromDate:date];
    return [NSString stringWithFormat:@"%04ld.%02ld.%02ld", dateComponent.year, dateComponent.month, dateComponent.day];
}

- (NSString *)dateStringFromSecondYMRorMR:(NSInteger)second {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateComponents *dateComponent = [self dateCompoentFromDate:date];
    NSDateComponents *nowDateComponent=[self currentDateCompoent];
    if (dateComponent.year<nowDateComponent.year) {
        return [NSString stringWithFormat:@"%04ld-%02ld-%02ld", dateComponent.year, dateComponent.month, dateComponent.day];
    }
    return [NSString stringWithFormat:@"%02ld-%02ld", dateComponent.month, dateComponent.day];
}

- (NSString *)dateStringFromSecondHM:(NSInteger)second {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateComponents *dateComponent = [self dateCompoentFromDate:date];
    return [NSString stringWithFormat:@"%02ld:%02ld", dateComponent.hour, dateComponent.minute];
}

- (NSString *)dateStringFromSecondYMRorMRhm:(NSInteger)second {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateComponents *dateComponent = [self dateCompoentFromDate:date];
    NSDateComponents *nowDateComponent=[self currentDateCompoent];
    if (dateComponent.year<nowDateComponent.year) {
        return [NSString stringWithFormat:@"%04ld-%02ld-%02ld %02ld:%02ld", dateComponent.year, dateComponent.month, dateComponent.day,dateComponent.hour,dateComponent.minute];
    }
    return [NSString stringWithFormat:@"%02ld-%02ld %02ld:%02ld", dateComponent.month, dateComponent.day,dateComponent.hour,dateComponent.minute];
}

- (NSString*)dateStringFromSecondStart:(NSInteger)send {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:send];
    NSDateComponents *dateComponent = [self dateCompoentFromDate:date];
    NSString *strdata= [NSString stringWithFormat:@"%04ld-%02ld-%02ld", dateComponent.year, dateComponent.month, dateComponent.day];
    return strdata;
}

- (NSDate *)dateAfterFromDate:(NSDate *)date withYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

- (NSInteger)differenceFromDate:(NSDate *)date1 toDate:(NSDate *)date2 {
    //得到相差秒数
    NSTimeInterval time = [date2 timeIntervalSinceDate:date1];
    int days = ((int)time)/(3600);
    return days;
}

- (NSString *)formatDifferenceToNowFromSecond:(NSInteger)second {
    NSInteger nowSecond = [self currentSecond];
    NSInteger diff = nowSecond - second;
    if (diff < 60) { // 几秒前
        return [NSString stringWithFormat:@"%ld秒前", diff];
    }
    if (diff >= 60 && diff < 3600) { // 几分钟前
        return [NSString stringWithFormat:@"%ld分钟前", diff/60];
    }
    if (diff >= 3600 && diff < 3600*24) { // 几小时前
        return [NSString stringWithFormat:@"%ld小时前", diff/3600];
    }
    NSInteger daynum=diff/(3600*24);
    // 几天前
    if(daynum<8){
        return [NSString stringWithFormat:@"%ld天前", diff/(3600*24)];
    }
    return [self dateStringFromSecondYMRorMR:second];
}

- (NSString *)formatOnlineTimeFromSecond:(NSInteger)second {
    NSInteger nowSecond = [self currentSecond];
    NSInteger diff = second-nowSecond;
    if (diff < 60) { // 几秒前
        return [NSString stringWithFormat:@"还剩00:%ld", diff];
    }
    if (diff >= 60 && diff < 3600) { // 几分钟前
        NSString *miao=[NSString stringWithFormat:@"%ld",diff%60];
        if (diff%60<10) {
            miao=[NSString stringWithFormat:@"0%ld",diff%60];
        }
        return [NSString stringWithFormat:@"还剩%ld:%@", diff/60,miao];
    }
    if (diff >= 3600 && diff < 3600*24) { // 几小时前
        return [NSString stringWithFormat:@"还剩%ld小时", diff/3600];
    }
    // 几天前
    return [NSString stringWithFormat:@"还剩%ld天", diff/(3600*24)];
}

- (NSString *)formatStartTimeFromSecond:(NSInteger)second {
    NSInteger nowSecond = [self currentSecond];
    NSInteger diff = nowSecond-second;
    if (diff < 60) { // 几秒前
        return [NSString stringWithFormat:@"还剩00:%ld", diff];
    }
    if (diff >= 60 && diff < 3600) { // 几分钟前
        return [NSString stringWithFormat:@"还剩%ld:00", diff/60];
    }
    if (diff >= 3600 && diff < 3600*24) { // 几小时前
        return [NSString stringWithFormat:@"还剩%ld小时", diff/3600];
    }
    // 几天前
    return [NSString stringWithFormat:@"还剩%ld天", diff/(3600*24)];
}

- (NSString *)formatStat:(NSInteger)startSecond end:(NSInteger)endSecond bmjz:(NSInteger)bmjzSecond{
    NSInteger nowSecond = [self currentSecond];
    if (startSecond<=nowSecond&&endSecond>=nowSecond) {
        NSInteger diff = endSecond - nowSecond;
        return [NSString stringWithFormat:@"还有%ld小时活动结束", diff/3600];
    }else if (endSecond<nowSecond){
        return [NSString stringWithFormat:@"活动已结束"];
    }else if (bmjzSecond>nowSecond){
        NSInteger diff = bmjzSecond - nowSecond;
        return [NSString stringWithFormat:@"还有%ld小时报名截止", diff/3600];
    }
    return [NSString stringWithFormat:@"活动还未开始"];
}

+(BOOL)bissextile:(int)year {
    if ((year%4==0 && year %100 !=0) || year%400==0) {
        return YES;
    }else {
        return NO;
    }
    return NO;
}
@end
