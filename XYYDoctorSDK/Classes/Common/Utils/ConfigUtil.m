//
//  ConfigUtil.m
//  xinyaomeng
//
//  Created by 黄黎雯 on 2017/6/8.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import "ConfigUtil.h"
#import "XYYSDK.h"
@implementation ConfigUtil

+ (int)intWithKey:(NSString *)key {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:key] intValue];
}

+ (void)saveInt:(int)val withKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d", val] forKey:key];
}
+ (void) saveteger:(NSInteger) val withKey:(NSString*) key{
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%ld", val] forKey:key];
}
+ (BOOL)boolWithKey:(NSString *)key {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:key] boolValue];
}

+ (BOOL)boolWithKey:(NSString *)key default:(BOOL)def {
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (obj) {
        return [obj boolValue];
    }
    return def;
}

+ (void)saveBool:(BOOL)val withKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d", val] forKey:key];
}

+ (double)doubleWithKey:(NSString *)key {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:key] doubleValue];
}

+ (void)saveDouble:(double)val withKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%f", val] forKey:key];
}

+ (NSString*)stringWithKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)saveString:(NSString*)val withKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setValue:val forKey:key];
}

+ (BOOL)isalreadyHasObject:(NSString *)key{
    if([[NSUserDefaults standardUserDefaults] objectForKey:key]){
        return YES;
    }else return NO;
}

+(NSObject *) getUserDefaults:(NSString *) name{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:name];
}

+(void) setUserDefaults:(NSObject *) defaults forKey:(NSString *) key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:defaults forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//获取用户id
+(NSString*)getUserId{
    if ([ConfigUtil stringWithKey:UID]) {
        return [ConfigUtil stringWithKey:UID];
    }
    return @"";
}

+ (NSInteger) intWithtegerKey:(NSString*) key{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:key] integerValue];
}
@end
