//
//  NTESNotificationCenter.m
//  NIM
//
//  Created by Xuhui on 15/3/25.
//  Copyright (c) 2015年 Netease. All rights reserved.


#import "NTESNotificationCenter.h"
#import "NTESVideoChatViewController.h"
#import "NTESAudioChatViewController.h"
#import "SessionViewController.h"
#import "NSDictionary+Json.h"
#import "NTESCustomNotificationDB.h"
#import "NTESCustomNotificationObject.h"
#import "UIView+Toast.h"
#import "NTESCustomSysNotificationSender.h"
#import <AVFoundation/AVFoundation.h>
#import "NTESSessionUtil.h"
#import "NTESAVNotifier.h"
#import "NTESSessionMsgConverter.h"
#import "YLTAudioXuanfuButton.h"
#import "YLTVideoXuanfuView.h"
#import "HuanzheCmd.h"
#import "YLTCustomMessageAttachment.h"
#import "YLTSSessionMsgConverter.h"
#import "YLTCustomAttachmentDecoder.h"
#import "YLTCustomMessageAttachment.h"
#import "MessageTimestampDBStruce.h"
#import "HuanZheWithMessageDBStruce.h"
#import "HuanzheStruce.h"
#import "YLTAlertUtil.h"
#import "FileUtil.h"
#import "XYYDoctorSDK.h"
#import "StringUtil.h"
NSString *NTESCustomNotificationCountChanged = @"NTESCustomNotificationCountChanged";

@interface NTESNotificationCenter () <NIMSystemNotificationManagerDelegate,NIMNetCallManagerDelegate,
NIMRTSManagerDelegate,NIMChatManagerDelegate,NIMBroadcastManagerDelegate>
@property(nonatomic,assign) BOOL isShowMess;
@property (nonatomic,strong) AVAudioPlayer *player; //接单播放提示音
@property (nonatomic,strong) AVAudioPlayer *cdPlayer;//催单提示音
@property (nonatomic,strong) NTESAVNotifier *notifier;
@property (nonatomic,strong) NSMutableArray *acountArray;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) UILocalNotification *tification;
@end

@implementation NTESNotificationCenter

+ (instancetype)sharedCenter
{
    static NTESNotificationCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NTESNotificationCenter alloc] init];
    });
    return instance;
}

- (void)start
{
    NSLog(@"Notification Center Setup");
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _notifier = [[NTESAVNotifier alloc] init];
        //[self player];
        [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
        [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];
        [[NIMAVChatSDK sharedSDK].rtsManager addDelegate:self];
        [[NIMSDK sharedSDK].chatManager addDelegate:self];
        [[NIMSDK sharedSDK].broadcastManager addDelegate:self];
        _acountArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}
-(AVAudioPlayer *)player
 {
    if (_player==Nil) {
        NSString *BundlePath = [FileUtil getSDKResourcesPath];
        // 2. 载入bundle，即创建bundle对象
        NSBundle *Bundle = [NSBundle bundleWithPath:BundlePath];
        NSString *sampleBundlePath = [Bundle pathForResource:@"YaoliantiBundle.bundle" ofType:nil];
        NSBundle *sampleBundle = [NSBundle bundleWithPath:sampleBundlePath];
            // 3. 从bundle中获取资源路径
        NSString *src = [sampleBundle pathForResource:@"order" ofType:@"mp3"];
        NSLog(@"-====%@",src);
            //2.创建播放器（注意：一个AVAudioPlayer只能播放一个url）
        self.player=[[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:src] error:Nil];
            //3.缓冲
        [self.player prepareToPlay];
    }
   return _player;
}

- (AVAudioPlayer*)cdPlayer{
    if (_cdPlayer==Nil) {
        NSString *BundlePath = [FileUtil getSDKResourcesPath];
        // 2. 载入bundle，即创建bundle对象
        NSBundle *Bundle = [NSBundle bundleWithPath:BundlePath];
        NSString *sampleBundlePath = [Bundle pathForResource:@"YaoliantiBundle.bundle" ofType:nil];
        NSBundle *sampleBundle = [NSBundle bundleWithPath:sampleBundlePath];
        // 3. 从bundle中获取资源路径
        NSString *src = [sampleBundle pathForResource:@"cd" ofType:@"mp3"];
        NSLog(@"-====%@",src);
        self.cdPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:src] error:Nil];
        [self.cdPlayer prepareToPlay];
    }
    return _cdPlayer;
}
- (void)dealloc{
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
    [[NIMAVChatSDK sharedSDK].netCallManager removeDelegate:self];
    [[NIMAVChatSDK sharedSDK].rtsManager removeDelegate:self];
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    [[NIMSDK sharedSDK].broadcastManager removeDelegate:self];
    [self.cdPlayer stop];
    self.cdPlayer = nil;
}

