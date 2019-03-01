//
//  YLTCustomMessageAttachment.h
//  yaolianti
//
//  Created by zl on 2018/7/24.
//  Copyright © 2018年 hlw. All rights reserved.
//
#import "NIMKit.h"
typedef NS_ENUM(NSInteger,YLTChufangMessageType){
    ChufangMessageTypeSQKF   = 1, //申请开方
    ChufangMessageTypeJDCG   = 2, //医生接单成功
    ChufangMessageTypeJJJD   = 3, //拒绝接单
    ChufangMessageTypeKDCG   = 4, //开单成功
    ChufangMessageTypeJSWZ   = 5, //结束问诊
    ChufangMessageTypeYDJSWZ = 6  ,//药店端结束问诊
    chufangMessageTypeHZXX = 7 , //患者信息
    chufangMessageTypeYDCD = 8  , // 药店端催单
    chufangMessageTypeQXJS = 9,//药店强行结束
    chufangMessageTypeXTGB = 10//系统关闭单子
};

#import <Foundation/Foundation.h>
#import "NTESCustomAttachmentDefines.h"
typedef void (^MessageBlock)(NSDictionary*dic);
@interface YLTCustomMessageAttachment : NSObject<NIMCustomAttachment,NTESCustomAttachmentInfo>
@property(nonatomic,assign)YLTChufangMessageType type;
@property (nonatomic,strong) NSDictionary* messageDict;
@property (nonatomic,copy) NSString *messageText;
@end
