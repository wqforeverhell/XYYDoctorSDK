//
//  RecordStruce.m
//  yaolianti
//
//  Created by zl on 2018/7/4.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "RecordStruce.h"
#import "BaseRespond.h"
#import "XYYSDK.h"
@implementation PatientInfoMdel
@end

@implementation PatientInfoDetailMdel
+ (NSArray *_Nullable)arrayFromData:(NSArray *_Nonnull)data{
    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray* array = [NSMutableArray array];
        for (NSDictionary* dict in data) {
            [array addObject:[[PatientInfoDetailMdel alloc] initWithDictionary:dict]];
        }
        return array;
    }
    return [NSArray array];

}
@end
@implementation ChufangRecordModel
+ (Class)detailList_class {
    return [PatientInfoDetailMdel class];
}

+(NSArray*)arrayFromData:(NSArray *)data
{
    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray* array = [NSMutableArray array];
        for (NSDictionary* dict in data) {
            [array addObject:[[ChufangRecordModel alloc] initWithDictionary:dict]];
        }
        return array;
    }
    return [NSArray array];
}


@end


