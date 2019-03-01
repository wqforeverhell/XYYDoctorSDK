//
//  HlwTextView.m
//  yaolianti
//
//  Created by zl on 2018/7/11.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "HlwTextView.h"
#import "XYYDoctorSDK.h"
@interface HlwTextView()
{
     onTextDoneBlock _block;
}

@end
@implementation HlwTextView
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setDone];
}

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setDone];
        _contentColor = [UIColor blackColor];
        _editing = NO;
        _placeholderColor = [UIColor lightGrayColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishEditing:) name:UITextViewTextDidEndEditingNotification object:self];

    }
    return self;
}

-(void)setDone{
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,44)];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemCancel) target:self action:@selector(cancel)];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemDone) target:self action:@selector(print)];
    
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:self
                                                                               action:nil];
    flexSpacer.width = SCREEN_WIDTH-100;
    NSArray *items = @[cancel,flexSpacer,button];
    [bar setItems:items animated:YES];
    self.inputAccessoryView = bar;
}
-(void)cancel{
    [self endEditing:YES];
}
- (void) print {
    [self endEditing:YES];
    
    if (_hlwDelegate&&[_hlwDelegate respondsToSelector:@selector(onDone:textView:)]) {
        [_hlwDelegate onDone:self.text textView:self];
    }
    if (_hlwDelegate&&[_hlwDelegate respondsToSelector:@selector(onDone:)]) {
        [_hlwDelegate onDone:self.text];
    }
    if (_block) {
        _block(self.text);
    }
}
-(void)setOnTextDoneBlock:(onTextDoneBlock)block{
    if (block) {
        _block=nil;
        _block=[block copy];
    }
}
#pragma mark - super

- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    _contentColor = textColor;
}

- (NSString *)text {
    if ([super.text isEqualToString:_placeholder] && super.textColor == _placeholderColor) {
        return @"";
    }
    return [super text];
}

- (void)setText:(NSString *)string {
    if (string == nil || string.length == 0) {
        return;
    }
    super.textColor = _contentColor;
    [super setText:string];
}


#pragma mark - setting

- (void)setPlaceholder:(NSString *)string {
    _placeholder = string;
    [self finishEditing:nil];
}


#pragma mark - notification

- (void)startEditing:(NSNotification *)notification {
    _editing = YES;
    if ([super.text isEqualToString:_placeholder] && super.textColor == _placeholderColor) {
        
        super.textColor = _contentColor;
        super.text = @"";
    }
}

- (void)finishEditing:(NSNotification *)notification {
    _editing = NO;
    if (super.text.length == 0) {
        
        super.textColor = _placeholderColor;
        super.text = _placeholder;
    }
}

@end
