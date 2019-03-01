//
//  ViewUtil.h
//  Drugdisc
//
//  Created by huangliwen on 2018/3/21.
//  Copyright © 2018年 Drugdisc. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,JianBianColorType) {
    JianBianGreen          = 0, //绿色
    JianBianOrange         = 1, //橙色
    JianBianGary           = 2, //灰色
    jianBianOne,
    jianBianTwo,
};
/**定义剪切的类型*/
typedef NS_ENUM(NSInteger, LXKShearRoundCornersType) {
    LXKShearRoundCornersTypeTop       = 1 << 0,
    LXKShearRoundCornersTypeBottom    = 1 << 1,
    LXKShearRoundCornersTypeLeftRight = 1 << 2,
    LXKShearRoundCornersTypeLeft      = 1 << 3,
    LXKShearRoundCornersTypeAll       = 1 << 4,
};
@interface ViewUtil : NSObject
+(void)setshadowColorToView:(UIView *)view;
+(void)setJianbianToView:(UIView *)view colorType:(JianBianColorType)colorType frame:(CGRect)frame;
+(void)setVerJianbianToView:(UIView *)view colorType:(JianBianColorType)colorType frame:(CGRect)frame;
+ (void)ShearRoundCornersWidthLayer:(CALayer *)layer type:(LXKShearRoundCornersType )type radiusSize:(CGFloat)radiusSize;
@end
