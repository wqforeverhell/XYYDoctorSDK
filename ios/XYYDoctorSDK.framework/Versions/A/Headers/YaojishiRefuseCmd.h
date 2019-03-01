//
//  YaojishiRefuseCmd.h
//  yaolianti
//
//  Created by qxg on 2018/12/15.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "BaseCommand.h"
//病种类型
@interface DiseaseTypeselectCmd : BaseCommand
@end
//新增
@interface PharmacistrefuseReasoninsertCmd : BaseCommand
@property (nonatomic,assign) NSInteger diseaseId;
@property (nonatomic,nonnull,copy) NSString *refuseReason;
@end
//查询拒绝理由
@interface PharmacistrefuseReasongroupselectCmd : BaseCommand
@end
//处方流程
@interface DoctorprescriptiontraceCmd : BaseCommand
@property (nonatomic,nonnull,copy) NSString *code;
@end
