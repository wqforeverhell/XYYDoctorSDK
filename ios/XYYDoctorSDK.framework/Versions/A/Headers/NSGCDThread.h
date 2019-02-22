//
//  NSGCDThread.h
//  DoctorClient
//
//  Created by aliang on 14-4-27.
//  Copyright (c) 2014年 cxz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSGCDThread : NSObject
//dispatch_async(queue, block)  异步
+(void)dispatchAsync:(void(^)())block;
+(void)dispatchAsync:(void(^)())block complete:(void(^)())complete;

//dispatch_sync(queue, block) 同步
+(void)dispatchSync:(void(^)())block;
+(void)dispatchSync:(void(^)())block complete:(void(^)())complete;

+(void)dispatchAsyncInMailThread:(void(^)())block;

+(void)dispatchAfterInMailThread:(void(^)())block Delay:(int) delay;

@end
