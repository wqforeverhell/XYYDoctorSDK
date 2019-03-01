//
//  StringUtil.h
//  xinyaomeng
//
//  Created by 黄黎雯 on 2017/6/8.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface StringUtil : NSObject
// 数值变化
+(NSString*)changePrice:(CGFloat)price;

//判断是否为数字
+ (BOOL)isPureInt:(NSString *)string;
//判断金额
+(BOOL)isPurePice:(NSString*)string;

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

//返回内容中网址的位置
+(NSRange)getStringRangeByUrl:(NSString*)content;

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile;

+(NSString*)changeNum:(int)num;

+(NSString*)getConstellation:(int)num;

+(NSString*)getJuli:(CGFloat)num;

//MD5加密
+(NSString *) md5: (NSString *) inPutText;

//过滤emoji
+ (NSString *)filterEmoji:(NSString *)string;

//判断是否包换emoji
+ (BOOL)stringContainsEmoji:(NSString *)string;

//获取文字长度
+(int) getzflen: (NSString *) inPutText;

//根据经纬度换算出直线距离
+ (float)getDistance:(float)lat1 lng1:(float)lng1 lat2:(float)lat2 lng2:(float)lng2;

//根据字符串计算高度
+ (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize w:(CGFloat)w;

//判断手机类型
+(NSString *)iphoneType;
+(BOOL)validateAge:(NSString*)age;
+ (BOOL)QX_NSStringIsNULL:(nullable NSString *)aStirng;
@end
