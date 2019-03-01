//
//  RecordCmd.h
//  yaolianti
//
//  Created by zl on 2018/6/12.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "BaseCommand.h"

//获取我的处方记录
@interface GetPrescriptionListByCmd : BaseCommand
@property (nonatomic,assign)NSInteger pageSize;
@property (nonatomic,assign)NSInteger pageNum;
@property (nonatomic,nonnull,copy)NSString *startDate;
@property (nonatomic,nonnull,copy)NSString *endDate;
@property (nonatomic,nonnull,copy)NSString *patientName;
@property (nonatomic,nonnull,copy)NSString *patientTel;
@end

//处方单详情
@interface GetPrescriptionListWithDetailCmd :BaseCommand
@property (nonatomic,nonnull,copy)NSString *code;
@end

@interface PrescriptFreeMarkerCmd : BaseCommand
@property (nonatomic,nonnull,copy) NSString *prescriptionCode;
@end
//历史处方单
@interface GetHistroyPrescriptionListByCmd : BaseCommand
@property (nonatomic,assign)NSInteger pageSize;
@property (nonatomic,assign)NSInteger pageNum;
@property (nonatomic,nonnull,copy)NSString *startDate;
@property (nonatomic,nonnull,copy)NSString *endDate;
@property (nonatomic,nonnull,copy)NSString *patientName;
@property (nonatomic,nonnull,copy)NSString *patientTel;
@end
