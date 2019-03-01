//
//  YLTSSessionMsgConverter.m
//  yaolianti
//
//  Created by zl on 2018/7/24.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "YLTSSessionMsgConverter.h"
#import "YLTCustomMessageAttachment.h"

@implementation YLTSSessionMsgConverter
+ (NIMMessage *)msgWithCustomMessage:(YLTCustomMessageAttachment *)attachment {
    NIMMessage *message               = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    return message;
}

@end
