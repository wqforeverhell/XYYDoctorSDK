//
//  SessionViewController.m
//  CloudXinDemo
//
//  Created by mango on 16/8/25.
//  Copyright © 2016年 mango. All rights reserved.
//

#import "SessionViewController.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>
#import <NIMAVChat/NIMAVChat.h>
#import "NIMKit.h"
#import "TimerHolder.h"
#import "NSDictionary+Json.h"
#import "SessionConfig.h"
#import "CustomSysNotificationSender.h"
#import "YLTCustomMessageAttachment.h"
#import "NTESAudioChatViewController.h"
#import "NTESVideoChatViewController.h"
#import "HuanzheCmd.h"
#import "HuanZheWithMessageDBStruce.h"
#import "UIView+hlwCate.h"
#import "YLTSSessionMsgConverter.h"
#import "NIMCellLayoutConfig.h"
#import "NIMSessionMessageContentView.h"
#import "YLTAlertUtil.h"
#import "NTESGalleryViewController.h"
#import "XYYDoctorSDK.h"
#import "ConfigUtil.h"
@interface SessionViewController ()<NIMSystemNotificationManagerDelegate,TimerHolderDelegate,NIMMessageCellDelegate,NIMMediaManagerDelegate>
@property (nonatomic,strong) TimerHolder *titleTimer;
@property (nonatomic,strong) SessionConfig  *sessionConfig;
@property (nonatomic,strong) CustomSysNotificationSender *notificaionSender;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIButton *spButton;
@end
@implementation SessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.sessionInputView.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//状态栏设置为黑色
    //[self setupBackWithImage:[UIImage imageNamed:@"live_fanhui"] withString:@""];
    [self setupBack];
    [self initAddEventBtn];
    [self showHistoryView];
    self.view.backgroundColor = HexRGB(0xe4e7ec);;
    if (_isShowChufang) {
       if (![ConfigUtil boolWithKey:KAICHUFANG_OVER default:NO]) {
           [self setupNextWithString:@"开处方" withColor:RGB(2, 175, 102)];
        }
        if (!IS_EMPTY(self.strTitle))
        [self setupTitleWithString:self.strTitle];
        self.sessionInputView.hidden = NO;
        self.spButton.hidden = NO;
    }else{
        if (!IS_EMPTY(self.strTitle))
        [self setupTitleWithString:self.strTitle];
        self.sessionInputView.hidden = YES;
        self.spButton.hidden = YES;
        [self setupNextWithString:nil];
    }
    if(_isQueren){
        //如果是确认药品进入的需要可以发送消息
        self.sessionInputView.hidden = NO;
    }
    _notificaionSender  = [[CustomSysNotificationSender alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kaichufang) name:NOTICE_KAICHUFANG_SUCESS object:nil];
    BOOL disableCommandTyping = self.disableCommandTyping || (self.session.sessionType == NIMSessionTypeP2P &&[[NIMSDK sharedSDK].userManager isUserInBlackList:self.session.sessionId]);
    if (!disableCommandTyping) {
        _titleTimer = [[TimerHolder alloc] init];
        [[[NIMSDK sharedSDK] systemNotificationManager] addDelegate:self];
    }
}
- (void)showHistoryView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake375(0, 0, 375, 29)];
    view.backgroundColor = RGB(245,245,245);
    [self.view addSubview:view];
    self.bgView = view;
    UIButton *seleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seleBtn.frame = view.bounds;
    [seleBtn setTitle:[NSString stringWithFormat:@"点击查看%@的档案",[ConfigUtil stringWithKey:LASTCHARTYDNAME]] forState:UIControlStateNormal];
    [seleBtn setTitleColor:RGB(2, 175, 102) forState:UIControlStateNormal];
    seleBtn.backgroundColor = [UIColor clearColor];
    seleBtn.titleLabel.font = FONT(15);
    [seleBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:seleBtn];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTICE_KAICHUFANG_SUCESS object:nil];
}
- (void)kaichufang {
    _isShowChufang = NO;
    self.inputView.hidden = NO;
    self.spButton.hidden = NO;
    _isshowBtn = YES;
    [self setupNextWithString:@"" withColor:nil];
}
- (void)initAddEventBtn {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-71,50,66,66)];
    NSString *imagStr = [FileUtil getSDKResourcesPath];
    [btn setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",[imagStr stringByAppendingPathComponent:@"icon_end"]]] forState:UIControlStateNormal];
    //[btn setImage:[UIImage XYY_imageInKit:@"icon_end"]  forState:UIControlStateNormal];
    btn.tag = 0;
    btn.layer.cornerRadius = CGRectGetHeight(btn.frame)/2;
    [self.view addSubview:btn];
    //self.spButton.backgroundColor = [UIColor redColor];
    self.spButton = btn;
    [_spButton addTarget:self action:@selector(addEvent) forControlEvents:UIControlEventTouchUpInside];
    //添加手势
    UIPanGestureRecognizer *panRcognize=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [panRcognize setMinimumNumberOfTouches:1];
    [panRcognize setEnabled:YES];
    [panRcognize delaysTouchesEnded];
    [panRcognize cancelsTouchesInView];
    [btn addGestureRecognizer:panRcognize];
}
- (void)addEvent {
    WS(weakSelf);
    [YLTAlertUtil presentAlertViewWithTitle:@"" message:@"是否结束问诊？" cancelTitle:@"取消" defaultTitle:@"确定" distinct:NO cancel:^{
        [ConfigUtil saveBool:NO withKey:KAICHUFANG_OVER];
    } confirm:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_KAIDAN_SUCCESS object:self];
        NIMSession *session = [NIMSession session:[ConfigUtil stringWithKey:LASTCHARTACCOUNT]  type:NIMSessionTypeP2P];
        YLTCustomMessageAttachment *attacment = [[YLTCustomMessageAttachment alloc] init];
        attacment.type = ChufangMessageTypeJSWZ;
        attacment.messageText = @"结束通话";
        NIMMessage *message = [YLTSSessionMsgConverter msgWithCustomMessage:attacment];
        message.text = @"结束通话";
        [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
        
        GetDoctordoctorRefuseCmd *cmd = [[GetDoctordoctorRefuseCmd alloc]init];
        cmd.hxLoginAccount = [ConfigUtil stringWithKey:LASTCHARTACCOUNT];
        HuanZheWithMessageDBStruce *model = [HuanZheWithMessageDBStruce getPatienInfoWithHXAcountId:[ConfigUtil stringWithKey:LASTCHARTACCOUNT]];
        [model deleteToDB];
        [ConfigUtil setUserDefaults:@[] forKey:SAVE_YP_ARRAY];
        //[[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_KAIDAN object:self];
         [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[HttpNetwork getInstance] request:cmd success:^(BaseRespond *respond) {
            [NSGCDThread dispatchAfterInMailThread:^{
            // [weakSelf.navigationController popToViewController:[weakSelf.navigationController.childViewControllers objectAtIndex:weakSelf.navigationController.childViewControllers.count-5] animated:NO];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            } Delay:500];
        } failed:^(BaseRespond *respond, NSString *error) {
            // [MBProgressHUD showError:error toView:weakSelf.view];
            [NSGCDThread dispatchAfterInMailThread:^{
                //                                    [weakSelf.navigationController popToViewController:[weakSelf.navigationController.childViewControllers objectAtIndex:weakSelf.navigationController.childViewControllers.count-5] animated:NO];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } Delay:500];
        }];
    }];
   
}
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    //移动状态
    UIGestureRecognizerState recState =  recognizer.state;
    
    switch (recState) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [recognizer translationInView:self.navigationController.view];
            recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint stopPoint = CGPointMake(0, SCREEN_HEIGHT / 2.0);
            
            if (recognizer.view.center.x < SCREEN_WIDTH / 2.0) {
                if (recognizer.view.center.y <= SCREEN_HEIGHT/2.0) {
                    //左上
                    if (recognizer.view.center.x  >= recognizer.view.center.y) {
                       stopPoint = CGPointMake(self.spButton.width/2.0, recognizer.view.center.y);
                    }else{
                        stopPoint = CGPointMake(self.spButton.width/2.0, recognizer.view.center.y);
                    }
                }else{
                    //左下
                    if (recognizer.view.center.x  >= SCREEN_HEIGHT - recognizer.view.center.y) {
                         stopPoint = CGPointMake(self.spButton.width/2.0, recognizer.view.center.y);
                    }else{
                        stopPoint = CGPointMake(self.spButton.width/2.0, recognizer.view.center.y);
                        //                        stopPoint = CGPointMake(recognizer.view.center.x, SCREEN_HEIGHT - self.spButton.width/2.0);
                    }
                }
            }else{
                if (recognizer.view.center.y <= SCREEN_HEIGHT/2.0) {
                    //右上
                    if (SCREEN_WIDTH - recognizer.view.center.x  >= recognizer.view.center.y) {
                        stopPoint = CGPointMake(SCREEN_WIDTH - self.spButton.width/2.0, recognizer.view.center.y);
                    }else{
                        stopPoint = CGPointMake(SCREEN_WIDTH - self.spButton.width/2.0, recognizer.view.center.y);
                    }
                }else{
                    //右下
                    if (SCREEN_WIDTH - recognizer.view.center.x  >= SCREEN_HEIGHT - recognizer.view.center.y) {
                         stopPoint = CGPointMake(SCREEN_WIDTH - self.spButton.width/2.0,recognizer.view.center.y);
                    }else{
                        stopPoint = CGPointMake(SCREEN_WIDTH - self.spButton.width/2.0,recognizer.view.center.y);
                    }
                }
            }
            
            //如果按钮超出屏幕边缘
            if (stopPoint.y + self.spButton.width+40>= SCREEN_HEIGHT) {
                stopPoint = CGPointMake(stopPoint.x, SCREEN_HEIGHT - self.spButton.width/2.0-49);
                NSLog(@"超出屏幕下方了！！"); //这里注意iphoneX的适配。。X的SCREEN高度算法有变化。
            }
            if (stopPoint.x - self.spButton.width/2.0 <= 0) {
                stopPoint = CGPointMake(self.spButton.width/2.0, stopPoint.y);
            }
            if (stopPoint.x + self.spButton.width/2.0 >= SCREEN_WIDTH) {
                stopPoint = CGPointMake(SCREEN_WIDTH - self.spButton.width/2.0, stopPoint.y);
            }
            if (stopPoint.y - self.spButton.width/2.0 <= 0) {
                stopPoint = CGPointMake(stopPoint.x, self.spButton.width/2.0);
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                recognizer.view.center = stopPoint;
            }];
        }
            break;
            
        default:
            break;
    }
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}
- (void)btnClick {
//    [JumpUtil pushHZXueya:self userMessage:@""];
}
- (void)getData {
    GetStoreInfoByHxCmd *cmd = [[GetStoreInfoByHxCmd alloc]init];
    cmd.hxLoginAccount = _hxAccount;//云信账号
    WS(weakSelf);
    [[HttpNetwork getInstance] request:cmd success:^(BaseRespond *respond) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if([respond.data[@"result"] isKindOfClass:[NSDictionary class]]){
        //接受接单
       // [self setupTitleWithString:respond.data[@"result"][@"storeName"]];
            NSDictionary *dict = respond.data[@"result"];
            [ConfigUtil saveString:[respond.data[@"result"][@"relationType"] stringValue] withKey:RELATIONTYPE];
            if ([ConfigUtil intWithtegerKey:RELATIONTYPE] == 0) {
                self.bgView.hidden = YES;
            }else{
                self.bgView.hidden = NO;
            }
            if ([dict[@"storeId"] isKindOfClass:[NSNull class]]) {
            }else{
                [ConfigUtil saveString:[[respond.data[@"result"] objectForKey:@"storeId"] stringValue] withKey:STOREID];
            }
            if ([dict[@"phoneNum"] isKindOfClass:[NSNull class]]) {
                
            }else{
                [ConfigUtil saveString:dict[@"phoneNum"] withKey:PHONENUM];
            }

            if ([dict[@"empId"] isKindOfClass:[NSNull class]]) {
            }else{
                [ConfigUtil saveString:[respond.data[@"result"][@"empId"] stringValue] withKey:EMID];
            }
            [ConfigUtil saveString:_hxAccount withKey:LASTCHARTACCOUNT];//保存聊天人信息
            [ConfigUtil saveString:respond.data[@"result"][@"storeName"] withKey:LASTCHARTYDNAME];//药店名称
        }else{
            self.bgView.hidden = YES;
        }
    } failed:^(BaseRespond *respond, NSString *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.tabBarController.tabBar.hidden = YES;
        [self getData];
//    if (_isShowChufang) {
//        <#statements#>
//    }
    if (_isshowBtn == YES) {
        self.inputView.hidden = NO;
        self.spButton.hidden = NO;
        [self setupNextWithString:@""];
    }
}
- (void)onNext{
    WS(weakSelf);
    NIMSession *session = [NIMSession session:[ConfigUtil stringWithKey:LASTCHARTACCOUNT] type:NIMSessionTypeP2P];
    NIMMessage *message = [[NIMMessage alloc] init];
    message.text = @"医生在开处方单";
    // 错误反馈对象
    NSError *error = nil;
    // 发送消息
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:&error];
    [NSGCDThread dispatchAfterInMailThread:^{
        [JumpUtil pushhuanzheMessage:weakSelf];
    } Delay:200];
   
}
#pragma mark - NIMSystemNotificationManagerProcol    监控对方是否输入
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification
{
    if (!notification.sendToOnlineUsersOnly) {
        return;
    }
    NSData *data = [[notification content] dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        if ([dict jsonInteger:@"id"] == (1) && self.session.sessionType == NIMSessionTypeP2P && [notification.sender isEqualToString:self.session.sessionId])
        {
            self.title = @"正在输入...";
            [_titleTimer startTimer:5
                           delegate:self
                            repeats:NO];
        }
    }

}

