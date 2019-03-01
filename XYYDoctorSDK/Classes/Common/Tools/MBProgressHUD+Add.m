//
//  MBProgressHUD+Add.m
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Add.h"
//导航栏状态栏高度
#define TITLE_HEIGHT_WITH_BARHUD ([[UIApplication sharedApplication] statusBarFrame].size.height+44)
#define WAIT_TIME 1.2

@implementation MBProgressHUD (Add)

#pragma mark 显示信息
+ (void)show:(NSString *)message icon:(NSString *)icon view:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showMessag:message toView:view];
    
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:WAIT_TIME];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view {
    
    BOOL needAdjust = NO;
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
        needAdjust = YES;
    }
    [MBProgressHUD hideAllHUDsForView:view animated:NO];
    // 快速显示一个提示信息
    MBProgressHUD *hud = nil;
    if(needAdjust) {
       // hud = [MBProgressHUD showHUDAddedTo:view Frame:[self getKeyWindowFrame] animated:YES];
    }
    else {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        if([view isKindOfClass:[UITableView class]]){
            UITableView*tableview=(UITableView*)view;
            NSLog(@"%0.2f",tableview.contentSize.height);
            if (tableview.contentOffset.y>[UIScreen mainScreen].bounds.size.height) {
                hud.yOffset=(tableview.contentSize.height-tableview.contentOffset.y);
            }
        }
    }
    if(message && message.length != 0) {
        hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16.0f];
        hud.detailsLabelText = message;
    }
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    
    return hud;
}

+ (MBProgressHUD*)showMessageAutoHide:(NSString *)message toView:(UIView *)view {
    
    MBProgressHUD *hud = [MBProgressHUD showMessag:message toView:view];
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:WAIT_TIME];
    
    return hud;
}

#pragma mark - keywindow显示情况,调整试图的位置,必须在导航栏下面
+ (CGRect)getKeyWindowFrame {
    CGRect frame;
    frame.origin.y = TITLE_HEIGHT_WITH_BARHUD;
    frame.origin.x = 0;
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    frame.size.height = [UIScreen mainScreen].bounds.size.height-TITLE_HEIGHT_WITH_BARHUD;
    return frame;
}

@end