#pragma mark - NIMChatManagerDelegate
- (void)onRecvMessages:(NSArray *)recvMessages
{
     //AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //接收到消息
    NSArray *messages = [self filterMessages:recvMessages];
    if (messages.count)
    {
        static BOOL isPlaying = NO;
        if (isPlaying) {
            return;
        }
        isPlaying = YES;
        //[self playMessageAudioTip];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            isPlaying = NO;
        });
        [self checkMessageAt:messages];
        //处理消息的
        NSMutableArray * tmpArr = [NSMutableArray arrayWithCapacity:0];
        [tmpArr addObjectsFromArray:messages];
        NSArray *arr = [[tmpArr reverseObjectEnumerator] allObjects];
        [self checkChufangTip:arr];
    }
}
- (void)checkChufangTip:(NSArray<NIMMessage *> *)messages
{
    UIViewController *viewC=[NTESNotificationCenter getCurrentVC];
//     AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    for (NIMMessage *message in messages) {
         [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:[NIMSession session:message.from type:NIMSessionTypeP2P]];
            NIMCustomObject *object = message.messageObject;
            NSLog(@"lll%@",object);
            if ([object isKindOfClass:[NIMCustomObject class]] && [object.attachment isKindOfClass:[YLTCustomMessageAttachment class]]){
                YLTCustomMessageAttachment *attachment =(YLTCustomMessageAttachment*) object.attachment;
                if (attachment.type==ChufangMessageTypeSQKF) {
                    //申请开单回调
                    //保存医生发来消息的时间
                    MessageTimestampDBStruce *model=[[MessageTimestampDBStruce alloc] init];
                    NIMMessage *message=messages.firstObject;
                    if (![message.from isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
                        model.doctorId=message.from;
                        model.messageId=message.messageId;
                        //model.isAlert = 0;//添加的
                        [model saveToDB];
                    }
                    //弹出接诊窗 --by hlw
                    
                    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
                       
                        if (![NTESNotificationCenter sharedCenter].isForebaground){
                            [self playMessageAudioTip];
                        }
                        [self showIsJiedan:message];
                        return;
                    }
                }else if (attachment.type == chufangMessageTypeHZXX){
                    HuanZheWithMessageDBStruce *model = [HuanZheWithMessageDBStruce initWithDic:attachment.messageDict hxAcount:message.from];
                    [model saveToDB];
                } else if (attachment.type == ChufangMessageTypeYDJSWZ){
                    [MBProgressHUD showError:@"取消问诊" toView:viewC.view];
                    MessageTimestampDBStruce *modelM = [MessageTimestampDBStruce contactWithDocId:message.from isAlert:1];
                    [modelM saveToDB];
                    //停止音乐的播放
                    [self stopMusicPlay];
                    
                    [self creatAlert:_timer];
                } else if (attachment.type == chufangMessageTypeYDCD) {
                    //催单
                    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
                        if (![NTESNotificationCenter sharedCenter].isclinicaling) {
                            //[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
                            [self.cdPlayer play];
                        }
                   
                    }
                }else if (attachment.type == chufangMessageTypeQXJS) {
                    //药店端强行挂断
                    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
                       [self showStoreEndDingDan:message type:chufangMessageTypeQXJS];
                    }
                    [self stopMusicPlay];
                }else if (attachment.type == chufangMessageTypeXTGB){
                    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
                        [self showStoreEndDingDan:message type:chufangMessageTypeXTGB];
                    }
                   [self stopMusicPlay];
                }
            }
    }
}
- (void)stopMusicPlay {
    [self.player stop];
    self.player = nil;
    [self.cdPlayer stop];
    self.cdPlayer = nil;
}
- (void)playMessageAudioTip
{
    BOOL needPlay = YES;
    if (needPlay) {
        [self.player stop];
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
       // [[AVAudioSession sharedInstance] setActive: YES error: nil];
        [self.player play];
    }
}
//药店强行结束订单
-(void)showStoreEndDingDan:(NIMMessage*)mess type:(int) type {
    NIMCustomObject *object = mess.messageObject;
    if ([object isKindOfClass:[NIMCustomObject class]] && [object.attachment isKindOfClass:[YLTCustomMessageAttachment class]]){
        NSString *tipStr = type == chufangMessageTypeQXJS?@"医生您好,因您长时间未处理，药店已结束本次问诊!":@"医生您好,因您长时间未结束问诊，系统已自动结束本次通话!";
            [YLTAlertUtil presentAlertViewWithTitle:@"" message:tipStr confirmTitle:@"确定" handler:^{
                 [[UIApplication sharedApplication] cancelAllLocalNotifications];
//                MainTabBarController *tabVC = [MainTabBarController instance];
//                UINavigationController *nav = tabVC.selectedViewController;
                UIViewController *vc=[NTESNotificationCenter getCurrentVC];
                [vc.navigationController popToRootViewControllerAnimated:YES];
                [[NIMSDK sharedSDK].conversationManager deleteMessage:mess];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_STORE_END object:nil];
            }];
    }
}
- (void)checkMessageAt:(NSArray<NIMMessage *> *)messages
{
    //一定是同个 session 的消息
    NIMSession *session = [messages.firstObject session];
    if ([self.currentSessionViewController.session isEqual:session])
    {
        //只有在@所属会话页外面才需要标记有人@你
        return;
    }
    
    NSString *me = [[NIMSDK sharedSDK].loginManager currentAccount];
    
    for (NIMMessage *message in messages) {
        if ([message.apnsMemberOption.userIds containsObject:me]) {
            [NTESSessionUtil addRecentSessionMark:session type:NTESRecentSessionMarkTypeAt];
            return;
        }
    }
}
- (NSArray *)filterMessages:(NSArray *)messages
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NIMMessage *message in messages)
    {
        if ([self checkRedPacketTip:message] && ![self canSaveMessageRedPacketTip:message])
        {
            [[NIMSDK  sharedSDK].conversationManager deleteMessage:message];
            [self.currentSessionViewController uiDeleteMessage:message];
            continue;
        }
        [array addObject:message];
    }
    return [NSArray arrayWithArray:array];
}

