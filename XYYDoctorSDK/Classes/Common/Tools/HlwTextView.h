//
//  HlwTextView.h
//  yaolianti
//
//  Created by zl on 2018/7/11.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^onTextDoneBlock)(NSString*text);
@protocol HlwTextViewDelegate <NSObject>
-(void)onDone:(NSString*)text;
-(void)onDone:(NSString*)text textView:(UITextView *)textView;
@end

@interface HlwTextView : UITextView
{
    UIColor *_contentColor;
    BOOL _editing;
}

@property(weak,nonatomic)id<HlwTextViewDelegate>hlwDelegate;

@property(strong, nonatomic) NSString *placeholder;
@property(strong, nonatomic) UIColor *placeholderColor;
-(id)initWithFrame:(CGRect)frame;
-(void)setOnTextDoneBlock:(onTextDoneBlock)block;

@end
