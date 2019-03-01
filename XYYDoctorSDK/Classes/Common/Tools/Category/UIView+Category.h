//
//  UIView+Category.h
//  ImHere
//
//  Created by 卢明渊 on 15/3/23.
//  Copyright (c) 2015年 我在这. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

- (UIViewController *)getCurrentViewController;

//隐藏键盘
- (void)hideKeyWindow;

//查找键盘
- (UIView *)findKeyboard;

//在view子视图里查找键盘
- (UIView *)findKeyboardInView:(UIView *)view;

// 当前view的截图
- (UIImage*) snapshot;
@end