- (void)onTimerFired:(TimerHolder *)holderf
{
    self.title = [self sessionTitle];
}

- (NSString *)sessionTitle{
    if ([self.session.sessionId isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
        return  @"我的电脑";
    }
    return [super sessionTitle];
}

#pragma mark - NIMInputActionDelegate     监控自己是否输入

- (void)onTextChanged:(id)sender
{
    [_notificaionSender sendTypingState:self.session];
    
}

#pragma mark - 已读
- (id<NIMSessionConfig>)sessionConfig
{
    if (_sessionConfig == nil) {
        _sessionConfig = [[SessionConfig alloc] init];
        _sessionConfig.session = self.session;
    }
    return _sessionConfig;
}
- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages{
    for (NIMMessage *message in messages) {
        NIMSession *session = message.session;
        if (![session isEqual:self.session] || !messages.count)
        {
            return;
        }
         //[self checkChufangTip:message];
        
    }
    [self uiAddMessages:messages];
}
- (void)checkChufangTip:(NIMMessage*)message{
    NIMCustomObject *object = message.messageObject;
    NSLog(@"lll%@",object);
    if ([object isKindOfClass:[NIMCustomObject class]] && [object.attachment isKindOfClass:[YLTCustomMessageAttachment class]]){
        YLTCustomMessageAttachment *attachment =(YLTCustomMessageAttachment*) object.attachment;
        if (attachment.type==chufangMessageTypeHZXX) {
            HuanZheWithMessageDBStruce *model = [[HuanZheWithMessageDBStruce alloc]initWithDictionary:attachment.messageDict];
            model.HXAcountId = message.from;
            [model saveToDB];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 实时语音
- (void)onTapMediaItemAudioChat:(NIMMediaItem *)item
{
    if ([self checkRTSCondition]) {
        //由于音视频聊天里头有音频和视频聊天界面的切换，直接用present的话页面过渡会不太自然，这里还是用push，然后做出present的效果
        NTESAudioChatViewController *vc = [[NTESAudioChatViewController alloc] initWithCallee:self.session.sessionId];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.25;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromTop;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:vc animated:NO];
    }
}

#pragma mark - 视频聊天
- (void)onTapMediaItemVideoChat:(NIMMediaItem *)item
{
    if ([self checkRTSCondition]) {
        //由于音视频聊天里头有音频和视频聊天界面的切换，直接用present的话页面过渡会不太自然，这里还是用push，然后做出present的效果
        NTESVideoChatViewController *vc = [[NTESVideoChatViewController alloc] initWithCallee:self.session.sessionId];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.25;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromTop;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:vc animated:NO];
        [ConfigUtil saveInt:0 withKey:DiAGNOSETYPE];
    }
}

- (BOOL)checkRTSCondition
{
    BOOL result = YES;
//    if (![[Reachability reachabilityForInternetConnection] isReachable])
//    {
//        [self.view makeToast:@"请检查网络" duration:2.0 position:CSToastPositionCenter];
//        result = NO;
//    }
    NSString *currentAccount = [[NIMSDK sharedSDK].loginManager currentAccount];
    if (self.session.sessionType == NIMSessionTypeP2P && [currentAccount isEqualToString:self.session.sessionId])
    {
        [MBProgressHUD showError:@"不能和自己通话哦" toView:self.view];
        result = NO;
    }
    if (self.session.sessionType == NIMSessionTypeTeam)
    {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
        NSInteger memberNumber = team.memberNumber;
        if (memberNumber < 2)
        {
            [MBProgressHUD showError:@"无法发起，群人数少于2人" toView:self.view];
            result = NO;
        }
    }
    return result;
}
- (BOOL)onTapCell:(NIMKitEvent *)event{
    BOOL handled = [super onTapCell:event];
    NSString *eventName = event.eventName;
    if ([eventName isEqualToString:NIMKitEventNameTapContent])
    {
        NIMMessage *message = event.messageModel.message;
        NSDictionary *actions = [self cellActions];
        NSString *value = actions[@(message.messageType)];
        if (value) {
            SEL selector = NSSelectorFromString(value);
            if (selector && [self respondsToSelector:selector]) {
                SuppressPerformSelectorLeakWarning([self performSelector:selector withObject:message]);
                handled = YES;
            }
        }
    }
    if (!handled) {
        NSAssert(0, @"invalid event");
    }
    return handled;
}
- (NSDictionary *)cellActions
{
    static NSDictionary *actions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        actions = @{@(NIMMessageTypeImage) :    @"showImage:",
                    @(NIMMessageTypeVideo) :    @"showVideo:",
                    @(NIMMessageTypeLocation) : @"showLocation:",
                    @(NIMMessageTypeFile)  :    @"showFile:",
                    @(NIMMessageTypeCustom):    @"showCustom:"};
    });
    return actions;
}
#pragma mark - Cell Actions
- (void)showImage:(NIMMessage *)message
{
    NIMImageObject *object = message.messageObject;
    NTESGalleryItem *item = [[NTESGalleryItem alloc] init];
    item.thumbPath      = [object thumbPath];
    item.imageURL       = [object url];
    item.name           = [object displayName];
    item.itemId         = [message messageId];
    item.size           = [object size];
    
    NIMSession *session = [self isMemberOfClass:[SessionViewController class]]? self.session : nil;
    
    NTESGalleryViewController *vc = [[NTESGalleryViewController alloc] initWithItem:item session:session];
    [self.navigationController pushViewController:vc animated:YES];
    if(![[NSFileManager defaultManager] fileExistsAtPath:object.thumbPath]){
        //如果缩略图下跪了，点进看大图的时候再去下一把缩略图
        __weak typeof(self) wself = self;
        [[NIMSDK sharedSDK].resourceManager download:object.thumbUrl filepath:object.thumbPath progress:nil completion:^(NSError *error) {
            if (!error) {
                [wself uiUpdateMessage:message];
            }
        }];
    }
}

- (BOOL)needRegisterHideKeyboard
{
    return NO;
}
-(void)viewDidLayoutSubviews{
//    if (self.view.bounds.size.height<(SCREEN_HEIGHT-TITLE_HEIGHT_WITH_BAR)) {
//        //切换到页面时因为统一用一个navigationController在绘制view的时候会去掉navigationController的高度64所以要加上64
//        CGRect frame=[self.view frame];
//        frame.size.height=SCREEN_HEIGHT-TITLE_HEIGHT_WITH_BAR;
//        self.view.frame=frame;
//    }
}

@end
