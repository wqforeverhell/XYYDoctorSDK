//
//  UserCmd.h
//  yaolianti
//
//  Created by zl on 2018/6/11.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "BaseCommand.h"
//登录
@interface AppLoginCmd : BaseCommand
@property(nonatomic,nonnull,copy)NSString *appId;
@property(nonatomic,nonnull,copy)NSString *deviceName;
@property(nonatomic,nonnull,copy)NSString *deviceVersion;
@property(nonatomic,nonnull,copy)NSString *loginAccount;
@property(nonatomic,nonnull,copy)NSString *pwd;
@property(nonatomic,assign) NSInteger deviceType;
@end


//获取医生当前状态
@interface GetDoctorCurrentStatusCmd : BaseCommand

@end

@interface GetUserDetailCmd : BaseCommand

@end
//退出登录
@interface  DoctorWtihExitLoginCmd : BaseCommand

@end
//提现记录
@interface ExtractWithDoctorRecordCmd : BaseCommand
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,assign) NSInteger pageSize;
@end
//未提现记录
@interface IncommingWithDoctorCmd : BaseCommand
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,nonnull,copy) NSString* searchType; // 0 诊疗费 1 红包 null 所有
@end
//最新收入记录
@interface LastincomingCmd  :BaseCommand
@end
//最新提现记录
@interface LastExtractCmd :BaseCommand
@end

@interface HospDoctorAccountManageCmd : BaseCommand
@property (nonatomic,nonnull,copy) NSArray *withdrawApplyList;
@property (nonatomic,nonnull,copy) NSString *withdrawPassword;
@end
//医院列表
@interface  FindHospitalListCmd : BaseCommand
@property (nonatomic,nonnull,copy) NSString *hosName;
@property (nonatomic,nonnull,copy) NSString *provinceCode;
@property (nonatomic,nonnull,copy) NSString *cityCode;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger pageNum;
@end
//科室列表
@interface FindDepartmentCmd : BaseCommand
@property (nonatomic,nonnull,copy) NSString *departMentName;
@end

@interface UserCodeCmd : BaseCommand
@property (nonatomic,nonnull,copy) NSString *phoneNum;
@property (nonatomic,assign) NSInteger pageType;// 1医生APP端   2医生PC端
@property (nonatomic,assign) NSInteger useType;// 0 注册 1 登录
@end
//上传图片
@interface UserUploadIamge : BaseCommand
@property (nonatomic,assign) NSInteger imgType;
@end

//上传电子签名
@interface  uploadSignatureCmd :BaseCommand
@end

//医生注册
@interface DoctorRegisterCmd : BaseCommand
@property (nonatomic,nonnull,copy) NSString* hospitalId;
@property (nonatomic,assign) NSInteger departmentId;
@property (nonatomic,nonnull,copy) NSString *name;
@property (nonatomic,nonnull,copy) NSString *phoneNum;
@property (nonatomic,nonnull,copy) NSString *province;
@property (nonatomic,nonnull,copy) NSString *city;
@property (nonatomic,nonnull,copy) NSString *pwd;
@property (nonatomic,nonnull,copy) NSString *district;
@property (nonatomic,nonnull,copy) NSString *verificationCode;
@property (nonatomic,nonnull,copy) NSString *registerHospInfo;
@property (nonatomic,nonnull,copy) NSString *expert;
@property (nonatomic,nonnull,copy) NSString *position;
@end
//实名认证
@interface saveCertificationInfoCmd : BaseCommand
@property(nonatomic,nonnull,copy)NSString *idCardNum;
@property (nonatomic,nonnull,copy)NSString *cardFrontUrl;
@property (nonatomic,nonnull,copy)NSString *cardBackUrl;
@property (nonatomic,nonnull,copy)NSString *docterCertificatePicUrl;
@property (nonatomic,nonnull,copy)NSString *certificationPicUrl;
@property (nonatomic,nonnull,copy)NSString *subCertificationPicUrl;
@property (nonnull,nonatomic,copy)NSString *signatureUrl;
@property (nonnull,nonatomic,copy)NSString *alipayAccount;
@end
//修改密码
@interface updatePasswordCmd : BaseCommand
@property (nonatomic,nonnull,copy) NSString *oldPwd;
@property (nonatomic,nonnull,copy) NSString *pwd;
@end

//更新用户信息
@interface EditUserInfoCmd : BaseCommand
@property(nonatomic,nonnull,copy)NSString *expert;
@property(nonatomic,nonnull,copy)NSString *alipayAccount;
@property(nonatomic,nonnull,copy)NSString *headPicUrl;
@property(nonatomic,nonnull,copy)NSString *address;
@property(nonatomic,nonnull,copy)NSString *province;
@property(nonatomic,nonnull,copy)NSString *city;
@property(nonatomic,nonnull,copy)NSString *district;
@property (nonatomic,nonnull,copy) NSString *phoneNum;
@property (nonatomic,assign) NSInteger hospitalId;
@property (nonatomic,assign) NSInteger departmentId;
@end

//查看实名认证信息
@interface getValidateInfoCmd : BaseCommand
@end

@interface ForgetPwdCmd : BaseCommand
@property (nonatomic,nonnull,copy)NSString*phoneNum;
@property (nonatomic,nonnull,copy)NSString*pwd;
@property (nonatomic,nonnull,copy)NSString *verificationCode;
@end
//接诊记录查询
@interface GetClinicalRecordListCmd : BaseCommand
@property (nonatomic,nonnull,copy) NSString *startDate;
@property (nonnull,nonatomic,copy) NSString *endDate;
@property (nonatomic,nonnull,copy) NSString *clinicalStatus;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger pageNum;
@end
//问诊记录查询
@interface GetInquiryRecordCmd : BaseCommand
@property (nonatomic,nonnull,copy) NSString *startDate;
@property (nonnull,nonatomic,copy) NSString *endDate;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,nonnull,copy)NSString *patientName;
@property (nonatomic,nonnull,copy) NSString *diagnosticType;
@end
//我的患者
@interface GetMyPatientRecordCmd : BaseCommand
@property (nonatomic,nonnull,copy) NSString *startDate;
@property (nonnull,nonatomic,copy) NSString *endDate;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,nonnull,copy)NSString *phoneNumber;
@property (nonatomic,nonnull,copy)NSString *patientName;
@end
//健康档案
@interface GetPatientHealthCmd : BaseCommand
@property (nonatomic,nonnull,copy) NSString *name;
@property (nonnull,nonatomic,copy) NSString *phoneNum;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger pageNum;
@end
