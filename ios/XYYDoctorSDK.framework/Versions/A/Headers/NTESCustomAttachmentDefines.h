//
//  NTESCustomAttachmentDefines.h
//  NIM
//
//  Created by amao on 7/2/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#ifndef NIM_NTESCustomAttachmentTypes_h
#define NIM_NTESCustomAttachmentTypes_h

@class NIMKitBubbleStyleObject;

typedef NS_ENUM(NSInteger,NTESCustomMessageType){
    CustomMessageTypeJanKenPon  = 1, //剪子石头布
    CustomMessageTypeSnapchat   = 2, //阅后即焚
    CustomMessageTypeChartlet   = 3, //贴图表情
    CustomMessageTypeWhiteboard = 4, //白板会话
    CustomMessageTypeRedPacket  = 5, //红包消息
    CustomMessageTypeRedPacketTip = 6, //红包提示消息
};

//typedef NS_ENUM(NSInteger,NTESCustomMessageType){
//    ChufangMessageTypeSQKF   = 1, //申请开方
//    ChufangMessageTypeJDCG   = 2, //医生接单成功
//    ChufangMessageTypeJSWZ   = 3, //结束问诊
//    ChufangMessageTypeJJJD   = 4  //拒绝接单
//};


#define CMType             @"type"
#define CMData             @"msg"
#define CMValue            @"value"
#define CMFlag             @"flag"
#define CMURL              @"url"
#define CMMD5              @"md5"
#define CMFIRE             @"fired"        //阅后即焚消息是否被焚毁
#define CMCatalog          @"catalog"      //贴图类别
#define CMChartlet         @"chartlet"     //贴图表情ID
//红包
#define CMRedPacketTitle   @"title"        //红包标题
#define CMRedPacketContent @"content"      //红包内容
#define CMRedPacketId      @"redPacketId"  //红包ID
//红包详情
#define CMRedPacketSendId     @"sendPacketId"
#define CMRedPacketOpenId     @"openPacketId"
#define CMRedPacketDone       @"isGetDone"
#endif


@protocol NTESCustomAttachmentInfo <NSObject>

@optional

@end