- (BOOL)checkRedPacketTip:(NIMMessage *)message
{
    return NO;
}

- (BOOL)canSaveMessageRedPacketTip:(NIMMessage *)message
{
    return NO;
}

- (void)onRecvRevokeMessageNotification:(NIMRevokeMessageNotification *)notification
{
    //消息撤回回调
    NIMMessage *tipMessage = [NTESSessionMsgConverter msgWithTip:[NTESSessionUtil tipOnMessageRevoked:notification]];
    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.shouldBeCounted = NO;
    tipMessage.setting = setting;
    tipMessage.timestamp = notification.timestamp;
    
//    MainTabBarController *tabVC = [MainTabBarController instance];
//    UINavigationController *nav = tabVC.selectedViewController;
    
    UIViewController *vcs=[NTESNotificationCenter getCurrentVC];
    for (SessionViewController *vc in vcs.navigationController.viewControllers) {
        if ([vc isKindOfClass:[SessionViewController class]]
            && [vc.session.sessionId isEqualToString:notification.session.sessionId]) {
            NIMMessageModel *model = [vc uiDeleteMessage:notification.message];
            if (model) {
                [vc uiInsertMessages:@[tipMessage]];
            }
            break;
        }
    }
    // saveMessage 方法执行成功后会触发 onRecvMessages: 回调，但是这个回调上来的 NIMMessage 时间为服务器时间，和界面上的时间有一定出入，所以要提前先在界面上插入一个和被删消息的界面时间相符的 Tip, 当触发 onRecvMessages: 回调时，组件判断这条消息已经被插入过了，就会忽略掉。
    [[NIMSDK sharedSDK].conversationManager saveMessage:tipMessage
                                             forSession:notification.session
                                             completion:nil];
}

#pragma mark - NIMSystemNotificationManagerDelegate
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification{
    
    NSString *content = notification.content;
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            switch ([dict jsonInteger:NTESNotifyID]) {
                case NTESCustom:{
                    //SDK并不会存储自定义的系统通知，需要上层结合业务逻辑考虑是否做存储。这里给出一个存储的例子。
                    NTESCustomNotificationObject *object = [[NTESCustomNotificationObject alloc] initWithNotification:notification];
                    //这里只负责存储可离线的自定义通知，推荐上层应用也这么处理，需要持久化的通知都走可离线通知
                    if (!notification.sendToOnlineUsersOnly) {
                        [[NTESCustomNotificationDB sharedInstance] saveNotification:object];
                    }
                    if (notification.setting.shouldBeCounted) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NTESCustomNotificationCountChanged object:nil];
                    }
                    NSString *content  = [dict jsonString:NTESCustomContent];
                    [self makeToast:content];
                }
                    break;
                
                default:
                    break;
            }
        }
    }
}

