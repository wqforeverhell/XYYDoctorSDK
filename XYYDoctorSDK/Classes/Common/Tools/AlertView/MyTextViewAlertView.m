//
//  MyTextViewAlertView.m
//  xinyaomeng
//
//  Created by 黄黎雯 on 2017/6/8.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import "MyTextViewAlertView.h"
#import "XYYSDK.h"
@interface MyTextViewAlertView ()<UITextViewDelegate>{
    NSString*strTs;
    UILabel*uilabel;
}

@end
@implementation MyTextViewAlertView

- (id)init {
    self = [super init];
    if (self) {
        self.autoresizesSubviews = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}


- (instancetype)initWithTitleName:(NSString*)titleName {
    if (self = [self init]) {
        self.width=SCREEN_WIDTH-30;
        [self addBackgroundImage];
        
        // 标题
        [self initTitle:titleName];
        
        // 选择器
        [self initEditor];
        
        [self addButtons:@"取消" RightButton:@"确定"];
        
        [self adjustBackground];
    }
    return self;
}

- (void)initEditor {
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(15, self.height+10, self.width-30, 150)];
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.borderColor = [HexRGB(0xf3f3f3) CGColor];
    self.textView.layer.borderWidth = 1.0;
    [self.textView setFont:[UIFont systemFontOfSize:15.0f]];
    [self.textView setBackgroundColor:[UIColor whiteColor]];
    [self.textView setTextColor:RGBA(160, 160, 160, 1)];
    self.textView.delegate=self;
    [self addSubview:self.textView];
    
    
    uilabel =[[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMinY(self.textView.frame) + 8, self.width-30, 20)];
    uilabel.enabled = NO;//lable必须设置为不可用
    uilabel.backgroundColor = [UIColor clearColor];
    uilabel.textColor=[UIColor grayColor];
    [self addSubview:uilabel];
    
    self.height = CGRectGetMaxY(self.textView.frame) + 10;
}

- (void) leftBtnClicked:(id)sender {
    [super leftBtnClicked:sender];
    
//    [self hideKeyWindow];
}

- (void)rightBtnClicked:(id)sender {
    [super rightBtnClicked:sender];
    if (self.editor) {
        self.editor(self.textView.text);
    }
}

- (void)show {
    [self appRootViewController];
    self.yOffset = -self.height/2.0;
    [self.textView becomeFirstResponder];
    [super show];
}

-(BOOL)needHideBg{
    return NO;
}

- (void)setTextValue:(NSString*)textValue {
    self.textView.text = textValue;
}

- (void)setTextValue:(NSString*)textValue PlaceHolder:(NSString*)placeholder {
    self.textView.text = textValue;
    strTs=placeholder;
    if (IS_EMPTY(textValue)) {
        uilabel.text=placeholder;
    }else{
        uilabel.text=@"";
    }
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        uilabel.text = strTs;
    }else{
        uilabel.text = @"";
    }
}

@end
