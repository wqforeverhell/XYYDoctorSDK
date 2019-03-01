//
//  HuanZheWithMessageDBStruce.h
//  yaolianti
//
//  Created by zl on 2018/7/30.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "DBBase.h"

@interface HuanZheWithMessageDBStruce : DBBase
@property(nonatomic,nonnull,copy)NSString *HXAcountId;
@property(nonatomic,nonnull,copy)NSString *name;
@property(nonatomic,nonnull,copy)NSString *telPhoneNum;
@property(nonatomic,nonnull,copy)NSString *age;
@property(nonatomic,nonnull,copy)NSString *cardId;
@property(nonatomic,nonnull,copy)NSString *allergyRecord;
@property(nonatomic,nonnull,copy)NSString *mainSuit;
@property(nonatomic,nonnull,copy)NSString *chubuzhenduan;
@property(nonatomic,nonnull,copy)NSString *option;
@property (nonatomic,nonnull,copy)NSString *sex;
+(HuanZheWithMessageDBStruce * _Nullable )initWithDic:(NSDictionary *_Nullable)dic hxAcount:(NSString*)hxAcount;
+ (HuanZheWithMessageDBStruce *__nonnull)getPatienInfoWithHXAcountId:(NSString *__nonnull)HXAcountId;
//- (void)deleteMessage;
- (BOOL)saveToDB;
@end
