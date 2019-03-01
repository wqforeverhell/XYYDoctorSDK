//
//  MessageTimestampDBStruce.m
//  yaolianti
//
//  Created by zl on 2018/7/27.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "MessageTimestampDBStruce.h"
#import "XYYSDK.h"
@implementation MessageTimestampDBStruce
+ (MessageTimestampDBStruce *__nonnull)contactWithDocId:(NSString *)docId{
    MessageTimestampDBStruce* contact = [MessageTimestampDBStruce searchSingleWithWhere:[NSString stringWithFormat:@" doctorId='%@'  ", docId] orderBy:nil];
    return contact;
}
+ (MessageTimestampDBStruce *__nonnull)contactWithDocId:(NSString *)docId  isAlert:(int)isAlert
{
    MessageTimestampDBStruce* contact = [MessageTimestampDBStruce searchSingleWithWhere:[NSString stringWithFormat:@" doctorId='%@' and isAlert = %d ", docId,isAlert] orderBy:nil];
    return contact;

}
+ (NSArray *__nonnull)contactWithDocIsAlert:(int)isAlert{
    NSArray* contact = [MessageTimestampDBStruce searchWithWhere:[NSString stringWithFormat:@" isAlert = %d ",isAlert]];
    return contact;
}
+(NSArray*__nonnull)contactWithDocIsEnd:(int)isEnd {
    NSArray* contact = [MessageTimestampDBStruce searchWithWhere:[NSString stringWithFormat:@" isEnd = %d ",isEnd]];
    return contact;
}

+ (NSString *)getTableName {
    return @"DoctorDBStruce";
}

+ (NSString *)getPrimaryKey {
    return @"doctorId";
}

- (BOOL)saveToDB {
    if (IS_EMPTY(self.doctorId)) {
        return NO;
    }
    
    if(![MessageTimestampDBStruce contactWithDocId:self.doctorId]){
        return [super saveToDB];
    }else{
        NSString* where = [NSString stringWithFormat:@" doctorId='%@' ", self.doctorId];
        return [MessageTimestampDBStruce updateToDB:self where:where];
    }
}

@end
