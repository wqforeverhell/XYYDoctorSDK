//
//  YLTAudioXuanfuButton.m
//  yaolianti
//
//  Created by huangliwen on 2018/7/4.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "YLTAudioXuanfuButton.h"
#import "NTESAudioChatViewController.h"
#import "NTESNetCallChatInfo.h"
#import "TimerHolder.h"
#import "NTESNotificationCenter.h"
#import "ImageUtil.h"
#import "XYYSDK.h"
static YLTAudioXuanfuButton* _instance = nil;
@interface YLTAudioXuanfuButton()<TimerHolderDelegate>
@property (nonatomic, strong) TimerHolder *timer;
@end
@implementation YLTAudioXuanfuButton
#pragma mark 单例
+ (instancetype) shareInstance {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
        _instance.contentMode=UIViewContentModeScaleToFill;
        [_instance setBackgroundImage:[ImageUtil getImageByPatch:@"btn_audio_xuanfu_dh"] forState:UIControlStateNormal];
        _instance.titleEdgeInsets=UIEdgeInsetsMake(60, 0, 0, 0);
        [_instance setTitleColor:HexRGB(0x5EE1D1) forState:UIControlStateNormal];
        _instance.alpha=0;
    }) ;
    return _instance ;
}
+(id) allocWithZone:(struct _NSZone *)zone
{
    return [YLTAudioXuanfuButton shareInstance] ;
}
-(id) copyWithZone:(struct _NSZone *)zone
{
    return [YLTAudioXuanfuButton shareInstance] ;
}

#pragma mark 外部方法
// 试图出现与消失
- (void)viewShow
{
    _instance.frame=CGRectMake(SCREEN_WIDTH-90, 30, 80, 120);
    _instance.timer = [[TimerHolder alloc] init];
    [_instance.timer startTimer:0.5 delegate:self repeats:YES];
    _instance.alpha=1;
    [_instance addTarget:self action:@selector(dragMoving:withEvent: )forControlEvents: UIControlEventTouchDragInside];
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GotoAudioViewC)];
    tapGesturRecognizer.numberOfTouchesRequired=1;
    tapGesturRecognizer.numberOfTapsRequired = 1;
    [_instance addGestureRecognizer:tapGesturRecognizer];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
//视图消失
- (void)viewHidden
{
    WS(weakSelf);
    [_instance.timer stopTimer];
    _instance.callInfo=nil;
    [UIView animateWithDuration:0.4 animations:^{
        //        _addView.frame = CGRectMake(_addView.x, _addView.y, _addView.width, 0);
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - M80TimerHolderDelegate
- (void)onTimerFired:(TimerHolder *)holder{
    if (!_instance.callInfo.startTime) {
        return ;
    }
    NSTimeInterval time = [NSDate date].timeIntervalSince1970;
    NSTimeInterval duration = time - _instance.callInfo.startTime;
    NSString *string=[NSString stringWithFormat:@"%02d:%02d",(int)duration/60,(int)duration%60];
    if (_instance.alpha>0) {
        [_instance setTitle:string forState:0];
        _instance.titleLabel.text=string;
    }
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
    UINavigationController *nav = [NTESNotificationCenter getCurrentVC].navigationController;
    UIViewController *vc=[[NTESAudioChatViewController alloc] initWithCallInfo:_callInfo];
    
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
