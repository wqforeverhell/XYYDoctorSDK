//
//  UIImage+Tool.m
//  Demo
//
//  Created by xk jiang on 2017/10/10.
//  Copyright © 2017年 xk jiang. All rights reserved.
//

#import "UIImage+Tool.h"
#import "XYYDoctorSDK.h"
@implementation UIImage (Tool)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
+ (UIImage *)XYY_imageInKit:(NSString *)imageName {
    NSString *name = [[ FileUtil getSDKResourcesPath] stringByAppendingPathComponent:imageName];
   // UIImage *image = [UIImage imageNamed:imageName];
    //优先取上层bundle 里的图片，如果没有，则用自带资源的图片
    return  [UIImage imageWithContentsOfFile:name];
}
@end
