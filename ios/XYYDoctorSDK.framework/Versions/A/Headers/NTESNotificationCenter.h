//
//  NTESNotificationCenter.h
//  NIM
//
//  Created by Xuhui on 15/3/25.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESService.h"
#import "NIMKit.h"
@class NTESCustomNotificationDB;

extern NSString *NTESCustomNotificationCountChanged;

@interface NTESNotificationCenter : NSObject
@property(nonatomic,assign)UInt64 lastCallID;
+ (instancetype)sharedCenter;
- (void)start;
-(void)showIsJiedan:(NIMMessage *)mess;
- (void)onHangup:(UInt64)callID
              by:(NSString *)user;
-(void)showStoreEndDingDan:(NIMMessage*)mess type:(int)type;

@property (nonatomic,assign) BOOL isclinicaling;
@property (nonatomic,assign) BOOL isForebaground;
@property (nonatomic, readwrite) BOOL socketReady;
@property(nonatomic,assign)BOOL isCanShuaxin;

#pragma mark 获取当前UIViewController
+(UIViewController *)getCurrentVC;
@end
