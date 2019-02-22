//
//  BaseTableViewController.h
//  xinyaomeng
//
//  Created by 黄黎雯 on 2017/6/8.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UITableViewController
@property (nonatomic, assign) BOOL preScrollEnable;
@property (nonatomic, assign) BOOL preInterEnable;
@property (nonatomic, assign) CGFloat moveY;

- (void)registerHideKeyWindow;
- (void)hideKeyWindow;
-(void)setlineImageViewalpha:(CGFloat)alpha;
- (void)setShadoff:(CGSize)size withColor:(UIColor*)color;
- (void) setupBack;
- (void) setupBack:(NSString *)name;
- (void) setupNextWithImage:(UIImage*) image;
- (UIButton*) setupNextWithString:(NSString*) text;
- (void) setupNextWithArray:(NSArray*) array;
- (void) setupNextWithString:(NSString *)text withColor:(UIColor *)color;
- (void)setupTitleWithString:(NSString *)text withColor:(UIColor *)color;
-(void)setupTitleWithString:(NSString *)text;


// 回调  子类继承各自处理
- (void)onBack;   //返回
- (void)onNext;  //下一步
//- (void)titleItemClicked:(UIButton*)button; //自定义顶部按钮回调
- (void)popByDrag;  //侧拉返回的回调
- (BOOL)needDragBack; //是否需要侧拉返回
- (BOOL)needRegisterHideKeyboard;  //是否需要自动隐藏键盘
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch;

@end
