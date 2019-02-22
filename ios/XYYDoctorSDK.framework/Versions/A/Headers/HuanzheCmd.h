//
//  HuanzheCmd.h
//  yaolianti
//
//  Created by zl on 2018/6/12.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "BaseCommand.h"
//医生从接诊中变为待接诊
@interface GetDoctordoctorRefuseCmd : BaseCommand
@property(nonatomic,nonnull,copy)NSString *hxLoginAccount;//云信新账号
@end

// 医生从待接诊变为接诊中
@interface DoctorSponsoteCmd : BaseCommand
@property (nonatomic,nonnull,copy) NSString *hxLoginAccount;
@end

//接单变为休息
@interface DoctorWorkToRestCmd : BaseCommand
@end

//拒绝接诊
@interface GetDoctordoctorCloseCmd : BaseCommand
@property(nonatomic,nonnull,copy)NSString *hxLoginAccount;
@end
//休息变为接单
@interface DoctorRestToWorkCmd : BaseCommand
@end
//超时连接
@interface DoctorTimeoutCmd : BaseCommand
@property (nonatomic,nonnull,copy) NSString *hxLoginAccount;
@end


//查询药品列表
@interface GetYaoPinDetailListCmd : BaseCommand
@property (nonatomic,nonnull,copy) NSString *searchKey;
@property (nonatomic,nonnull,copy) NSString * storeId ;
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,assign) NSInteger pageSize;
@end

//查询选择项
@interface GetListCmd : BaseCommand
@end

//云信账号解析信息
@interface GetStoreInfoByHxCmd : BaseCommand
@property (nonatomic,nonnull,copy) NSString *hxLoginAccount;
@end
//提交处方
@interface SubmitChuFangCmd : BaseCommand
@property (nonatomic,nonnull,copy) NSString *yxAccount;
@property (nonatomic,nonnull,copy) NSString *storeId;
@property (nonatomic,nonnull,copy) NSString *patientName;
@property (nonatomic,nonnull,copy) NSString *telPhoneNum;
@property (nonatomic,nonnull,copy) NSString *age;
@property (nonatomic,nonnull,copy) NSString *sex;//性别 0 女 1 男
@property (nonatomic,nonnull,copy) NSString *allergyRecord;//过敏史
@property (nonatomic,nonnull,copy) NSString *relationType;//接诊方式 0 药店 1 病人
@property (nonatomic,nonnull,copy) NSDictionary *hospPrescriptionInfo;
@property (nonatomic,nonnull,copy) NSArray *detailList;
@property (nonatomic,assign) int  diagnoseType;// 问诊方式 0 图文 1 视频
@property (nonatomic,nonnull,copy) NSString * employeeId;
@property (nonatomic,nonnull,copy) NSString *cardId;
@end

//提交处方预览
@interface submitPrescriptFreeMarkeCmd :BaseCommand
@property (nonatomic,nonnull,copy) NSString *hospitalId;
@property (nonatomic,nonnull,copy) NSString *doctorName;
@property (nonatomic,nonnull,copy) NSString *patientName;
@property (nonatomic,nonnull,copy) NSString *primaryDiagnosis;
@property (nonatomic,nonnull,copy) NSString *sex;
@property(nonatomic,nonnull,copy)NSString *age;
@property (nonatomic,nonnull,copy) NSString *cardId;
@property (nonatomic,nonnull,copy) NSString *telPhoneNum;
@property (nonatomic,assign) NSInteger loginType;
@property (nonatomic,nonnull,copy) NSArray *list;
@end
//药品模板
@interface MoBanCmd : BaseCommand
@property (nonatomic,assign) NSInteger prescriptTemplateType;
@property (nonatomic,nonnull,copy) NSString *searchKey;
@property (nonatomic,nonnull,copy) NSString *storeId;
@end

//刷新获取连接
@interface doctorRefreshCmd : BaseCommand

@end
//患者信息
@interface GetPatientInfoCmd : BaseCommand
@property (nonatomic,assign) NSInteger relationType;
@property (nonatomic,nonnull,copy) NSString *hxLoginAccount;
@property (nonatomic,nonnull,copy) NSString *storeId;
@property (nonatomic,nonnull,copy) NSString *telPhoneNum;
@property (nonatomic,nonnull,copy) NSString *patientName;
@end
//诊断记录查询
@interface DiagnoseListCmd : BaseCommand
@property (nonatomic,nonnull,copy) NSString *searchKey;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger pageNum;
@end
//主诉查询
@interface SymptomCmd : BaseCommand
//@property (nonatomic,nonnull,copy) NSString *searchKey;
//@property (nonatomic,assign) NSInteger pageSize;
//@property (nonatomic,assign) NSInteger pageNum;
@end
//新增个人模板
@interface HospDoctorPrescriptTemplateInsertCmd : BaseCommand
@property (nonatomic,nonnull,copy)NSString *templateName;
@property (nonatomic,nonnull,copy)NSString *templateType;
@property (nonatomic,nonnull,copy)NSArray *hospDoctorPrescriptTemplateDetail;
@end
//查询模板
@interface HospDoctorPrescriptTemplateListCmd : BaseCommand
@property (nonatomic,nonnull,copy)NSString *searchKey;
@property (nonatomic,nonnull,copy)NSString *prescriptTemplateType;
@end

//删除模板
@interface HospDoctorPrescriptTemplateDeleteCmd : BaseCommand
@property (nonatomic,assign)NSInteger equalId;//模板ID
@end
//修改模板
@interface HospDoctorPrescriptTemplateUpdateCmd : BaseCommand
@property (nonatomic,assign) NSInteger equalId;
@property (nonatomic,nonnull,copy)NSString *templateName;
@property (nonatomic,nonnull,copy)NSString *templateType;
@property (nonatomic,nonnull,copy)NSArray *hospDoctorPrescriptTemplateDetail;
@end
//接受视频
@interface AcceptVedioCmd :BaseCommand
@property (nonnull,nonatomic,copy)NSString *hxLoginAccount;
@end

//处方单列表
@interface PharmacistPrescriptionListCmd : BaseCommand
@property (nonnull,nonatomic,copy)NSString *patientName;
@property (nonnull,nonatomic,copy)NSString *code;
@property (nonnull,nonatomic,copy)NSString *startDate;
@property (nonnull,nonatomic,copy)NSString *endDate;
@property (nonnull,nonatomic,copy)NSString *pageType;
@end
//处方单审核
@interface PharmacistPrescriptionCheckCmd : BaseCommand
@property (nonnull,nonatomic,copy)NSString *code;
@property (nonnull,nonatomic,copy)NSString *checkStatus;//审核类型 0 拒绝 1 通过
@property (nonnull,nonatomic,copy)NSString *refuseReson;
@end
