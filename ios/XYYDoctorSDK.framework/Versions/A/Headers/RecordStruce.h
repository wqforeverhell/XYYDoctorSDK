//
//  RecordStruce.h
//  yaolianti
//
//  Created by zl on 2018/7/4.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "Jastor.h"


@interface PatientInfoMdel : Jastor
@property (nonatomic,nonnull,copy)NSString *patientName;
@property (nonatomic,nonnull,copy)NSString *telPhoneNum;
@end

@interface PatientInfoDetailMdel : Jastor
@property (nonatomic,nonnull,copy)NSString *commonName;
@property (nonatomic,assign)NSInteger number;
@property (nonatomic,nonnull,copy)NSString *directions;
@property (nonatomic,nonnull,copy)NSString *useFunction;
@property (nonatomic,nonnull,copy)NSString *singleDosage;
@property (nonatomic,nonnull,copy)NSString *extraTotal;
@property (nonatomic,nonnull,copy)NSString *packingRule;
@property (nonatomic,nonnull,copy)NSString *unitName;
@property (nonatomic,nonnull,copy)NSString *goodsExtra;
@property (nonatomic,assign)NSInteger directionsTime;
@property (nonatomic,nonnull,copy)NSString *packageUnitName;
+ (NSArray *_Nullable)arrayFromData:(NSArray *_Nonnull)data;
@end

@interface ChufangRecordModel : Jastor
@property (nonatomic,nonnull,copy)NSString *storeName;
@property (nonatomic,nonnull,copy)NSString *code;
@property (nonatomic,nonnull,copy)NSString *mainSuit;//主诉
@property (nonatomic,nonnull,copy)NSString *primaryDiagnosis;//初步诊断
@property (nonatomic,nonnull,copy)NSString *diagnosisIdea;//诊疗意见
@property (nonatomic,nonnull,copy)NSString *goodsNumber;
@property (nonatomic,nonnull,copy)NSString *diagnosisFee;
@property (nonatomic,nonnull,copy)NSString *createTime;
@property (nonatomic,assign) NSInteger isTakeDrug;
@property (nonatomic,assign) NSInteger checkStatus;
@property (nonatomic,strong)PatientInfoMdel * _Nullable storePatientInfo;
@property (nonatomic, strong) NSArray<PatientInfoDetailMdel*> * _Nullable detailList;
+ (Class _Nullable )detailList_class;
+ (NSArray *_Nullable)arrayFromData:(NSArray *_Nonnull)data;
@end