#pragma mark - NIMNetCallManagerDelegate
- (void)onReceive:(UInt64)callID from:(NSString *)caller type:(NIMNetCallMediaType)type message:(NSString *)extendMessage{
    UIViewController *nav=[NTESNotificationCenter getCurrentVC];
//    MainTabBarController *tabVC = [MainTabBarController instance];
    [nav.view endEditing:YES];
//    UINavigationController *nav = tabVC.selectedViewController;
    self.lastCallID=callID;
    if ([self shouldResponseBusy]){
        [[NIMAVChatSDK sharedSDK].netCallManager control:callID type:NIMNetCallControlTypeBusyLine];
    }
    else {
        
        if ([self shouldFireNotification:caller]) {
            NSString *text = [self textByCaller:caller
                                           type:type];
            [_notifier start:text];
        }

        UIViewController *vc;
        switch (type) {
            case NIMNetCallTypeVideo:{
                vc = [[NTESVideoChatViewController alloc] initWithCaller:caller callId:callID];
            }
                break;
            case NIMNetCallTypeAudio:{
                vc = [[NTESAudioChatViewController alloc] initWithCaller:caller callId:callID];
            }
                break;
            default:
                break;
        }
        if (!vc) {
            return;
        }
        
        // 由于音视频聊天里头有音频和视频聊天界面的切换，直接用present的话页面过渡会不太自然，这里还是用push，然后做出present的效果
        CATransition *transition = [CATransition animation];
        transition.duration = 0.25;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromTop;
        [nav.view.layer addAnimation:transition forKey:nil];
        nav.navigationController.navigationBarHidden = YES;
        if (nav.presentedViewController) {
            // fix bug MMC-1431
            [nav.presentedViewController dismissViewControllerAnimated:NO completion:nil];
        }
        
        if ([[NSString stringWithUTF8String:object_getClassName(vc)] isEqualToString:@"DoctorHomeTableViewController"] ||[[NSString stringWithUTF8String:object_getClassName(vc)] isEqualToString:@"MeHomeController"]) {
            vc.hidesBottomBarWhenPushed = YES;
            [nav.navigationController pushViewController:vc animated:NO];
        }else{
           [nav.navigationController pushViewController:vc animated:NO];
        }
       
    }
}

- (void)onHangup:(UInt64)callID
              by:(NSString *)user
{
    [_notifier stop];
    //[self netJujueOrder];
    [[YLTAudioXuanfuButton shareInstance] viewHidden];
    [[YLTVideoXuanfuView shareInstance] viewHidden];
}

- (void)onRTSRequest:(NSString *)sessionID
                from:(NSString *)caller
            services:(NSUInteger)types
             message:(NSString *)info
{
    if ([self shouldResponseBusy]) {
        [[NIMAVChatSDK sharedSDK].rtsManager responseRTS:sessionID accept:NO option:nil completion:nil];
    }
    else {
        
        if ([self shouldFireNotification:caller]) {
            NSString *text = [self textByCaller:caller];
            [_notifier start:text];
        }
    }
}

- (void)onCallDisconnected:(UInt64)callID
                 withError:(nullable NSError *)error;
{
    [_notifier stop];
    //[self netJujueOrder];
    [[YLTAudioXuanfuButton shareInstance] viewHidden];
    [[YLTVideoXuanfuView shareInstance] viewHidden];
}

- (void)presentModelViewController:(UIViewController *)vc
{
//    MainTabBarController *tab = [MainTabBarController instance];
//    [tab.view endEditing:YES];
//    if (tab.presentedViewController) {
//        __weak MainTabBarController *wtabVC = tab;
//        [tab.presentedViewController dismissViewControllerAnimated:NO completion:^{
//            [wtabVC presentViewController:vc animated:NO completion:nil];
//        }];
//    }else{
//        [tab presentViewController:vc animated:NO completion:nil];
//    }
}

- (void)onRTSTerminate:(NSString *)sessionID
                    by:(NSString *)user
{
    [_notifier stop];
}

- (BOOL)shouldResponseBusy
{
//    MainTabBarController *tabVC = [MainTabBarController instance];
//    UINavigationController *nav = tabVC.selectedViewController;
    return [[NTESNotificationCenter getCurrentVC] isKindOfClass:[NTESNetChatViewController class]];
}

