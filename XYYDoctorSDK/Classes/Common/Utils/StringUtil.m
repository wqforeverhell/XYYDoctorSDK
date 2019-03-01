//
//  StringUtil.m
//  xinyaomeng
//
//  Created by 黄黎雯 on 2017/6/8.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import "StringUtil.h"
#import "CommonCrypto/CommonDigest.h"
//引入IOS自带密码库
#import <CommonCrypto/CommonCryptor.h>
#import <sys/utsname.h>

#import "XYYSDK.h"
@implementation StringUtil
// 数值变化
+(NSString*)changePrice:(CGFloat)price{
    CGFloat newPrice = price;
    NSString *danwei = @"";
    if ((int)price>10000) {
        newPrice = price / 10000 ;
        danwei = @"万";
    }
    if ((int)price>10000000) {
        newPrice = price / 10000000 ;
        danwei = @"千万";
    }
    if ((int)price>100000000) {
        newPrice = price / 100000000 ;
        danwei = @"亿";
    }
    NSString *newstr = [[NSString alloc] initWithFormat:@"%.0f%@",newPrice,danwei];
    return newstr;
}

//判断是否为数字
+ (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
//判断是否为金额
+(BOOL)isPurePice:(NSString*)string{
    return ([self isPureInt:string] || [self isPureFloat:string]);
}

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
+(BOOL)validateAge:(NSString*)age{
    NSString * regex_1 =@"[1-9]\\d{0,}";
    
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_1];
    return [pred evaluateWithObject:age];
}
//返回内容中网址的位置
+(NSRange)getStringRangeByUrl:(NSString *)content{
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSRange rangeofMatch = [regularexpression rangeOfFirstMatchInString:content
                                                                options:NSMatchingReportProgress
                                                                  range:NSMakeRange(0, content.length)];
    return rangeofMatch;
}

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    //    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{11}$";
    //    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return mobile.length == 11;
}

// 数值变化
+(NSString*)changeNum:(int)num{
    int newPrice = num;
    NSString*danwei=@"";
    if (num>999) {
        newPrice = 999 ;
        danwei=@"+";
    }
    
    NSString *newstr = [[NSString alloc] initWithFormat:@"%d%@",newPrice,danwei];
    return newstr;
}

+(NSString*)getConstellation:(int)num{
    NSString *constellation=@" ";
    switch (num) {
        case 1:
            constellation=@"水瓶座";
            break;
        case 2:
            constellation=@"双鱼座";
            break;
        case 3:
            constellation=@"白羊座";
            break;
        case 4:
            constellation=@"金牛座";
            break;
        case 5:
            constellation=@"双子座";
            break;
        case 6:
            constellation=@"巨蟹座";
            break;
        case 7:
            constellation=@"狮子座";
            break;
        case 8:
            constellation=@"处女座";
            break;
        case 9:
            constellation=@"天秤座";
            break;
        case 10:
            constellation=@"天蝎座";
            break;
        case 11:
            constellation=@"射手座";
            break;
        case 12:
            constellation=@"摩羯座";
            break;
        default:
            break;
    }
    return  constellation;
}

+(NSString*)getJuli:(CGFloat)num{
    NSString*fhz=@"";
    CGFloat newNum=num;
    if (newNum>1000) {
        fhz=@"千里之外";
    }else{
        fhz=[NSString stringWithFormat:@"%0.02fkm",newNum];
    }
    return fhz;
}

+ (UIImage *)imageFromBase64String:(NSString *)base64
{
    if (!IS_EMPTY(base64)) {
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *_decodedImage = [UIImage imageWithData:imageData];
        return _decodedImage;
    }
    else {
        return nil;
    }
}

+(NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

+ (NSString *)filterEmoji:(NSString *)string {
    NSUInteger len = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    const char *utf8 = [string UTF8String];
    char *newUTF8 = malloc( sizeof(char) * len );
    int j = 0;
    
    //0xF0(4) 0xE2(3) 0xE3(3) 0xC2(2) 0x30---0x39(4)
    for ( int i = 0; i < len; i++ ) {
        unsigned int c = utf8;
        BOOL isControlChar = NO;
        if ( c == 4294967280 ||
            c == 4294967089 ||
            c == 4294967090 ||
            c == 4294967091 ||
            c == 4294967092 ||
            c == 4294967093 ||
            c == 4294967094 ||
            c == 4294967095 ||
            c == 4294967096 ||
            c == 4294967097 ||
            c == 4294967088 ) {
            i = i + 3;
            isControlChar = YES;
        }
        if ( c == 4294967266 || c == 4294967267 ) {
            i = i + 2;
            isControlChar = YES;
        }
        if ( c == 4294967234 ) {
            i = i + 1;
            isControlChar = YES;
        }
        if ( !isControlChar ) {
            newUTF8[j] = utf8;
            j++;
        }
    }
    newUTF8[j] = '\0';
    NSString *encrypted = [NSString stringWithCString:(const char*)newUTF8
                                             encoding:NSUTF8StringEncoding];
    free( newUTF8 );
    return encrypted;
}

//是否含有表情
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

+(int) getzflen: (NSString *) inPutText{
    int fhz=0;
    for (int i = 0; i<[inPutText length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [inPutText substringWithRange:NSMakeRange(i, 1)];
        fhz++;
        if ([self isZhongwen:s]) {
            fhz++;
        }
    }
    return  fhz;
}

+ (BOOL)isZhongwen:(NSString*)string
{
    NSString *      regex = @"[\u4e00-\u9fa5]";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}

//将角度转为弧度
+ (float)radians:(float)degrees{
    return (degrees*3.14159265)/180.0;
}
//根据经纬度换算出直线距离
+ (float)getDistance:(float)lat1 lng1:(float)lng1 lat2:(float)lat2 lng2:(float)lng2
{
    //地球半径
    int R = 6378137;
    //将角度转为弧度
    float radLat1 = [self radians:lat1];
    float radLat2 = [self radians:lat2];
    float radLng1 = [self radians:lng1];
    float radLng2 = [self radians:lng2];
    //结果
    float s = acos(cos(radLat1)*cos(radLat2)*cos(radLng1-radLng2)+sin(radLat1)*sin(radLat2))*R;
    //精度
    s = round(s* 10000)/10000;//单位米
    return  round(s)/1000;//单位千米
}

//根据字符串计算高度
+(CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize w:(CGFloat)w{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};//指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(w, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}
+(NSString *)iphoneType {
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
    
}
+ (BOOL)QX_NSStringIsNULL:(nullable NSString *)aStirng {
    if ([aStirng isKindOfClass:[NSNull class]]) return YES;
    if(![aStirng isKindOfClass:[NSString class]]) return YES;
    if(aStirng == nil) return YES;
    
    NSInteger len = aStirng.length;
    if(len<=0) return YES;
    return NO;
}
@end
