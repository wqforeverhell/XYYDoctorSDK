//
//  UserStruce.h
//  yaolianti
//
//  Created by zl on 2018/6/11.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "Jastor.h"
#import "DBBase.h"

@interface UserLoginDetailModel : Jastor
@property (nonatomic,nonnull,copy)NSString *token;
@property (nonatomic,assign)NSInteger docterId;
@property (nonatomic,nonnull,copy)NSString *name;
@property (nonatomic,assign)NSInteger authType;
@property (nonatomic,assign)NSInteger doctorType;
@property (nonatomic,assign)NSInteger countDown;
@property (nonatomic,assign) NSInteger review;
@property (nonatomic,assign)NSInteger hospitalId;
@property (nonatomic,nonnull,copy)NSString *hosName;
@property (nonatomic,assign)NSInteger province;
@property (nonatomic,assign)NSInteger state;
@property (nonatomic,nonnull,copy)NSString *hxAccount;
@property (nonatomic,nonnull,copy)NSString *hxPwd;
@end


@interface userAccountModel : Jastor
@property (nonatomic,assign) float withdrawBalance;
@property (nonatomic,assign) float  redWithdrawBalance;
@property (nonatomic,assign) float maxWithdrawBalance;
@property (nonatomic,assign) float minWithdrawBalance;
@property (nonatomic,nonnull,copy) NSString *alipayAccount;
@end
@interface UserDetailModel : DBBase
@property (nonatomic,assign) NSInteger keyId;
@property (nonatomic,nonnull,copy)NSString*name;
@property (nonatomic,nonnull,copy)NSString *headPicUrl;
@property (nonatomic,nonnull,copy)NSString *departMentName;
@property (nonatomic,assign) NSInteger todayNumber;
@property (nonatomic,assign) NSInteger weekNumber;
@property (nonatomic,assign) NSInteger monthNumber;
@property (nonatomic,nonnull,copy) NSString *hosName;
@property (nonatomic,nonnull,copy) NSString *alipayAccount;
@property (nonatomic,nonnull,copy) NSString *phoneNum;
@property (nonatomic,assign) NSInteger hospitalId;
@property (nonatomic,assign) NSInteger departmentId;
@property (nonatomic,nonnull,copy) NSString *address;
@property (nonatomic,assign) NSInteger province;
@property (nonatomic,assign) NSInteger city;
@property (nonatomic,assign) NSInteger district;
@property (nonatomic,nonnull,copy) NSString *expert;
@property (nonatomic,assign) NSInteger state;
@property (nonatomic,nonnull,copy)NSString *doctorDiagnosisFeeRuleUrl;//诊疗规则
@property (nonnull,nonatomic,copy)NSString *doctorOnlineDurationRuleUrl;//
@property (nonnull,nonatomic,copy) NSString *doctorRedPacketRuleUrl;//红包规则
@property (nonnull,nonatomic,copy)NSString *doctorRecipeRate;//接单率
@property (nonnull,nonatomic,copy)NSString *durationTime;//在线时长
@property (nonatomic,nonnull,copy) NSString *refuseReason;
@property (nonatomic,strong) userAccountModel * _Nullable hospDoctorAccount;
+(UserDetailModel * _Nullable )initWithDic:(NSDictionary *_Nullable)dic;
+ (UserDetailModel *__nonnull)contactWithKeyId;
@end



@interface TxRecordModel : Jastor
@property (nonatomic,nonnull,copy)NSString *createTime;
@property (nonatomic,assign) NSInteger withdraw;
@property (nonatomic,assign) NSInteger verifyState;
+ (NSArray *_Nullable)arrayFromData:(NSArray *_Nonnull)data;
@end

@interface WtxRecordModel : Jastor
@property (nonatomic,nonnull,copy)NSString *createTime;
@property (nonatomic,assign) float incomingNum;
@property (nonatomic,assign) NSInteger incomingType;
@property (nonatomic,nonnull,copy) NSString *redPacketType;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) NSInteger equalId;
@property (nonatomic,nonnull,copy) NSString *prescriptionCode;
//@property (nonatomic,assign) NSInteger 
+ (NSArray *_Nullable)arrayFromData:(NSArray *_Nonnull)data;
@end

@interface findHospitalModel : Jastor
@property (nonatomic,assign) NSInteger hospitalId;
@property (nonatomic,nonnull,strong) NSString *hospitalName;
+ (NSArray *_Nullable)arrayFromData:(NSArray *_Nonnull)data;
@end
@interface findDepartmentModel : Jastor
@property (nonatomic,assign) NSInteger departmentId;
@property (nonatomic,nonnull,strong) NSString *departMentName;
+ (NSArray *_Nullable)arrayFromData:(NSArray *_Nonnull)data;
@end

@interface GetDoctorMessageModel : Jastor
@end


@interface getValidateInfoModel :Jastor
@property (nonatomic,nonnull,copy)NSString *idCardNum;
@property (nonatomic,nonnull,copy)NSString *cardFrontUrl;
@property (nonnull,nonatomic,copy)NSString *cardBackUrl;
@property (nonnull,nonatomic,copy)NSString *docterCertificatePicUrl;
@property (nonnull,nonatomic,copy)NSString *certificationPicUrl;
@property (nonnull,nonatomic,copy)NSString *subCertificationPicUrl;
@property (nonnull,nonatomic,copy)NSString *signatureUrl;
@property (nonnull,nonatomic,copy)NSString *refuseReason;
@property (nonatomic,nonnull,copy)NSString *alipayAccount;
@property (nonatomic,assign) NSInteger state;
+(getValidateInfoModel*_Nullable)initWithDict:(NSDictionary*_Nullable)dic;
@end

@interface GetDoctorJZListModel : Jastor
@property (nonatomic,nonnull,copy) NSString *startTime;
@property (nonatomic,nonnull,copy) NSString *createTime;
@property (nonatomic,nonnull,copy) NSString *finishTime;
@property (nonatomic,nonnull,copy)NSString *empName;
@property (nonatomic,assign) NSInteger diagnosticType;
@property (nonatomic,nonnull,copy) NSString *storeName;
@property (nonatomic,nonnull,copy) NSString *employeeName;
@property (nonatomic,nonnull,copy) NSString *patientName;
@property (nonatomic,nonnull,copy) NSString *patientTel;
@property (nonatomic,nonnull,copy) NSString *telPhoneNum;
@property (nonatomic,assign) NSInteger clinicalType;//0图文 1视频
@property (nonatomic,assign) NSInteger  clinicalStatus;//-1 对方取消 0 拒接 1 接诊 2 未响应 3 接诊失败
@property (nonatomic,nonnull,copy) NSString *time;
+ (NSArray *_Nullable)arrayFromData:(NSArray *_Nonnull)data;
@end

@interface GetMyPatientRecordModel : Jastor
@property (nonnull,nonatomic,copy)NSString *createTime;
@property (nonnull,nonatomic,copy)NSString *patientName;
@property (nonnull,nonatomic,copy)NSString *telPhoneNum;
@property (nonnull,nonatomic,copy)NSString *age;
@property (nonatomic,assign)NSInteger sex;
@property (nonnull,nonatomic,copy)NSString *cardId;
@property (nonnull,nonatomic,copy)NSString *address;
@property (nonnull,nonatomic,copy)NSString *diastolicPressure;
@property (nonatomic,nonnull,copy)NSString *systolicPressure;
@property (nonatomic,nonnull,copy)NSString *pressureTime;
+ (NSArray *_Nullable)arrayFromData:(NSArray *_Nonnull)data;
@end