#pragma mark - NIMBroadcastManagerDelegate
- (void)onReceiveBroadcastMessage:(NIMBroadcastMessage *)broadcastMessage
{
    [self makeToast:broadcastMessage.content];
}

#pragma mark - format
- (NSString *)textByCaller:(NSString *)caller type:(NIMNetCallMediaType)type
{
    NSString *action = type == NIMNetCallMediaTypeAudio ? @"音频":@"视频";
    NSString *text = [NSString stringWithFormat:@"你收到了一个%@聊天请求",action];
    NIMKitInfo *info = [[NIMKit sharedKit] infoByUser:caller option:nil];
    if ([info.showName length])
    {
        text = [NSString stringWithFormat:@"%@向你发起了一个%@聊天请求",info.showName,action];
    }
    return text;
}


- (NSString *)textByCaller:(NSString *)caller
{
    NSString *text = @"你收到了一个白板请求";
    NIMKitInfo *info = [[NIMKit sharedKit] infoByUser:caller option:nil];
    if ([info.showName length])
    {
        text = [NSString stringWithFormat:@"%@向你发起了一个白板请求",info.showName];
    }
    return text;
}

- (BOOL)shouldFireNotification:(NSString *)callerId
{
    //退后台后 APP 存活，然后收到通知
    BOOL should = YES;
    
    //消息不提醒
    id<NIMUserManager> userManager = [[NIMSDK sharedSDK] userManager];
    if (![userManager notifyForNewMsg:callerId])
    {
        should = NO;
    }
    
    //当前在正处于免打扰
    id<NIMApnsManager> apnsManager = [[NIMSDK sharedSDK] apnsManager];
    NIMPushNotificationSetting *setting = [apnsManager currentSetting];
    if (setting.noDisturbing)
    {
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
        NSInteger now = components.hour * 60 + components.minute;
        NSInteger start = setting.noDisturbingStartH * 60 + setting.noDisturbingStartM;
        NSInteger end = setting.noDisturbingEndH * 60 + setting.noDisturbingEndM;
        
        //当天区间
        if (end > start && end >= now && now >= start)
        {
            should = NO;
        }
        //隔天区间
        else if(end < start && (now <= end || now >= start))
        {
            should = NO;
        }
    }
    
    return should;
}

#pragma mark - Misc
- (NIMSessionViewController *)currentSessionViewController
{
//    UINavigationController *nav = [MainTabBarController instance].selectedViewController;
    for (UIViewController *vc in [NTESNotificationCenter getCurrentVC].navigationController.viewControllers)
    {
        if ([vc isKindOfClass:[NIMSessionViewController class]])
        {
            return (NIMSessionViewController *)vc;
        }
    }
    return nil;
}

- (void)makeToast:(NSString *)content
{
    [[NTESNotificationCenter getCurrentVC].view makeToast:content duration:2.0 position:CSToastPositionCenter];
}

