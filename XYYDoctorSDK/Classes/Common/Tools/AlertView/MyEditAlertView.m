//
//  MyEditAlertView.m
//  xinyaomeng
//
//  Created by 黄黎雯 on 2017/6/8.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import "MyEditAlertView.h"
#import "NSString+Category.h"
#import "UIView+Category.h"
#import "XYYSDK.h"
@interface MyEditAlertView()<UITextFieldDelegate> {
    UILabel* _moneyLabel;
    BOOL _forMoney;
}

@end

@implementation MyEditAlertView

- (id)init {
    self = [super init];
    _forMoney = NO;
    if (self) {
        self.autoresizesSubviews = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}


- (instancetype)initWithTitleName:(NSString*)titleName {
    return [self initWithTitleName:titleName DanWei:@""];
}

- (instancetype)initWithTitleName:(NSString*)titleName DanWei:(NSString*)danWei {
    if (self = [self init]) {
        [self addBackgroundImage];
        
        // 标题
        if(IS_EMPTY(danWei)) {
            [self initTitle:titleName];
        }
        else {
            [self initTitle:[NSString stringWithFormat:@"%@(单位:%@)", titleName, danWei]];
        }
        
        // 选择器
        [self initEditor];
        
        [self addButtons:@"取消" RightButton:@"确定"];
        
        [self adjustBackground];
    }
    return self;
}

- (instancetype) initWithTitle:(NSString *)title tip:(NSString *)tip {
    if (self = [self init]) {
        [self addBackgroundImage];
        
        // 标题
        [self initTitle:title];
        
        // 提示语
        UILabel* tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.height, self.width-30, 20)];
        tipLabel.numberOfLines=0;
        tipLabel.lineBreakMode=NSLineBreakByCharWrapping;
        tipLabel.font = [UIFont systemFontOfSize:14];
        tipLabel.textColor = [UIColor darkGrayColor];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.text=tip;
        CGSize size = CGSizeMake(self.width-30,SCREEN_HEIGHT-64); //设置一个行高上限
        NSDictionary *attribute = @{NSFontAttributeName: tipLabel.font};
        CGSize labelSize = [tipLabel.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        CGRect frame=[tipLabel frame];
        frame.size.height=labelSize.height;
        tipLabel.frame=frame;
        [self addSubview:tipLabel];
        self.height = CGRectGetMaxY(tipLabel.frame) + 10;
        
        // 选择器
        //[self initEditor];
        
       [self addButtons:@"取消" RightButton:@"确定"];
        
        [self adjustBackground];
    }
    return self;
}

- (instancetype)initWithTitleForMoney:(NSString *)title {
    if (self = [self init]) {
        _forMoney = YES;
        [self addBackgroundImage];
        // 标题
        [self initTitle:title];
        // 选择器
        [self initEditor];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.height, self.width-30, 20)];
        _moneyLabel.font = [UIFont systemFontOfSize:12];
        _moneyLabel.textColor = [UIColor grayColor];
        _moneyLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_moneyLabel];
        self.height = CGRectGetMaxY(_moneyLabel.frame) + 10;
        
        [self addButtons:@"取消" RightButton:@"确定"];
        
        [self adjustBackground];
    }
    return self;
}

- (void)initEditor {
    self.textfiled = [[UITextField alloc] initWithFrame:CGRectMake(15, self.height+10, self.width-30, 35)];
    self.textfiled.borderStyle = UITextBorderStyleRoundedRect;
    self.textfiled.layer.cornerRadius = 5;
    self.textfiled.layer.masksToBounds = YES;
    self.textfiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    if (_forMoney) {
        self.textfiled.keyboardType = UIKeyboardTypeDecimalPad;
        self.textfiled.delegate = self;
    }
    [self.textfiled setBackgroundColor:[UIColor whiteColor]];
    [self.textfiled setTextColor:RGBA(160, 160, 160, 1)];
    [self addSubview:self.textfiled];
    self.height = CGRectGetMaxY(self.textfiled.frame) + 10;
}

- (void) leftBtnClicked:(id)sender {
    [super leftBtnClicked:sender];
    
}

- (void)rightBtnClicked:(id)sender {
    [super rightBtnClicked:sender];
    if (self.editor) {
        self.editor(self.textfiled.text);
    }
    [self hideKeyWindow];
}

- (void)show {
    [self appRootViewController];
    self.yOffset = -self.height/2.0;
    [self.textfiled becomeFirstResponder];
    [super show];
}

- (void)setNumOnly:(BOOL)numOnly {
    if(numOnly) {
        _textfiled.keyboardType = UIKeyboardTypePhonePad;
    }
}

- (void)setTextValue:(NSString*)textValue {
    self.textfiled.text = textValue;
    if (_forMoney) {
        if (IS_EMPTY(textValue)) {
            _moneyLabel.text = [NSString stringWithFormat:@"大写金额：%@", [textValue ToChineseAmount]];
        }
    }
}

- (void)setTextValue:(NSString*)textValue PlaceHolder:(NSString*)placeholder {
    self.textfiled.text = textValue;
    self.textfiled.placeholder = placeholder;
    if (_forMoney) {
        if (IS_EMPTY(textValue)) {
            _moneyLabel.text = [NSString stringWithFormat:@"大写金额：%@", [textValue ToChineseAmount]];
        }
    }
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (_forMoney) {
        NSString* text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        _moneyLabel.text = [NSString stringWithFormat:@"大写金额：%@", [text ToChineseAmount]];
    }
    return YES;
}

-(BOOL)needHideBg{
    return NO;
}

@end
