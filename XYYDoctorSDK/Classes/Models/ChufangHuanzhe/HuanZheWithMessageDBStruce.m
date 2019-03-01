//
//  HuanZheWithMessageDBStruce.m
//  yaolianti
//
//  Created by zl on 2018/7/30.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "HuanZheWithMessageDBStruce.h"
#import "XYYSDK.h"
@implementation HuanZheWithMessageDBStruce
+(HuanZheWithMessageDBStruce * _Nullable)initWithDic:(NSDictionary *)dic hxAcount:(NSString *)hxAcount{
    HuanZheWithMessageDBStruce*user=[[HuanZheWithMessageDBStruce alloc] initWithDictionary:dic];
    user.HXAcountId = hxAcount;
    [user saveToDB];
    return user;
}
+ (HuanZheWithMessageDBStruce *__nonnull)getPatienInfoWithHXAcountId:(NSString *__nonnull)HXAcountId{
    HuanZheWithMessageDBStruce* contact = [HuanZheWithMessageDBStruce searchSingleWithWhere:[NSString stringWithFormat:@" HXAcountId='%@'  ", HXAcountId] orderBy:nil];
    return contact;
    
}
+ (NSString*)getTableName
{
     return @"HuanzheDBStruce";
}
+ (NSString*)getPrimaryKey
{
    return @"HXAcountId";
}
- (BOOL)saveToDB 
{
    if (IS_EMPTY(self.HXAcountId)) {
        return NO;
    }
    if(![HuanZheWithMessageDBStruce getPatienInfoWithHXAcountId:self.HXAcountId]){
        return [super saveToDB];
    }else{
        NSString* where = [NSString stringWithFormat:@" HXAcountId='%@' ", self.HXAcountId];
        return [HuanZheWithMessageDBStruce updateToDB:self where:where];
}}

- (BOOL)deleteToDB
{
    if (IS_EMPTY(self.HXAcountId)) {
        return NO;
    }else{
        NSString *where = [NSString stringWithFormat:@" HXAcountId='%@' ", self.HXAcountId];
        return [HuanZheWithMessageDBStruce  deleteWithWhere:where];
    }
}

@end