#pragma mark 弹出接单请求 --by hlw
-(void)showIsJiedan:(NIMMessage *)mess{
//    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    NSLog(@"当前%f,消息%f -=======%d %d",[[NSDate date] timeIntervalSince1970],mess.timestamp,(([[NSDate date] timeIntervalSince1970]-mess.timestamp)<40),[ConfigUtil boolWithKey:ISAPPCLINICALING defaults:NO]);
    NSArray *array = [ConfigUtil getUserDefaults:ACCOUNTaRRAY];
    BOOL isShow ;
    if (array.count) {
        isShow = [array containsObject:mess.from] ? YES :NO;
    }else{
        isShow = NO;
    }
    //BOOL isShow = [array containsObject:mess.from] ? YES :NO;
    NSInteger limt = [ConfigUtil intWithtegerKey:MAXLIMIT];
    NSInteger relation = [ConfigUtil intWithtegerKey:RELATIONINFO];
    BOOL isShowAlert = relation < limt ? YES :NO;
    //更新本地弹出值
    NSInteger countDown = [ConfigUtil intWithtegerKey:COUNTDOWN];
    NIMCustomObject *object = mess.messageObject;
    NSLog(@"lll%@",object);
    if ([object isKindOfClass:[NIMCustomObject class]] && [object.attachment isKindOfClass:[YLTCustomMessageAttachment class]]){
        YLTCustomMessageAttachment *attachment = (YLTCustomMessageAttachment*)object.attachment;
        if (attachment.type == ChufangMessageTypeSQKF &&(([[NSDate date] timeIntervalSince1970]-mess.timestamp)<countDown) && isShowAlert ) {
            MessageTimestampDBStruce *model=[MessageTimestampDBStruce contactWithDocId:mess.from];
            model.isAlert = 1;
            [model saveToDB];
            //申请开单回调
            self.isShowMess=YES;
            [ConfigUtil saveString:mess.from withKey:LASTCHARTACCOUNT];
            WS(weakSelf);
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"请求开处方单" message:@"您收到一条接诊请求，是否接诊" preferredStyle:UIAlertControllerStyleAlert];
            alertController.view.tintColor = RGB(2, 175, 102);
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.timer invalidate];
                [weakSelf.player stop];
                weakSelf.player = nil;
                self.timer = nil;
                [LKDBHelper clearTableData:[MessageTimestampDBStruce class]];//清除消息数据
                [NTESNotificationCenter sharedCenter].isForebaground = NO;
                //点击拒绝
                weakSelf.isShowMess=NO;
                [weakSelf netJujueOrder];
                NIMSession *session = [NIMSession session:mess.from type:NIMSessionTypeP2P];
                YLTCustomMessageAttachment *attacment = [[YLTCustomMessageAttachment alloc] init];
                attacment.type = ChufangMessageTypeJJJD;
                attacment.messageText = @"医生在忙";
                NIMMessage *message = [YLTSSessionMsgConverter msgWithCustomMessage:attacment];
                
                message.text = @"医生在忙";
                [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
            }];
            UIAlertAction *khAction = [UIAlertAction actionWithTitle:@"接诊" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [ConfigUtil saveBool:NO withKey:KAICHUFANG_OVER];
                [self.timer invalidate];
                self.timer = nil;
                [LKDBHelper clearTableData:[MessageTimestampDBStruce class]];//清除消息数据
                [weakSelf.player stop];
                  weakSelf.player = nil;
                //点击接单
                weakSelf.isShowMess=NO;
                [NTESNotificationCenter sharedCenter].isForebaground = NO;
                [weakSelf netJieshouOrder:mess.from];
                //点击接单
                [NTESSessionUtil addRecentSessionMark:[mess session] type:NTESRecentSessionMarkTypeAt];
            }];
            [alertController addAction:okAction];
            [alertController addAction:khAction];
//            UINavigationController *nav = [MainTabBarController instance].selectedViewController;
//            UIViewController *viewC=[nav.viewControllers lastObject];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
            NSTimeInterval  time = fabs ([[NSDate date] timeIntervalSince1970] - mess.timestamp);
            NSLog(@"-======相差的时间戳%f",time);
           self.timer= [NSTimer scheduledTimerWithTimeInterval:countDown-time target:self selector:@selector(creatAlert:) userInfo:alertController repeats:NO];
        }
    }
}
- (void)creatAlert:(NSTimer *)timer{
    NSLog(@"-====消失了");
     UIAlertController *alertController = [timer userInfo];
     [alertController dismissViewControllerAnimated:YES completion:nil];
     alertController = nil;
     [LKDBHelper clearTableData:[MessageTimestampDBStruce class]];
     [self.timer invalidate];
     self.timer = nil;
}

