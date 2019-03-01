//
//  ChuPreviewViewController.m
//  yaolianti
//
//  Created by qxg on 2018/9/11.
//  Copyright © 2018年 hlw. All rights reserved.
//
#import "ChuPreviewViewController.h"
#import <WebKit/WebKit.h>
#import "HuanzheCmd.h"
#import "YLTAlertUtil.h"
#import "YLTCustomMessageAttachment.h"
#import "YLTSSessionMsgConverter.h"
#import "HuanZheWithMessageDBStruce.h"
#import "XYYDoctorSDK.h"
@interface ChuPreviewViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *commintBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIView *webBgView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
@implementation ChuPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBack];
    self.view.backgroundColor = RGB(240, 240, 240);
    [self setupTitleWithString:@"处方单"];
    _webView.opaque = NO;
    _webBgView.backgroundColor = RGB(240, 240, 240);
    _webView.delegate=self;
    _webView.backgroundColor = RGB(240, 240, 240);
    [_webView loadHTMLString:self.webStr baseURL:nil];
    _commintBtn.layer.cornerRadius = CGRectGetHeight(_commintBtn.frame)/2;
    _commintBtn.layer.masksToBounds = YES;
    _saveBtn.layer.cornerRadius = CGRectGetHeight(_saveBtn.frame)/2;
    _saveBtn.layer.masksToBounds = YES;
}
- (IBAction)click:(id)sender {
    [MBProgressHUD showMessag:@"" toView:self.view];
            SubmitChuFangCmd *cmd = [[SubmitChuFangCmd alloc]init];
            cmd.yxAccount = self.userDict[@"hxLoginAccount"];
            cmd.patientName = self.userDict[@"patientName"];
            cmd.telPhoneNum = self.userDict[@"telPhoneNum"];
            cmd.age = self.userDict[@"age"];
            cmd.sex = self.userDict[@"sex"];
            cmd.diagnoseType = [ConfigUtil intWithKey:DiAGNOSETYPE];
            cmd.allergyRecord = self.userDict[@"allergyRecord"];
            cmd.hospPrescriptionInfo = self.patienDict;
            cmd.cardId=self.userDict[@"cardId"];
            cmd.relationType = [ConfigUtil stringWithKey:RELATIONTYPE];
            if ([[ConfigUtil stringWithKey:RELATIONTYPE] isEqualToString:@"0"]) {
                cmd.employeeId = [ConfigUtil stringWithKey:EMID] ;
                 cmd.storeId = [ConfigUtil stringWithKey:STOREID] ;
            }else{
            }
            cmd.detailList = self.commitArray;
            WS(weakSelf);
            [[HttpNetwork getInstance] request:cmd success:^(BaseRespond *respond) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                if (respond.errorNo == 1) {
                    NIMSession *session = [NIMSession session:[ConfigUtil stringWithKey:LASTCHARTACCOUNT] type:NIMSessionTypeP2P];
                    YLTCustomMessageAttachment *attacment = [[YLTCustomMessageAttachment alloc] init];
                    attacment.type = ChufangMessageTypeKDCG;
                    NIMMessage *message = [YLTSSessionMsgConverter msgWithCustomMessage:attacment];
                    if ([[ConfigUtil stringWithKey:RELATIONTYPE] isEqualToString:@"0"]) {
                      message.text = [NSString stringWithFormat:@"处方单已开，处方单号：%@,请到处方管理查看",respond.data[@"result"][@"code"]];
                        attacment.messageText = [NSString stringWithFormat:@"处方单已开，处方单号：%@,请到处方管理查看",respond.data[@"result"][@"code"]];
                    }else{
                     message.text = [NSString stringWithFormat:@"处方单已开，处方单号：%@,请到处方单列表查看",respond.data[@"result"][@"code"]];
                     attacment.messageText = [NSString stringWithFormat:@"处方单已开，处方单号：%@,请到处方单列表查看",respond.data[@"result"][@"code"]];
                    }
                    NSError *error = nil;
                    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:&error];
                    [YLTAlertUtil presentAlertViewWithTitle:@"" message:@"您本次的处方单已提交成功" confirmTitle:@"确定" handler:^{
                        [ConfigUtil saveBool:YES withKey:KAICHUFANG_OVER];//设置防止多次开处方
                          [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_KAICHUFANG_SUCESS object:self];
                        [ConfigUtil setUserDefaults:@[] forKey:YPTOALT];
                        [NSGCDThread dispatchAfterInMailThread:^{
                            [weakSelf.navigationController popToViewController:[weakSelf.navigationController.childViewControllers objectAtIndex:weakSelf.navigationController.childViewControllers.count-4] animated:NO];
                    
                    [ConfigUtil setUserDefaults:@[] forKey:SAVE_YP_ARRAY];
                        } Delay:1000];
                    }];

                }
            } failed:^(BaseRespond *respond, NSString *error) {
                [MBProgressHUD showError:error toView:weakSelf.view];
            }];
}
- (IBAction)saveClick:(id)sender {
    [JumpUtil pushMoBanVC:self model:nil mArray:self.commitArray];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showMessag:@"" toView:self.view];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD showError:@"加载失败，请稍后再试" toView:self.view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
