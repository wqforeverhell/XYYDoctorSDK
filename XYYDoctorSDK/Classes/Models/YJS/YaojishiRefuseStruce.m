//
//  YaojishiRefuseStruce.m
//  yaolianti
//
//  Created by qxg on 2018/12/15.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "YaojishiRefuseStruce.h"
@implementation RefuseReasongroupDetailselectModel
+(NSArray*)arrayFromData:(NSArray *)data
{
    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray* array = [NSMutableArray array];
        for (NSDictionary* dict in data) {
            [array addObject:[[RefuseReasongroupDetailselectModel alloc] initWithDictionary:dict]];
        }
        return array;
    }
    return [NSArray array];
}
@end
@implementation RefuseReasongroupselectModel
+(NSArray*)arrayFromData:(NSArray *)data
{
    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray* array = [NSMutableArray array];
        for (NSDictionary* dict in data) {
            RefuseReasongroupselectModel *model = [[RefuseReasongroupselectModel alloc]initWithDictionary:dict];
            model.refuseReasonList = [RefuseReasongroupDetailselectModel arrayFromData:dict[@"refuseReasonList"]];
            [array addObject:model];
        }
        return array;
    }
    return [NSArray array];
}
@end

@implementation DoctorprescriptiontraceModel
+(NSArray*)arrayFromData:(NSArray *)data
{
    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray* array = [NSMutableArray array];
        for (NSDictionary* dict in data) {
            [array addObject:[[DoctorprescriptiontraceModel alloc] initWithDictionary:dict]];
        }
        return array;
    }
    return [NSArray array];
}
@end

