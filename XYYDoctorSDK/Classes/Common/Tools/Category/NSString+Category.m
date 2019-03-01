//
//  NSString+Size.m
//  ImHere
//
//  Created by 卢明渊 on 15-3-9.
//  Copyright (c) 2015年 我在这. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

+ (BOOL) isEmpty:(NSString *)str {
    if (str && str.length > 0) {
        return false;
    }
    return true;
}

- (CGSize)sizeWithFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    size = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil].size;
    return size;
}

// 字符个数统计
- (int)charCounts {
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

- (NSString *)ToChineseAmount
{
    if(self.length == 0)
        return @"";
    NSRange range = [self rangeOfString:@"."];
    NSInteger begin = [self integerValue];
    NSInteger end = 0;
    if(range.length > 0)
    {
        begin = [[self substringToIndex:range.location] integerValue];
        NSString *endstr = [self substringFromIndex:range.location];
        float endF = [endstr floatValue];
        end = endF * 100;
    }
    NSMutableString *result = [[NSMutableString alloc] init];
    NSArray *ChinaUnits = @[@"仟", @"佰", @"拾", @""];
    NSArray *ChinaUnitss = @[@"亿", @"万", @"圆"];
    NSArray *ChinaNumbers = @[@"零", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖"];
    // 圆
    NSInteger base = 100000000;
    NSInteger temp = begin / base;
    begin %= base;
    for(int j = 0; j < 3; j++)
    {
        if(temp > 0)
        {
            NSInteger d = 1000;
            for(int i = 0; i < 4; i++)
            {
                NSInteger index = temp / d;
                temp %= d;
                d /= 10;
                if(index == 0 && result.length > 0)
                {
                    if(d > 0 && temp / d > 0)
                        [result appendFormat:@"%@", ChinaNumbers[index]];
                }
                else if(index > 0 && index < 10)
                    [result appendFormat:@"%@%@", ChinaNumbers[index], ChinaUnits[i]];
            }
            if(result.length > 0)
                [result appendString:ChinaUnitss[j]];
        }
        base /= 10000;
        if(base > 0)
        {
            temp = begin / base;
            begin %= base;
        }
    }
    range = [result rangeOfString:@"圆"];
    if(range.length == 0)
        [result appendString:@"圆"];
    // 角、分
    if(end > 0)
    {
        temp = end / 10;
        if(temp > 0)
            [result appendFormat:@"%@角", ChinaNumbers[temp]];
        else
            [result appendString:@"零"];
        temp = end % 10;
        if(temp > 0)
            [result appendFormat:@"%@分", ChinaNumbers[temp]];
        else
            [result appendString:@"整"];
    }
    else
        [result appendString:@"整"];
    return result;
}
@end
