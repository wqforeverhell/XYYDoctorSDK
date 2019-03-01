//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  MJRefreshLegendHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/4.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "MJRefreshLegendHeader.h"
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"
#import "CircleView.h"

#define FLIP_ANIMATION_DURATION 0.18f
@interface MJRefreshLegendHeader()
@property (nonatomic, weak) CALayer *arrowImage;
@property (nonatomic, weak) CircleView *circleView;
@property (nonatomic, weak) UIActivityIndicatorView *activityView;
@end

@implementation MJRefreshLegendHeader
#pragma mark - 懒加载
//- (UIImageView *)arrowImage
//{
//    if (!_arrowImage) {
//        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MJRefreshSrcName(@"arrow.png")]];
//        [self addSubview:_arrowImage = arrowImage];
//    }
//    return _arrowImage;
//}

- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.bounds = self.arrowImage.bounds;
        [self addSubview:_activityView = activityView];
    }
    
    
    return _activityView;
}

#pragma mark - 初始化
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 箭头
    CGFloat arrowX = (self.stateHidden && self.updatedTimeHidden) ? self.mj_w * 0.5 : (self.mj_w * 0.5 - 100);
//    self.arrowImage.center = CGPointMake(arrowX, self.mj_h * 0.5);
//    
    CircleView *circleView = [[CircleView alloc] initWithFrame:CGRectMake(arrowX, 5, 35, 35)];
    _circleView = circleView;
    [self addSubview:circleView];
    // 指示器
    self.activityView.center = _circleView.center;
    
}

#pragma mark - 公共方法
#pragma mark 设置状态
- (void)setState:(MJRefreshHeaderState)state
{
    if (self.state == state) return;
    _circleView.progress = 1;
    [_circleView setNeedsDisplay];
    // 旧状态
    MJRefreshHeaderState oldState = self.state;
    
    switch (state) {
        case MJRefreshHeaderStateIdle: {
            if (oldState == MJRefreshHeaderStateRefreshing) {
                //self.arrowImage.transform = CGAffineTransformIdentity;
                _circleView.progress = 0;
                [_circleView setNeedsDisplay];
                [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                    [CATransaction begin];
                    [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                    _arrowImage.transform = CATransform3DIdentity;
                    [CATransaction commit];
                } completion:^(BOOL finished) {
                    [CATransaction begin];
                    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
                    _arrowImage.hidden = NO;
                    _arrowImage.transform = CATransform3DIdentity;
                    [CATransaction commit];
                    [self.activityView stopAnimating];
                }];
            } else {
                [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                   // self.arrowImage.transform = CGAffineTransformIdentity;
                    _circleView.progress = 0;
                    [_circleView setNeedsDisplay];
                }];
            }
            break;
        }
            
        case MJRefreshHeaderStatePulling: {
            
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                //self.arrowImage.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
                [_circleView.layer removeAllAnimations];
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
                [CATransaction commit];
            }];
            break;
        }
            
        case MJRefreshHeaderStateRefreshing: {
           // [self.activityView startAnimating];
            
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = YES;
            [CATransaction commit];
            
            CABasicAnimation* rotate =  [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
            rotate.removedOnCompletion = FALSE;
            rotate.fillMode = kCAFillModeForwards;
            
            //Do a series of 5 quarter turns for a total of a 1.25 turns
            //(2PI is a full turn, so pi/2 is a quarter turn)
            [rotate setToValue: [NSNumber numberWithFloat: M_PI / 2]];
            rotate.repeatCount = 1000;
            
            rotate.duration = 0.25;
            //            rotate.beginTime = start;
            rotate.cumulative = TRUE;
            rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            
            [_circleView.layer addAnimation:rotate forKey:@"rotateAnimation"];
            break;
        }
            
        default:
            break;
    }
    
    // super里面有回调，应该在最后面调用
    [super setState:state];
}

@end
