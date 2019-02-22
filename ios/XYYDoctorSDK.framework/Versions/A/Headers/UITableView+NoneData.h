//
//  UITableView+NoneData.h
//  xinyaomeng
//
//  Created by 黄黎雯 on 2017/6/8.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UITableView(NoneData)
- (void)createNoDataView;
- (void)createNoDataWithFrame:(CGRect)frame;
- (void)createNoDataText:(NSString*)tishi;
- (void)hideView;
#pragma mark 包含图片文字按钮提示空数据
-(UIButton*)createNoDataWithImgStrBtn:(NSString*)imgstr content:(NSString*)content btnTitle:(NSString*)btnS btnC:(UIColor*)btnc frame:(CGRect)frame;
-(UIButton*)createNoDataWithImgStrBtn:(NSString*)imgstr content:(NSString*)content btnTitle:(NSString*)btnS btnC:(UIColor*)btnc;
@end
