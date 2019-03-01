//
//  TimerHolder.m
//  CloudXinDemo
//
//  Created by mango on 16/8/26.
//  Copyright © 2016年 mango. All rights reserved.
//

#import "TimerHolder.h"

@interface TimerHolder ()

{
    NSTimer *_timer;
    BOOL    _repeats;
}

- (void)onTimer: (NSTimer *)timer;

@end


@implementation TimerHolder

- (void)dealloc
{
    [self stopTimer];
}

- (void)startTimer: (NSTimeInterval)seconds
          delegate: (id<TimerHolderDelegate>)delegate
           repeats: (BOOL)repeats
{
    _timerDelegate = delegate;
    _repeats = repeats;
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:seconds
                                              target:self
                                            selector:@selector(onTimer:)
                                            userInfo:nil
                                             repeats:repeats];
}

- (void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
    _timerDelegate = nil;
}

- (void)onTimer: (NSTimer *)timer
{
    if (!_repeats)
    {
        _timer = nil;
    }
    if (_timerDelegate && [_timerDelegate respondsToSelector:@selector(onTimerFired:)])
    {
        [_timerDelegate onTimerFired:self];
    }
}



@end
