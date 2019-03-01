//
//  HDInputTableViewCell.h
//  InputTableViewDemo
//
//  Created by Hou on 17/6/19.
//  Copyright © 2017年 HoHoDoDo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDTextField.h"

/** 限制输入，只能为数字 */
#define ALLOW_NUMBERS   @"0123456789\n"
/** 限制输入，只能为字母、数字 */
#define ALLOW_ALPHANUM  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789\n"

@class HDInputTableViewCell, HDInputModel;

@protocol HDInputTableViewCellDelegate <NSObject>
@optional
/**
 *  可点击cell代理
 *
 *  @param cell 当前输入框所属的Cell对象
 *  @param event 自定义的事件标识
 *
 */
- (void)hd_inputTableViewCell:(HDInputTableViewCell *)cell didSelectEvent:(NSString *)event;
/**
 *  输入框编辑时的代理
 *
 *  @param cell 当前输入框所属的Cell对象
 *  @param value 输入框编辑时输入的每个字符
 *
 */
- (void)hd_inputTableViewCell:(HDInputTableViewCell *)cell textFieldEditingChanged:(NSString *)value;
/**
 *  输入框编辑时控制输入框输入的代理
 *
 *  @param cell 当前输入框所属的Cell对象
 *  @param range 输入框输入字符的当前位置
 *  @param string 输入框编辑时输入的每个字符
 *
 *  @return bool value 是否可接受继续编辑，default = YES
 */
- (BOOL)hd_inputTableViewCell:(HDInputTableViewCell *)cell textFieldShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
@end

@interface HDInputTableViewCell : UITableViewCell
<UITextFieldDelegate>

+ (instancetype)hd_initInputTableViewCellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier delegate:(id<HDInputTableViewCellDelegate>)delegate;

- (void)setObject:(HDInputModel *)object;
/**
 *  输入框限制
 *
 *  @param length 限制输入的最大长度
 *  @param allowString 允许输入的字符集,值为nil或空时表示允许任何字符
 *  @param character 输入框每次输入的单个字符
 *
 *  @return bool value
 */
- (BOOL)hd_inputLimitLength:(NSInteger)length allowString:(NSString *)allowString inputCharacter:(NSString *)character;
/**
 *  输入框限制
 *
 *  @param length 输入金额整数位的最大长度
 *  @param digitsLength 输入金额小数位的最大长度（即允许保留小数点后几位）
 *  @param character 输入框每次输入的单个字符
 *
 *  @return bool value
 */
- (BOOL)hd_amountFormatWithIntegerBitLength:(NSInteger)length digitsLength:(NSInteger)digitsLength inputCharacter:(NSString *)character;

@property (nonatomic, strong) HDInputModel  *inputModel;
@property (nonatomic, strong) HDTextField   *inputField;
@property (nonatomic, strong) UIImageView   *iconView;
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UIControl     *maskControl;
@property (nonatomic, strong) CALayer       *line;
@property (nonatomic, strong) NSString      *event;
@property (nonatomic, weak  ) id <HDInputTableViewCellDelegate> delegate;
@end


/******************************* HDInputModel **********************************/

@interface HDInputModel : NSObject
///设置左视图icon
@property (nonatomic, strong) NSString         *iconName;
///设置左边标题的值
@property (nonatomic, strong) NSString         *title;
///设置textfield.text的值
@property (nonatomic, strong) NSString         *text;
///设置textfield文本颜色
@property (nonatomic, strong) UIColor          *textColor;
///设置textfield.placeHolder的值
@property (nonatomic, strong) NSString         *placeHolder;
///设置输入框文本对齐方式
@property (nonatomic, assign) NSTextAlignment  inputAlignment;
///设置键盘类型
@property (nonatomic, assign) UIKeyboardType   keyboardType;
///设置textfield是否可编辑
@property (nonatomic, assign) BOOL             editEnabled;
///设置可点击状态，值为YES时，textfield不可编辑，可点击
@property (nonatomic, assign) BOOL             clickEnable;
///设置密文显示
@property (nonatomic, assign) BOOL             secureTextEntry;
///设置title是否两端对齐
@property (nonatomic, assign) BOOL             alignmentBothEnds;
///可设置标题最大宽度，title默认长度80px
@property (nonatomic, assign) CGFloat          titleMaxWidth;
///当separatorStyle = None时，需要自己画线，以contentView为父视图设置frame，line默认隐藏，设置此属性后自动显示
@property (nonatomic, assign) CGRect           lineFrame;
///设置cell事件标识
@property (nonatomic, strong) NSString         *event;
///设置右视图的view
@property (nonatomic, strong) UIView           *accessoryView;
///设置cell右视图类型
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;
@end


/******************************* UILabel (HDCategory) **********************************/

@interface UILabel (HDCategory)
/**
 *  两端对齐
 */
- (void)alignmentBothEnds;
@end


/******************************* UIView (HDCategory) **********************************/

@interface UIView (HDCategory)
/**
 *  坐标系
 */
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize  size;
/**
 *  实现UIView抖动效果
 */
- (void)shakeAnimation;
/**
 *  给view添加点击事件
 *
 *  @param target   目标
 *  @param action   事件
 */
- (void)addTarget:(id)target action:(SEL)action;
@end



