//
//  HlwTextField.m
//  xinyaomeng
//
//  Created by 黄黎雯 on 2017/6/20.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import "HlwTextField.h"
#import "XYYSDK.h"
@interface HlwTextField(){
    onTextDoneBlock _block;
}
@end
@implementation HlwTextField
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setDone];
}

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setDone];
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
    
    if (_hlwDelegate&&[_hlwDelegate respondsToSelector:@selector(onDone:textField:)]) {
        [_hlwDelegate onDone:self.text textField:self];
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
@end