#pragma mark 网络请求 --by hlw
-(void)netJujueOrder{
//    UINavigationController *nav = [MainTabBarController instance].selectedViewController;
    UIViewController *viewC=[NTESNotificationCenter getCurrentVC];
    [MBProgressHUD showMessag:@"" toView:viewC.view];
    GetDoctordoctorCloseCmd *cmd = [[GetDoctordoctorCloseCmd alloc]init];
    cmd.hxLoginAccount = [ConfigUtil stringWithKey:LASTCHARTACCOUNT];
    [[HttpNetwork getInstance] request:cmd success:^(BaseRespond *respond) {
        [MBProgressHUD hideAllHUDsForView:viewC.view animated:NO];
        if ([respond.data[@"errorNo"] integerValue]  == 1 ) {
            //拒绝接单
            NIMSession *session = [NIMSession session:[ConfigUtil stringWithKey:LASTCHARTACCOUNT] type:NIMSessionTypeP2P];
            YLTCustomMessageAttachment *attacment = [[YLTCustomMessageAttachment alloc] init];
            attacment.type = ChufangMessageTypeJSWZ;
            NIMMessage *message = [YLTSSessionMsgConverter msgWithCustomMessage:attacment];
            message.text = @"结束通话";
            [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
        }
    } failed:^(BaseRespond *respond, NSString *error) {
        [MBProgressHUD hideAllHUDsForView:viewC.view animated:NO];
    }];
}

-(void)netJieshouOrder:(NSString *)yxid{
//    UINavigationController *nav = [MainTabBarController instance].selectedViewController;
    UIViewController *viewC=[NTESNotificationCenter getCurrentVC];
    [MBProgressHUD showMessag:@"" toView:viewC.view];
    DoctorSponsoteCmd *cmd = [[DoctorSponsoteCmd alloc]init];
    cmd.hxLoginAccount = yxid;//云信账号
    [self addLocalNotification];
    WS(weakSelf);
    [[HttpNetwork getInstance] request:cmd success:^(BaseRespond *respond) {
         [MBProgressHUD hideAllHUDsForView:viewC.view animated:NO];
        if([respond.data[@"result"] isKindOfClass:[NSDictionary class]]){
            
            //接受接单
            NSDictionary *dict = respond.data[@"result"];
            if ([dict[@"storeId"] isKindOfClass:[NSNull class]]) {
                   //[ConfigUtil saveString:@"" withKey:STOREID];
            }else{
                [ConfigUtil saveString:[[respond.data[@"result"] objectForKey:@"storeId"] stringValue] withKey:STOREID];
            }
            
            if ([dict[@"empId"] isKindOfClass:[NSNull class]]) {
                //[ConfigUtil saveString:@"" withKey:STOREID];
            }else{
                [ConfigUtil saveString:[respond.data[@"result"][@"empId"] stringValue] withKey:EMID];
            }
            if ([StringUtil QX_NSStringIsNULL:dict[@"phoneNum"]]) {
                
            }else{
               [ConfigUtil saveString:dict[@"phoneNum"] withKey:PHONENUM];
            }
            
            [ConfigUtil saveInt:0 withKey:DiAGNOSETYPE];
            [ConfigUtil saveString:[respond.data[@"result"][@"relationType"] stringValue] withKey:RELATIONTYPE];
            //点击接受接单
            NSMutableArray *Array = [[NSMutableArray alloc]initWithCapacity:0];
            [Array addObject:yxid];
            [ConfigUtil setUserDefaults:[Array mutableCopy] forKey:ACCOUNTaRRAY];

//            [_acountArray addObject:yxid];
//            NSArray * array = [_acountArray mutableCopy];
//            [ConfigUtil setUserDefaults:array forKey:ACCOUNTaRRAY];
            [ConfigUtil saveString:yxid withKey:LASTCHARTACCOUNT];//保存聊天人信息
            [ConfigUtil saveString:respond.data[@"result"][@"storeName"] withKey:LASTCHARTYDNAME];//药店名称
            UIViewController *vc=[NTESNotificationCenter getCurrentVC];
                    
                        if ([[ConfigUtil stringWithKey:RELATIONTYPE] isEqualToString:@"0"]) {
                            NIMSession *session = [NIMSession session:yxid type:NIMSessionTypeP2P];
                            YLTCustomMessageAttachment *attacment = [[YLTCustomMessageAttachment alloc] init];
                            attacment.type = ChufangMessageTypeJDCG;
                            attacment.messageText = @"请问您的姓名、电话、性别、年龄、身份证号是多少?";
                            NIMMessage *message = [YLTSSessionMsgConverter msgWithCustomMessage:attacment];
                            
                            message.text = @"请问您的姓名、电话、性别、年龄、身份证号是多少?";
                            [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
                        }else{
                            [weakSelf motionGetPationInfo:viewC.view yxid:yxid];
                        }

                    [self messageClick:vc];
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:NOTICE_JIEDAN_SUCCESS object:@{@"storeBaseInfo":respond.data[@"result"][@"storeName"]} userInfo:nil];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
        }else{
            [MBProgressHUD showError:@"接诊出现异常" toView:viewC.view];
            [weakSelf netJujueOrder];
        }
    } failed:^(BaseRespond *respond, NSString *error) {
         [MBProgressHUD showError:error toView:viewC.view];
    }];
}
- (void)addLocalNotification {
    //定义本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    //通知触发时间，10s之后
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:300.0];
    //设置重复通知间隔 0代表不重复
    notification.repeatInterval = 0;
    //设置时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    //设置标题
    notification.alertTitle = @"鑫医云";
    //通知主体
    notification.alertBody = @"您本次问诊还未结束，请尽快处理";
    //应用程序右上角显示的未读消息数
    notification.applicationIconBadgeNumber = 1;
    //待机界面的滑动动作提示
    //notification.alertAction = @"打开应用";
    //通过点击通知打开应用时的启动图片，这里使用程序启动图片
    notification.alertLaunchImage = @"AppIcon";
    //收到通知时播放的声音，默认消息声音
    //notification.soundName=UILocalNotificationDefaultSoundName;
    notification.soundName=@"tip.caf";//通知声音（需要真机才能听到声音）
    //设置用户信息
    notification.userInfo = @{@"id":@1,@"user":@"XF"};
    self.tification = notification;
   
    //调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}
- (void)kaichufang {
    [[UIApplication sharedApplication] cancelLocalNotification:self.tification];
}
- (void)messageClick:(UIViewController*)vc{
    //消息点击
    //构造会话
    NIMSession *session = [NIMSession session:[ConfigUtil stringWithKey:LASTCHARTACCOUNT] type:NIMSessionTypeP2P];
    SessionViewController *sessionVC = [[SessionViewController alloc] initWithSession:session];
    sessionVC.hxAccount=[ConfigUtil stringWithKey:LASTCHARTACCOUNT];
    sessionVC.strTitle = [ConfigUtil stringWithKey:LASTCHARTYDNAME];
    sessionVC.isShowChufang = YES;
    sessionVC.hidesBottomBarWhenPushed = YES;
    sessionVC.relationType = [[ConfigUtil stringWithKey:RELATIONTYPE] integerValue];
    [vc.navigationController pushViewController:sessionVC animated:YES];
}
//获取湖南病人详情
- (void)motionGetPationInfo:(UIView*)view yxid:(NSString*)yxid{
    GetPatientInfoCmd *cmd = [[GetPatientInfoCmd alloc]init];
    //    cmd.hxLoginAccount = [ConfigUtil stringWithKey:LASTCHARTACCOUNT];
    cmd.telPhoneNum = [ConfigUtil stringWithKey:PHONENUM];
    [MBProgressHUD showMessag:@"" toView:view];
    //WS(weakSelf);
    [[HttpNetwork getInstance] request:cmd success:^(BaseRespond *respond) {
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
        NSArray *ifonArray =respond.data[@"result"];
        if (![ifonArray count]) {
            //[MBProgressHUD showError:@"无上次诊断记录" toView:v];
            return ;
        }
        NSDictionary *dict = ifonArray[0];
        PatientionInfoModel*model = [[PatientionInfoModel alloc]initWithDictionary:dict];
       // NSString *sexStr = [NSString stringWithFormat:<#(nonnull NSString *), ...#>]
        
        NSString *sex;
        if ([StringUtil QX_NSStringIsNULL:model.cardId]) {
            model.cardId = @"无";
        }if ([StringUtil QX_NSStringIsNULL:model.allergyRecord]) {
            model.allergyRecord = @"无";
        }if ([StringUtil QX_NSStringIsNULL:model.address]) {
            model.address = @"无";
        }if (model.sex ==1) {
            sex = @"男";
        }if (model.sex ==0) {
            sex= @"女";
        }if (model.sex == 2) {
            sex = @"未设置";
        }if (model.age==0) {
        }
        NIMSession *session = [NIMSession session:yxid type:NIMSessionTypeP2P];
        YLTCustomMessageAttachment *attacment = [[YLTCustomMessageAttachment alloc] init];
        attacment.type = ChufangMessageTypeJDCG;
        attacment.messageText = [NSString stringWithFormat:@"您好，请问您的基本情况是否如下?\n姓名:%@;\n联系方式:%@;\n年龄:%ld;\n性别:%@;\n身份证号:%@;\n过敏史:%@;\n家庭住址:%@。\n若需修改,请回复我正确消息。",model.patientName,model.telPhoneNum,(long)model.age,sex,model.cardId,model.allergyRecord,model.address];
        NIMMessage *message = [YLTSSessionMsgConverter msgWithCustomMessage:attacment];
        
        message.text = [NSString stringWithFormat:@"您好，请问您的基本情况是否如下?\n姓名:%@;\n联系方式:%@;\n年龄:%ld;\n性别:%@;\n身份证号:%@;\n过敏史:%@;\n家庭住址:%@。\n若需修改,请回复我正确消息。",model.patientName,model.telPhoneNum,(long)model.age,sex,model.cardId,model.allergyRecord,model.address];
        [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
                
    } failed:^(BaseRespond *respond, NSString *error) {
        [MBProgressHUD hideAllHUDsForView:view animated:NO];
        if(!IS_EMPTY(error))
            [MBProgressHUD showError:error toView:view];
    }];
}

+(UIViewController *)getCurrentVC; {
    UIViewController *resultVC;
    resultVC = [NTESNotificationCenter _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [NTESNotificationCenter _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
@end
