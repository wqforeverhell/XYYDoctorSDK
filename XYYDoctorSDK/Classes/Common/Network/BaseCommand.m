//
//  BaseCommand
//
//  Created by hlw on 14-10-19.
//  Copyright (c) 2014年 CXZ. All rights reserved.
//

#import "BaseCommand.h"
#import "BaseRespond.h"
#import "XYYSDK.h"
#import "StringUtil.h"
#import "TimeUtil.h"
#import "ConfigUtil.h"
@implementation BaseCommand

- (id) init {
    if (self = [super init]) {
        self.addr = @"";
        self.respondType = [BaseRespond class];
        self.token = [ConfigUtil stringWithKey:APP_TOKEN];
    }
    return self;
}

- (NSString*) toJsonString {
    NSData* data = [self toJsonData];
    if (data != nil) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSData*) toJsonData {
    NSError* error = nil;
    NSDictionary *dic = [self toDictionary:^BOOL(NSString *propertyName) {
        if ([propertyName isEqualToString:@"addr"] ||
            [propertyName isEqualToString:@"respondType"]||
            [propertyName isEqualToString:@"cgypDic"]) {
            return NO;
        }
        return YES;
    }];
    NSData* result = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&error];
    if (error != nil) {
        return nil;
    }
    return result;
}

- (NSDictionary*) toDicData{
    NSDictionary *dic = [self toDictionary:^BOOL(NSString *propertyName) {
        if ([propertyName isEqualToString:@"addr"] ||
            [propertyName isEqualToString:@"respondType"]||
            [propertyName isEqualToString:@"cgypDic"]) {
            return NO;
        }
        return YES;
    }];
    return dic;
}

- (NSDictionary*) toDicDataNoAction{
    NSDictionary *dic = [self toDictionary:^BOOL(NSString *propertyName) {
        if ([propertyName isEqualToString:@"addr"] ||
            [propertyName isEqualToString:@"respondType"]||
            [propertyName isEqualToString:@"action"]||
            [propertyName isEqualToString:@"token"]) {
            return NO;
        }
        return YES;
    }];
    return dic;
}
@end







