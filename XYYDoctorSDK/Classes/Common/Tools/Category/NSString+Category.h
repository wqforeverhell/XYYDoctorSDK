//
//  NSString+Size.h
//  ImHere
//
//  Created by 卢明渊 on 15-3-9.
//  Copyright (c) 2015年 我在这. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Category)

+ (BOOL) isEmpty:(NSString*) str;

- (CGSize) sizeWithFont:(UIFont*) font width:(CGFloat) width;

// 字符个数统计
- (int) charCounts;
// 转换成大写金额
- (NSString *)ToChineseAmount;
@end
