//
//  UserStruce.m
//  yaolianti
//
//  Created by zl on 2018/6/11.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "UserStruce.h"
#import "ConfigUtil.h"
@implementation UserLoginDetailModel
@end
@implementation UserDetailModel
+(UserDetailModel * _Nullable )initWithDic:(NSDictionary *_Nullable)dic {
    UserDetailModel *model = [[UserDetailModel alloc]initWithDictionary:dic];
    model.keyId = [dic[@"id"] integerValue];
    [model saveToDB];
    return model;
}
+ (UserDetailModel*)contactWithKeyId
{
    UserDetailModel *model = [UserDetailModel searchSingleWithWhere:[NSString stringWithFormat:@" keyId='%@' ",[ConfigUtil getUserId]] orderBy:nil];
    return model;
}
+ (NSString *)getTableName {
    return @"UserInfo";
}

+ (NSString *)getPrimaryKey {
    return @"keyId";
}

- (BOOL)saveToDB {
    if (self.keyId==0) {
        return NO;
    }
    
    if(![UserDetailModel contactWithKeyId]){
        return [super saveToDB];
    }else{
        NSString* where = [NSString stringWithFormat:@" keyId='%ld'", self.keyId];
        return [UserDetailModel updateToDB:self where:where];
    }
}


@end
@implementation userAccountModel
@end
@implementation TxRecordModel
+(NSArray*)arrayFromData:(NSArray *)data
{
    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray* array = [NSMutableArray array];
        for (NSDictionary* dict in data) {
            [array addObject:[[TxRecordModel alloc] initWithDictionary:dict]];
        }
        return array;
    }
    return [NSArray array];
}

@end

@implementation WtxRecordModel
+(NSArray*)arrayFromData:(NSArray *)data
{
    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray* array = [NSMutableArray array];
        for (NSDictionary* dict in data) {
            [array addObject:[[WtxRecordModel alloc] initWithDictionary:dict]];
        }
        return array;
    }
    return [NSArray array];
}
@end


@implementation findHospitalModel
+(NSArray*)arrayFromData:(NSArray *)data
{
    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray* array = [NSMutableArray array];
        for (NSDictionary* dict in data) {
            [array addObject:[[findHospitalModel alloc] initWithDictionary:dict]];
        }
        return array;
    }
    return [NSArray array];
}
@end


@implementation findDepartmentModel
+(NSArray*)arrayFromData:(NSArray *)data
{
    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray* array = [NSMutableArray array];
        for (NSDictionary* dict in data) {
            [array addObject:[[findDepartmentModel alloc] initWithDictionary:dict]];
        }
        return array;
    }
    return [NSArray array];
}
@end

@implementation getValidateInfoModel
+(getValidateInfoModel*)initWithDict:(NSDictionary *)dic
{
    getValidateInfoModel *model = [[getValidateInfoModel alloc]initWithDictionary:dic];
    return model;
}
@end

@implementation GetDoctorJZListModel
+(NSArray*)arrayFromData:(NSArray *)data
{
    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray* array = [NSMutableArray array];
        for (NSDictionary* dict in data) {
            [array addObject:[[GetDoctorJZListModel alloc] initWithDictionary:dict]];
        }
        return array;
    }
    return [NSArray array];
}
@end

@implementation GetMyPatientRecordModel
+(NSArray*)arrayFromData:(NSArray *)data
{
    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray* array = [NSMutableArray array];
        for (NSDictionary* dict in data) {
            [array addObject:[[GetMyPatientRecordModel alloc] initWithDictionary:dict]];
        }
        return array;
    }
    return [NSArray array];
}
@end
