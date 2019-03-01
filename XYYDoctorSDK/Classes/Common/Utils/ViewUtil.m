//
//  ViewUtil.m
//  Drugdisc
//
//  Created by huangliwen on 2018/3/21.
//  Copyright © 2018年 Drugdisc. All rights reserved.
//

#import "ViewUtil.h"
#import "XYYSDK.h"
@implementation ViewUtil
+(void)setshadowColorToView:(UIView *)view{
    view.layer.shadowColor=HexRGB(0xa1e1e1).CGColor;
    view.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移2，y向下偏移6，默认(0, -3),这个跟shadowRadius配合使用
    view.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    view.layer.shadowRadius = 4;//阴影半径，默认3
}
//渐变设置
+(void)setJianbianToView:(UIView *)view colorType:(JianBianColorType)colorType frame:(CGRect)frame{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    if (colorType==JianBianGreen) {
        gradientLayer.colors = @[(__bridge id)JIANBIAN_GREEN_START_COLOR.CGColor, (__bridge id)JIANBIAN_GREEN_OVER_COLOR.CGColor];
    }else if (colorType==JianBianOrange){
        gradientLayer.colors = @[(__bridge id)JIANBIAN_ORANGE_START_COLOR.CGColor, (__bridge id)JIANBIAN_ORANGE_OVER_COLOR.CGColor];
    }else if (colorType==jianBianOne){
        gradientLayer.colors = @[(__bridge id)RGB(0, 216, 158).CGColor, (__bridge id)RGB(0, 176, 101).CGColor];
    }else if (colorType==jianBianTwo){
        gradientLayer.colors = @[(__bridge id)RGB(232, 191, 41).CGColor, (__bridge id)RGB(247, 107, 28).CGColor];
    }
    else{
        gradientLayer.colors = @[(__bridge id)JIANBIAN_GRAY_START_COLOR.CGColor, (__bridge id)JIANBIAN_GRAY_OVER_COLOR.CGColor];
    }
    gradientLayer.locations = @[@0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = frame;
    [view.layer insertSublayer:gradientLayer atIndex:0];
}
+(void)setVerJianbianToView:(UIView *)view colorType:(JianBianColorType)colorType frame:(CGRect)frame{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    if (colorType == jianBianOne) {
        gradientLayer.colors = @[(__bridge id)RGB(0, 216, 158).CGColor, (__bridge id)RGB(0, 176, 101).CGColor];
    }else if (colorType==jianBianTwo){
        gradientLayer.colors = @[(__bridge id)RGB(232, 191, 41).CGColor, (__bridge id)RGB(247, 107, 28).CGColor];
    }
    gradientLayer.locations = @[@0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = frame;
    [view.layer insertSublayer:gradientLayer atIndex:0];
}
+ (void)ShearRoundCornersWidthLayer:(CALayer *)layer type:(LXKShearRoundCornersType)type radiusSize:(CGFloat)radiusSize; {
    UIBezierPath *maskPath;
    if (type == LXKShearRoundCornersTypeTop) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:layer.bounds
                                         byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                               cornerRadii:CGSizeMake(radiusSize, radiusSize)];
    } else if (type == LXKShearRoundCornersTypeBottom) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:layer.bounds
                                         byRoundingCorners:(UIRectCornerBottomLeft  | UIRectCornerBottomRight)
                                               cornerRadii:CGSizeMake(radiusSize, radiusSize)];
    }  else if (type == LXKShearRoundCornersTypeLeftRight) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:layer.bounds
                                         byRoundingCorners:(UIRectCornerTopRight   | UIRectCornerBottomRight)
                                               cornerRadii:CGSizeMake(radiusSize, radiusSize)];
    }else if (type == LXKShearRoundCornersTypeLeft) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:layer.bounds
                                         byRoundingCorners:(UIRectCornerTopLeft   | UIRectCornerBottomLeft)
                                               cornerRadii:CGSizeMake(radiusSize, radiusSize)];
    }else if (type == LXKShearRoundCornersTypeAll) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:layer.bounds
                                         byRoundingCorners:UIRectCornerAllCorners
                                               cornerRadii:CGSizeMake(radiusSize, radiusSize)];
    }
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = layer.bounds;
    maskLayer.path = maskPath.CGPath;
    layer.mask = maskLayer;
    [layer setMasksToBounds:YES];
}
@end
