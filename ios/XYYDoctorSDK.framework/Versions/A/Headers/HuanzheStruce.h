//
//  HuanzheStruce.h
//  yaolianti
//
//  Created by zl on 2018/7/4.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "Jastor.h"
//药品搜索 与提交处方model
@interface  YaopinSearchListModel: Jastor
@property (nonatomic,nonnull,copy)NSString *factoryName;
@property (nonatomic,nonnull,copy)NSString *commonName;
@property (nonatomic,nonnull,copy)NSString *packingRule;
@property (nonatomic,nonnull,copy)NSString *useFunction;
@property (nonatomic,nonnull,copy)NSString *useLevel;
@property (nonatomic,nonnull,copy)NSString *extractPrice;
@property (nonatomic,assign)NSInteger extraTotal;
@property (nonatomic,assign) BOOL isShowColor;
@property (nonatomic,assign) NSInteger number;
@property (nonatomic,nonnull,copy)NSString *packageUnitName;
@property (nonatomic,nonnull,copy)NSString *directions;
@property (nonatomic,assign)NSInteger directionsTime;
@property (nonatomic,nonnull,copy)NSString *singleDosage;
@property (nonatomic,nonnull,copy)NSString *goodsId;
@property (nonatomic,nonnull,copy)NSString *unitName;
@property (nonatomic,nonnull,copy)NSString *modifyUseDosage;
@property (nonatomic,nonnull,copy)NSString *modifyFrequency;
@property (nonatomic,nonnull,copy)NSString *attendingFunctions;
@property (nonatomic,nonnull,copy)NSString * indication;
@property (nonatomic,nonnull,copy)NSString *uneffect;
@property (nonatomic,nonnull,copy)NSString *medLimit;
@property (nonatomic,nonnull,copy)NSString *announcements;
@property (nonatomic,nonnull,copy)NSString *remark;
@property (nonatomic,assign) int usageLevel;
@property (nonatomic,assign) int useLevelMin;
@property (nonatomic,assign) int useLevelMax;
@property (nonatomic,assign) NSInteger baseStandardDrugInfoId;//标准库药品ID
+ (NSArray *_Nullable)arrayFromData:(NSArray *_Nonnull)data;
@end

//模板详情
@interface YaopinMoBanDetailModel : Jastor
@property (nonatomic,nonnull,copy)NSString *medicalFrequent;
@property (nonatomic,nonnull,copy)NSString *medicalName;
@property (nonatomic,nonnull,copy)NSString *templateName;
@property (nonatomic,nonnull,copy)NSString *singleDoes;
@property (nonatomic,nonnull,copy)NSString *specification;
@property (nonatomic,nonnull,copy)NSString *useMethod;
@property (nonatomic,nonnull,copy)NSString *unit;
@property (nonatomic,nonnull,copy)NSString *remark;
@end

//模板分类
@interface YaopinMoBanModel : Jastor
@property (nonatomic,nonnull,copy)NSString *templateName;
@property (nonatomic,assign) NSInteger templateType;//0 西药 1 中药
@property (nonatomic,strong) NSArray<YaopinSearchListModel *> * _Nonnull prescriptTemplateDetailRes;
@property (nonatomic,strong) NSArray<YaopinSearchListModel *> * _Nonnull hospDoctorPrescriptTemplateDetail;
@property (nonatomic,assign) NSInteger equalId;
+ (NSArray *_Nullable)arrayFromData:(NSArray *_Nonnull)data;
@end
//问诊列表的医生信息
@interface DoctorWithListDetailModel :Jastor
@property(nonatomic,nonnull,copy)NSString *storeName;
@property (nonatomic,nonnull,copy)NSString *storeHxAccount;
@property (nonatomic,assign) int storeId;
@property (nonatomic,assign) int emId;
@property (nonatomic,assign) NSInteger relationType;
@property(nonatomic,nonnull,copy)NSString *headPicUrl;
+ (NSArray *_Nullable)arrayFromData:(NSArray *_Nonnull)data;
@end
//诊断记录查询
@interface DiagnoselistModel : Jastor
@property (nonnull,nonatomic,copy)NSString *sysptomName;
@property (nonnull,nonatomic,copy)NSString *detail;
@property (nonatomic,nonnull,copy) NSString *suitName;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,nonnull,copy) NSString * value;
+ (NSArray *_Nullable)arrayFromData:(NSArray *_Nonnull)data;
@end

//病人信息
@interface PatientionInfoModel : Jastor
@property (nonatomic,nonnull,copy)NSString *allergyRecord;
@property (nonatomic,nonnull,copy)NSString *cardId;
@property (nonatomic,nonnull,copy)NSString *diagnosisIdea;
@property (nonatomic,nonnull,copy)NSString *patientName;
@property (nonatomic,nonnull,copy)NSString *primaryDiagnosis;
@property (nonatomic,nonnull,copy)NSString *medicalRecord;
@property (nonatomic,assign)NSInteger sex;
@property (nonatomic,nonnull,copy)NSString *telPhoneNum;
@property (nonatomic,assign)NSInteger age;
@property (nonatomic,nonnull,copy)NSString *mainSuit;
@property (nonatomic,nonnull,copy)NSString *address;
@end
//新闻
@interface NewsModel : Jastor
@property (nonatomic,nonnull,copy)NSString *title;
@property (nonatomic,nonnull,copy)NSString *content;
@property (nonatomic,nonnull,copy)NSString *newsPictureUrl;
@property (nonatomic,assign)NSInteger equalId;
@property (nonatomic,nonnull,copy)NSString *brief;
+ (NSArray*_Nullable)arrayFromData:(NSArray *_Nonnull)data;
@end
