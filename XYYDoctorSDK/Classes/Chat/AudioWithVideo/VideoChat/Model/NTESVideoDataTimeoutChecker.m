//
//  NTESVideoDataTimeoutChecker.m
//  NIM
//
//  Created by chris on 2017/5/8.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESVideoDataTimeoutChecker.h"
#import "TimerHolder.h"
#import <NIMAVChat/NIMAVChat.h>
#import "NIMKit.h"
@interface NTESVideoDataTimeoutChecker()<NIMNetCallManagerDelegate,TimerHolderDelegate>

@property (nonatomic,strong) TimerHolder *timer;

@property (nonatomic,strong) NSMutableSet *users;

@property (nonatomic,strong) NSMutableSet *usersMayTimeout;

@end


@implementation NTESVideoDataTimeoutChecker

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];
        _timer = [[TimerHolder alloc] init];
        [_timer startTimer:2 delegate:self repeats:YES];
        _users = [[NSMutableSet alloc] init];
        _usersMayTimeout = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [[NIMAVChatSDK sharedSDK].netCallManager removeDelegate:self];
}


#pragma mark - NIMNetCallManagerDelegate
- (void)onRemoteYUVReady:(NSData *)yuvData
                   width:(NSUInteger)width
                  height:(NSUInteger)height
                    from:(NSString *)user
{
    [self.usersMayTimeout removeObject:user];
    [self.users addObject:user];
}

#pragma mark - NTESTimerHolderDelegate
- (void)onNTESTimerFired:(TimerHolder *)holder
{
    NSSet *usersTimeOut = [NSSet setWithSet:self.usersMayTimeout];
    if ([self.delegate respondsToSelector:@selector(onUserVideoDataTimeout:)])
    {
        for (NSString *user in usersTimeOut)
        {
            [self.delegate onUserVideoDataTimeout:user];
        }
    }
    self.usersMayTimeout = [NSMutableSet setWithSet:self.users];
    [self.users removeAllObjects];
}

@end
