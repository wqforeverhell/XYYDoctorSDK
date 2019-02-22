//
//  YLTSSessionMsgConverter.h
//  yaolianti
//
//  Created by zl on 2018/7/24.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NIMKit.h"
@class YLTCustomMessageAttachment;
@interface YLTSSessionMsgConverter : NSObject
+ (NIMMessage *)msgWithCustomMessage:(YLTCustomMessageAttachment *)attachment;
@end
