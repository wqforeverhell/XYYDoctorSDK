//
//  CustomSysNotificationSender.h
//  CloudXinDemo
//
//  Created by mango on 16/8/27.
//  Copyright © 2016年 mango. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NIMKit.h"

#define NTESNotifyID        @"id"
#define NTESCustomContent  @"content"

#define NTESCommandTyping  (1)
#define NTESCustom         (2)

@interface CustomSysNotificationSender : NSObject

- (void)sendCustomContent:(NSString *)content toSession:(NIMSession *)session;

- (void)sendTypingState:(NIMSession *)session;

@end
