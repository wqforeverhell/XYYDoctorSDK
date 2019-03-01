//
//  HuanzheStruce.m
//  yaolianti
//
//  Created by zl on 2018/7/4.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "HuanzheStruce.h"

@implementation YaopinSearchListModel
+(NSArray*)arrayFromData:(NSArray *)data
{
    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray* array = [NSMutableArray array];
        for (NSDictionary* dict in data) {
            [array addObject:[[YaopinSearchListModel alloc] initWithDictionary:dict]];
        }
        return array;
    }
    return [NSArray array];
}
@end


@implementation YaopinMoBanDetailModel

@end

@implementation YaopinMoBanModel

+ (Class)prescriptTemplateDetailRes_class {
    return [YaopinSearchListModel class];
}

+(NSArray*)arrayFromData:(NSArray *)data
{
    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray* array = [NSMutableArray array];
        for (NSDictionary* dict in data) {
            [array addObject:[[YaopinMoBanModel alloc] initWithDictionary:dict]];
        }
        return array;
    }
    return [NSArray array];
}

@end

@implementation DoctorWithListDetailModel
+(NSArray*)arrayFromData:(NSArray *)data
{
    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray* array = [NSMutableArray array];
        for (NSDictionary* dict in data) {
            [array addObject:[[DoctorWithListDetailModel alloc] initWithDictionary:dict]];
        }
        return array;
    }
    return [NSArray array];
}
@end

@implementation DiagnoselistModel
+(NSArray*)arrayFromData:(NSArray *)data
{
    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray* array = [NSMutableArray array];
        for (NSDictionary* dict in data) {
            [array addObject:[[DiagnoselistModel alloc] initWithDictionary:dict]];
        }
        return array;
    }
    return [NSArray array];
}
@end

@implementation PatientionInfoModel

@end
@implementation NewsModel
+(NSArray*)arrayFromData:(NSArray *)data
{
    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray* array = [NSMutableArray array];
        for (NSDictionary* dict in data) {
            [array addObject:[[NewsModel alloc] initWithDictionary:dict]];
        }
        return array;
    }
    return [NSArray array];
}
@end
