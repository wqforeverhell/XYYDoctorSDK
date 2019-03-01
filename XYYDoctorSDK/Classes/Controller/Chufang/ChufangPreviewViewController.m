//
//  ChufangPreviewViewController.m
//  yaolianti
//
//  Created by qxg on 2018/9/5.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "ChufangPreviewViewController.h"
#import <WebKit/WebKit.h>
#import "RecordCmd.h"
#import "XYYDoctorSDK.h"
@interface ChufangPreviewViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic,strong)WKWebView *myWebView;
@end
@implementation ChufangPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self setupBack];
    [self setupTitleWithString:@"处方详情"];
    self.hidesBottomBarWhenPushed = YES;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
     _myWebView=[[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _myWebView.UIDelegate=self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@freemarker/appPrescriptFreeMarker?prescriptionCode=%@&&loginType=1",API_HOST,self.chufangCode]]];
    [self.myWebView loadRequest:request];
    _myWebView.navigationDelegate = self;
    [self.view addSubview:_myWebView];
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
