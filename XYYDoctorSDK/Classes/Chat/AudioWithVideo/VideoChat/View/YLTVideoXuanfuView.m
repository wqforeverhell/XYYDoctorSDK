//
//  YLTVideoXuanfuView.m
//  yaolianti
//
//  Created by huangliwen on 2018/7/4.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "YLTVideoXuanfuView.h"
#import "NTESNetCallChatInfo.h"
#import "NTESVideoChatViewController.h"
#import "NTESGLView.h"
#import "NTESBundleSetting.h"
#import "NTESNotificationCenter.h"
#import "XYYChatSDK.h"
#define NTESUseGLView
static YLTVideoXuanfuView* _instance = nil;
@interface YLTVideoXuanfuView()<NIMNetCallManagerDelegate>
#if defined (NTESUseGLView)
@property (nonatomic, strong) NTESGLView *remoteGLView;
#endif
@property (nonatomic,assign) BOOL oppositeCloseVideo;
@end
@implementation YLTVideoXuanfuView
#pragma mark 单例
+ (instancetype) shareInstance {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
        [_instance setBackgroundColor:[UIColor blackColor]];
        _instance.contentMode=UIViewContentModeScaleToFill;
        //_instance.alpha=0;
    }) ;
    return _instance ;
}
+(id) allocWithZone:(struct _NSZone *)zone
{
    return [YLTVideoXuanfuView shareInstance] ;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [YLTVideoXuanfuView shareInstance] ;
}
#pragma mark 外部方法
// 试图出现与消失
- (void)viewShow
{
    _instance.frame=CGRectMake(UIScreenWidth-90, 30, 80, 120);
    _instance.alpha=1;
    [_instance addTarget:self action:@selector(dragMoving:withEvent: )forControlEvents: UIControlEventTouchDragInside];
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GotoAudioViewC)];
    tapGesturRecognizer.numberOfTouchesRequired=1;
    tapGesturRecognizer.numberOfTapsRequired = 1;
    [_instance addGestureRecognizer:tapGesturRecognizer];
    //防止应用在后台状态，此时呼入，会走init但是不会走viewDidLoad,此时呼叫方挂断，导致被叫监听不到，界面无法消去的问题。
    id<NIMNetCallManager> manager = [NIMAVChatSDK sharedSDK].netCallManager;
    [manager addDelegate:_instance];
    
    [self initRemoteGLView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
//视图消失
- (void)viewHidden
{
    WEAK_SELF(weakSelf);
    _instance.callInfo=nil;
#if defined (NTESUseGLView)
    [_instance.remoteGLView render:nil width:0 height:0];
    [_instance.remoteGLView removeFromSuperview];
#endif
    [[NIMAVChatSDK sharedSDK].netCallManager removeDelegate:self];
    [UIView animateWithDuration:0.4 animations:^{
        //        _addView.frame = CGRectMake(_addView.x, _addView.y, _addView.width, 0);
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark 按钮事件
//按钮拖动
- (void) dragMoving: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:[UIApplication sharedApplication].keyWindow];
}
-(void)GotoAudioViewC{
    UIViewController *tabVC = [self topViewController];
    [tabVC.view endEditing:YES];
    UINavigationController *nav = tabVC;
    UIViewController *vc=[[NTESVideoChatViewController alloc] initWithCallInfo:_callInfo];
    
    // 由于音视频聊天里头有音频和视频聊天界面的切换，直接用present的话页面过渡会不太自然，这里还是用push，然后做出present的效果
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [nav.view.layer addAnimation:transition forKey:nil];
    nav.navigationBarHidden = YES;
    if (nav.presentedViewController) {
        // fix bug MMC-1431
        [nav.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    [nav pushViewController:vc animated:NO];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (void)initRemoteGLView {
#if defined (NTESUseGLView)
    _remoteGLView = [[NTESGLView alloc] initWithFrame:_instance.bounds];
    _remoteGLView.userInteractionEnabled=NO;
    [_remoteGLView setContentMode:[[NTESBundleSetting sharedConfig] videochatRemoteVideoContentMode]];
    [_remoteGLView setBackgroundColor:[UIColor clearColor]];
    _remoteGLView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_instance addSubview:_remoteGLView];
#endif
}

#if defined(NTESUseGLView)
- (void)onRemoteYUVReady:(NSData *)yuvData
                   width:(NSUInteger)width
                  height:(NSUInteger)height
                    from:(NSString *)user
{
    if (([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) && !self.oppositeCloseVideo) {
        
        if (!_remoteGLView) {
            [self initRemoteGLView];
        }
        [_remoteGLView render:yuvData width:width height:height];
        
    }
}
#else
- (void)onRemoteImageReady:(CGImageRef)image{
    if (self.oppositeCloseVideo) {
        return;
    }
    _instance.contentMode = UIViewContentModeScaleAspectFill;
    [_instance setBackgroundImage:[UIImage imageWithCGImage:image] forState:0];
}
#endif

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
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

