//
//  TimeUtil.h
//  xinyaomeng
//
//  Created by 黄黎雯 on 2017/6/8.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeUtil : NSObject
/**
 *  得到单例
 *
 *  @return 单例的对象
 */
+ (id)getInstance;

/**
 *  获取自1970年到现在的秒数
 *
 *  @return 秒数
 */
- (NSInteger)currentSecond;
/**
 *  获取自1970年到现在的毫秒数
 *
 *  @return 毫秒数
 */
- (long long) currentMsec;

/**
 *  获取当前的日期对象
 *
 *  @return 日期对象
 */
- (NSDateComponents *)currentDateCompoent;

/**
 *  通过给定的NSDate得到日期对象
 *
 *  @param date NSDate
 *
 *  @return 日期对象
 */
- (NSDateComponents *)dateCompoentFromDate:(NSDate *)date;

/**
 *  通过给定的NSDate得到日期对象
 *
 *  @param date NSDate
 *
 *  @return 日期对象
 */
- (NSInteger)dateIntegerFromDate:(NSDate *)date;

/**
 *  获取某年某月最大天数
 *
 *  @param year  年份
 *  @param month 月份
 *
 *  @return 天数
 */
- (NSInteger)maxDayForYear:(NSInteger *)year month:(NSInteger)month;
/**
 *  通过制定的参数获取NSDate对象
 *
 *  @param year   年
 *  @param month  月
 *  @param day    日
 *  @param hour   时
 *  @param monute 分
 *  @param second 秒
 *
 *  @return NSDate对象
 */
- (NSDate *)dateFromYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

/**
 *  通过秒数来获取时间字符串
 *
 *  @param second 秒数
 *
 *  @return 时间字符串
 */
- (NSString *)dateStringFromSecond:(NSInteger)second;
- (NSString *)dateStringFromSecondYMR:(NSInteger)second;
- (NSString *)dateStringFromSecondYMRorMR:(NSInteger)second;
- (NSString *)dateStringFromSecondHM:(NSInteger)second;
- (NSString *)dateStringFromSecondYMRorMRhm:(NSInteger)second;
/**
 *  获得当日yyyy-MM-dd
 *
 *  @return 时间字符串
 */
- (NSString*)dateStringFromSecondStart:(NSInteger)send;

/**
 *  得到date之后或之前的日子，正表示之后，负表示之前
 *
 *  @param date  基准时间
 *  @param year  年
 *  @param month 月
 *  @param day   日
 *
 *  @return 计算之后的日期
 */
- (NSDate *)dateAfterFromDate:(NSDate *)date withYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

/**
 *  计算两个日期差几天
 *
 *  @param date1 日期1
 *  @param date2 日期2
 *
 *  @return 差的天数
 */
- (NSInteger)differenceFromDate:(NSDate *)date1 toDate:(NSDate *)date2;

/**
 *  格式化现在时间与给定的秒数的时间差
 *
 *  @param second 自1970年开始的秒数
 *
 *  @return 格式化后的字符串
 */
- (NSString *)formatDifferenceToNowFromSecond:(NSInteger)second;

/**
 *  格式化给定的秒数与现在时间的时间差(计算还剩多少时间医生下线)
 *
 *  @param second 自1970年开始的秒数
 *
 *  @return 格式化后的字符串
 */
- (NSString *)formatOnlineTimeFromSecond:(NSInteger)second;

/**
 *  格式化现在时间与给定的秒数的时间差(计算还剩多少时间医生在线)
 *
 *  @param second 自1970年开始的秒数
 *
 *  @return 格式化后的字符串
 */
- (NSString *)formatStartTimeFromSecond:(NSInteger)second;

/**
 *  活动状态
 *
 *  @param second 自1970年开始的秒数
 *
 *  @return 格式化后的字符串
 */
- (NSString *)formatStat:(NSInteger)startSecond end:(NSInteger)endSecond bmjz:(NSInteger)bmjzSecond;

+(BOOL)bissextile:(int)year;
@end
