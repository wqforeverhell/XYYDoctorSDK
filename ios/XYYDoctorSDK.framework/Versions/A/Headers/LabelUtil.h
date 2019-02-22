//
//  LabelUtil.h
//  xinyaomeng
//
//  Created by 黄黎雯 on 2017/6/8.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LabelUtil : NSObject
/**
 *  得到单例
 *
 *  @return 单例的对象
 */
+ (id)getInstance;

/**
 *  根据label文字自适应label的高度
 *
 *  @param label 要自适应的label
 *
 *  @return 自适应后label的高度
 */
- (CGFloat)fitLabelHeight:(UILabel *)label;

/**
 *  根据label文字自适应label的宽度
 *
 *  @param label 要自适应的label
 *
 *  @return 自适应后label的宽度
 */
- (CGFloat)fitLabelWidth:(UILabel *)label;

//获取有行间距的文字高度
-(CGFloat)getLabelHjjHeight:(NSString*) content label:(UILabel*)label width:(CGFloat)width;
-(CGFloat)getLabelHjjHeight:(NSString*) content label:(UILabel*)label width:(CGFloat)width size:(CGFloat)size;
@end
