//
//  NTESVideoDataTimeoutChecker.h
//  NIM
//
//  Created by chris on 2017/5/8.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "XYYChatSDK.h"

@protocol NTESVideoDataTimeoutProtocol <NSObject>

- (void)onUserVideoDataTimeout:(NSString *)user;

@end

@interface NTESVideoDataTimeoutChecker : NSObject

@property (nonatomic,weak) id<NTESVideoDataTimeoutProtocol> delegate;

@end
