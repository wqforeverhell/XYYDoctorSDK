//
//  YaojishiRefuseStruce.h
//  yaolianti
//
//  Created by qxg on 2018/12/15.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "Jastor.h"

@interface RefuseReasongroupDetailselectModel : Jastor
@property (nonatomic,nonnull,copy) NSString *refuseReason;
+ (NSArray *_Nullable)arrayFromData:(NSArray *_Nonnull)data;
@end

@interface RefuseReasongroupselectModel : Jastor
@property (nonatomic,assign) NSInteger diseaseId;
@property (nonatomic,nonnull,copy) NSString *diseaseName;
@property (nonatomic,strong) NSArray<RefuseReasongroupDetailselectModel*> *refuseReasonList;
+ (NSArray *_Nullable)arrayFromData:(NSArray *_Nonnull)data;
@end


@interface DoctorprescriptiontraceModel : Jastor
@property (nonatomic,nonnull,copy) NSString *operateNodeDescription;//内容
@property (nonatomic,nonnull,copy) NSString *operator;//操作人
@property (nonatomic,nonnull,copy) NSString *remark;//备注
@property (nonatomic,nonnull,copy) NSString *operateContent;
@property (nonatomic,assign)long long  initTime;
+ (NSArray *_Nullable)arrayFromData:(NSArray *_Nonnull)data;
@end
