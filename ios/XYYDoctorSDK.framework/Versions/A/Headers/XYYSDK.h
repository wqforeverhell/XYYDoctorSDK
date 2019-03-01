//
//  yaolianti.pch
//  yaolianti
//
//  Created by huangliwen on 2018/6/5.
//  Copyright © 2018年 hlw. All rights reserved.
//

// Include any system framework and library headers here that should be included in all compilation units.
// You will also need to set the Prefix Header build setting of one or more of your targets to reference this file.

//本地数据库保存目录（一般不删除）
#ifdef __OBJC__
#import "MBProgressHUD+Add.h"

#define LOCAL_FILE_PATH @"db"
//获取RGB实现
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]
//渐变色
#define JIANBIAN_GREEN_START_COLOR HexRGB(0x2cbeb0)//绿色渐变开始颜色
#define JIANBIAN_GREEN_OVER_COLOR HexRGB(0x65e5d9)//绿色渐变结束颜色
#define JIANBIAN_ORANGE_START_COLOR HexRGB(0xf6ba64)//橙色渐变开始颜色
#define JIANBIAN_ORANGE_OVER_COLOR HexRGB(0xfbeeaa)//橙色渐变结束颜色
#define JIANBIAN_GRAY_START_COLOR HexRGB(0x919191)//灰色渐变开始颜色
#define JIANBIAN_GRAY_OVER_COLOR HexRGB(0xbfbdbd)//灰色渐变结束颜色
//主页底部颜色值
#define MAIN_BOTTOM_COLOR RGBA(255, 255, 255, 1.0)
//顶部bar颜色值
#define NVIGATION_BACKGOUND_COLOR RGBA(253, 253, 253, 1.0)
#define DEFAULT_TITLE_COLOR RGBA(3, 3, 3, 1.0)
#define NEXT_TITLE_COLOR HexRGB(0x030303)
#define TINTCOLOR HexRGB(0x252525)
#define BACKGOUND_COLOR RGBA(248, 248, 248, 1.0)
//判断字符串是否为空
#define IS_EMPTY(str) (str == nil || [str length] == 0)

//包括状态栏的屏幕尺寸
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//不包括状态栏的屏幕尺寸
#define FRAME_WIDTH ([UIScreen mainScreen].applicationFrame.size.width)
#define FRAME_HEIGHT ([UIScreen mainScreen].applicationFrame.size.height)

//状态栏尺寸,不包含热点时的多出尺寸
#define STATUS_BAR_WIDTH ([[UIApplication sharedApplication] statusBarFrame].size.width)
#define STATUS_BAR_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height)

// 弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//导航栏状态栏高度
#define TITLE_HEIGHT_WITH_BAR (STATUS_BAR_HEIGHT+44)

#define APP_TOKEN @"app_token"
#define UID @"uid"
#define DEVICETOKEN @"deviceToken"
#endif /* yaolianti_pch */
