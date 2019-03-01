//
//  YLTWebView.m
//  yaolianti-c
//
//  Created by zl on 2018/6/26.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "YLTWebView.h"

@implementation YLTWebView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self= [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
- (void)createView {
    NSURL *filePath = [[NSBundle mainBundle] URLForResource:@"H5/homePlay.html" withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:filePath];
    self.delegate = self;
    [self loadRequest:request];
}
@end
