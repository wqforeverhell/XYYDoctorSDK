//
//  TimerHolder.h
//  CloudXinDemo
//
//  Created by mango on 16/8/26.
//  Copyright © 2016年 mango. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TimerHolder;

@protocol TimerHolderDelegate <NSObject>
- (void)onTimerFired:(TimerHolder *)holder;
@end


@interface TimerHolder : NSObject


@property (nonatomic,weak)  id<TimerHolderDelegate>  timerDelegate;

- (void)startTimer:(NSTimeInterval)seconds
          delegate:(id<TimerHolderDelegate>)delegate
           repeats:(BOOL)repeats;

- (void)stopTimer;

@end
