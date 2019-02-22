//
//  UIImage+Tool.h
//  Demo
//
//  Created by xk jiang on 2017/10/10.
//  Copyright © 2017年 xk jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tool)

+ (UIImage *)imageWithColor:(UIColor *)color;
//加载bundle的图片
+ (UIImage *)XYY_imageInKit:(NSString *)imageName;
@end
