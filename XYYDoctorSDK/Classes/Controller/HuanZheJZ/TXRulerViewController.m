//
//  TXRulerViewController.m
//  yaolianti
//
//  Created by qxg on 2018/8/15.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "TXRulerViewController.h"
#import <WebKit/WebKit.h>
#import "XYYDoctorSDK.h"
@interface TXRulerViewController ()<WKNavigationDelegate,WKUIDelegate>
@property(nonatomic,strong)WKWebView *  webView;
@end

@implementation TXRulerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self setupBack];
    [self setupTitleWithString:self.titie];
    
    _webView=[[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _webView.UIDelegate=self;
    _webView.navigationDelegate = self;
//    if ([_webUrl rangeOfString:@"http"].location == NSNotFound) {
//        _webUrl=[NSString stringWithFormat:@"%@%@",API_PLIST,_webUrl];
//    }
//    if (@available(iOS 11.0, *)) {
//        self..contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
}
#pragma mark - UIWebViewDelegate
#pragma mark ---------  WKNavigationDelegate  --------------
//在JS端调用alert函数时，会触发此代理方法。
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"弹窗了：%@",message);
    completionHandler();
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    //webview开始加载新页面时调用此方法，该方法调用时页面还没有变化
    [MBProgressHUD showMessag:@"" toView:self.view];
}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [MBProgressHUD showError:@"加载失败，请稍后再试" toView:self.view];
}
// 加载成功,传递值给js
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
