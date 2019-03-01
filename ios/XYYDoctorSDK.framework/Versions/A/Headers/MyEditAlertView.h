//
//  MyEditAlertView.h
//  xinyaomeng
//
//  Created by 黄黎雯 on 2017/6/8.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import "MyAlertView.h"

@interface MyEditAlertView : MyAlertView

@property(nonatomic, strong) UITextField* textfiled;
@property(nonatomic, copy) void(^editor)(NSString* text); //返回参数为编辑后的内容

- (instancetype)initWithTitleName:(NSString*)titleName;
- (instancetype)initWithTitleName:(NSString*)titleName DanWei:(NSString*)danWei;
- (instancetype)initWithTitle:(NSString *)title tip:(NSString*) tip;
- (instancetype)initWithTitleForMoney:(NSString*) title;

- (void)setNumOnly:(BOOL)numOnly; //只能输入数字
- (void)setTextValue:(NSString*)textValue; //指定编辑前的内容
- (void)setTextValue:(NSString*)textValue PlaceHolder:(NSString*)placeholder; //指定编辑前的内容和无内容时的提示信息

@end
