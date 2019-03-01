//
//  BSYTextFiled.m
//  BSYKeyboard
//
//  Created by 白仕云 on 2018/5/28.
//  Copyright © 2018年 BSY.com. All rights reserved.
//



#import "BSYTextFiled.h"
#import "BSYIDCardBoard.h"
#import "BSYBoardToolBar.h"
@interface BSYTextFiled()
@property (nonatomic ,strong)BSYIDCardBoard *bsy_idCardBoard;

@property (nonatomic ,copy)NSString *currentString;
@end
@implementation BSYTextFiled

-(instancetype)initWithFrame:(CGRect)frame showKeyBoardType:(BSYBoardType)keyBoardType
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addViewWithKeyBoardType:keyBoardType];
        self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 35)];
        self.leftViewMode = UITextFieldViewModeAlways;
        

        
    }
    return self;
}

/**
根据不同的键盘类型添加个字的键盘View
 @param keyBoardType 键盘类型
 */
-(void)addViewWithKeyBoardType:(BSYBoardType)keyBoardType
{
    self.currentString = @"";
    UIView *window = [[[[[UIApplication sharedApplication] windows] lastObject] subviews] lastObject];

    NSLog(@"   %f",[window.subviews lastObject].frame.size.height);

    switch (keyBoardType) {
        case BSYIDCardType:
            self.inputAccessoryView =self.toolBar;
            [self BSYIDCardType:keyBoardType ];
            break;
        case BSYBoardTypeNone:

            break;
        default:
            break;
    }
    __weak typeof(self)selfWeak  =self;
    [self.toolBar setBSYBoardToolBarFinishedBtnBlock:^(NSString *currentString) {
        [selfWeak resignFirstResponder];
    }];
}
/**
 身份证的键盘
 */
-(void)BSYIDCardType:(BSYBoardType)keyBoardType
{
     self.inputView = self.bsy_idCardBoard;
    __weak typeof(self)selfWeak  =self;
    [self.bsy_idCardBoard setBSYIDCardBoardStringBlock:^(NSString *keyBoardString) {
        [selfWeak ProcessingResultingString:keyBoardString bsyBoard:selfWeak.bsy_idCardBoard];
    }];
}

/**
 字符串处理
 @param keyBoardString 当前字符串
 */
-(void)ProcessingResultingString:(NSString *)keyBoardString bsyBoard:(UIView *)bsyBoard
{
    if ([keyBoardString isEqualToString:@"删除"]) {
        if (![self.currentString isEqualToString:@""]) {
            self.currentString = [self.currentString substringToIndex:self.currentString.length-1];
        }
        self.text = self.currentString;
    }else if ([keyBoardString isEqualToString:@"完成"]){
        [self resignFirstResponder];
    }else{
        self.currentString = [self.currentString stringByAppendingString:keyBoardString];
        self.text = self.currentString;
    }
}

/**
 键盘背景颜色
 */

-(void)setShowKeyBoardBackColor:(UIColor *)showKeyBoardBackColor
{
    _showKeyBoardBackColor = showKeyBoardBackColor;
    [self.bsy_idCardBoard setShowKeyBoardBackColor:showKeyBoardBackColor];
}

/**
 按键背景颜色
 */
-(void)setKeyBoardItemBackColor:(UIColor *)keyBoardItemBackColor
{
    _keyBoardItemBackColor = keyBoardItemBackColor;
    [self.bsy_idCardBoard setShowKeyBoardItemBackColor:keyBoardItemBackColor];

}

/**
 按键字体颜色
 */
-(void)setKeyBoardItemTextColor:(UIColor *)keyBoardItemTextColor
{
    _keyBoardItemTextColor = keyBoardItemTextColor;
    [self.bsy_idCardBoard setShowKeyBoardItemTextColor:keyBoardItemTextColor];
}
/**
 键盘ToolBar颜色
 */
-(void)setShowKeyBoardToolBarBackColor:(UIColor *)showKeyBoardToolBarBackColor
{
    _showKeyBoardToolBarBackColor = showKeyBoardToolBarBackColor;
    [self.toolBar setShowKeyBoardToolBarBackColor:showKeyBoardToolBarBackColor];
}
/**
 键盘ToolBar 完成字体颜色
 */

-(void)setShowKeyBoardToolBarFinshinedBtnTitleColor:(UIColor *)showKeyBoardToolBarFinshinedBtnTitleColor
{
    _showKeyBoardToolBarFinshinedBtnTitleColor = showKeyBoardToolBarFinshinedBtnTitleColor;
    [self.toolBar setFinshinedBtnTitleColor:showKeyBoardToolBarFinshinedBtnTitleColor];
}
/**
 键盘ToolBar title字体颜色
 */
-(void)setShowKeyBoardToolBarTitleColor:(UIColor *)showKeyBoardToolBarTitleColor
{
    _showKeyBoardToolBarTitleColor  =showKeyBoardToolBarTitleColor;
    [self.toolBar setShowKeyBoardToolBarTitleColor:showKeyBoardToolBarTitleColor];
}

/**
 键盘ToolBar titleString
 */
-(void)setShowKeyBoardToolBarTitleString:(NSString *)showKeyBoardToolBarTitleString
{
    _showKeyBoardToolBarTitleString = showKeyBoardToolBarTitleString;
    [self.toolBar setShowKeyBoardToolBarTitleString:showKeyBoardToolBarTitleString];
}
/**
 创建身份证键盘View
 @return 返回键盘View
 */
-(BSYIDCardBoard *)bsy_idCardBoard
{
    if (!_bsy_idCardBoard) {
        _bsy_idCardBoard = [[BSYIDCardBoard alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 205) inputViewStyle:UIInputViewStyleDefault];
    }
    return _bsy_idCardBoard;
}

/**
 创建ToolBarView
 @return 返回键盘View
 */
-(BSYBoardToolBar *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[BSYBoardToolBar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44.0)];
    }
    return _toolBar;
}

@end
