//
//  HlwTextField.h
//  xinyaomeng
//
//  Created by 黄黎雯 on 2017/6/20.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^onTextDoneBlock)(NSString*text);
@protocol HlwTextFieldDelegate <NSObject>
-(void)onDone:(NSString*)text;
-(void)onDone:(NSString*)text textField:(UITextField *)textField;
@end
@interface HlwTextField : UITextField
@property(weak,nonatomic)id<HlwTextFieldDelegate>hlwDelegate;

-(id)initWithFrame:(CGRect)frame;
-(void)setOnTextDoneBlock:(onTextDoneBlock)block;

@end
