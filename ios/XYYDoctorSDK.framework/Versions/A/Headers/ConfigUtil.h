//
//  StringUtil.h
//  xinyaomeng
//
//  Created by 黄黎雯 on 2017/6/8.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ConfigUtil : UIView

+ (int) intWithKey:(NSString*) key;

+ (void) saveInt:(int) val withKey:(NSString*) key;

+ (void) saveteger:(NSInteger) val withKey:(NSString*) key;

+ (BOOL) boolWithKey:(NSString*) key;

+ (BOOL) boolWithKey:(NSString*) key default:(BOOL) def;

+ (void) saveBool:(BOOL) val withKey:(NSString*) key;

+ (double)doubleWithKey:(NSString *)key;

+ (void)saveDouble:(double)val withKey:(NSString *)key;

+ (NSString*)stringWithKey:(NSString *)key;

+ (void)saveString:(NSString*)val withKey:(NSString *)key;

+ (BOOL)isalreadyHasObject:(NSString *)key;

+(NSObject *) getUserDefaults:(NSString *) name;

+(void) setUserDefaults:(NSObject *) defaults forKey:(NSString *) key;
//获取用户id
+(NSString*)getUserId;

+ (NSInteger) intWithtegerKey:(NSString*) key;
@end
