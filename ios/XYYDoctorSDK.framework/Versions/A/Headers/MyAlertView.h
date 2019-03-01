//
//  MyAlertView.h
//  xinyaomeng
//
//  Created by 黄黎雯 on 2017/6/8.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAlertView : UIView

- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButton:(NSString *)leftTitle
   rightButton:(NSString *)rigthTitle;

- (void)show;

- (void)show:(CGRect)frame;

- (void)initTitle:(NSString*)title;
- (void)addButtons:(NSString*)left RightButton:(NSString*)right;
- (void)addButtons:(NSString*)left MiddleButton:(NSString*)middle RightButton:(NSString*)right;
- (void)addBackgroundImage;
- (void)adjustBackground;
- (UIViewController *)appRootViewController;
- (void)leftBtnClicked:(id)sender;
- (void)middleBtnClicked:(id)sender;
- (void)rightBtnClicked:(id)sender;
- (BOOL)needHideBg;
- (void)dismissAlert;
- (id)initWtihWh:(CGFloat)width height:(CGFloat)height;

@property(nonatomic, strong) UILabel* title;
@property(nonatomic, strong) UIImageView* background;

@property(nonatomic, copy) dispatch_block_t leftBlock;
@property(nonatomic, copy) dispatch_block_t middleBlock;
@property(nonatomic, copy) dispatch_block_t rightBlock;
@property(nonatomic, copy) dispatch_block_t dismissBlock;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;
@property(nonatomic, assign) CGFloat yOffset;

@end
