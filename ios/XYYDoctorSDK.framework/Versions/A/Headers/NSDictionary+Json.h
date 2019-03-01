//
//  NSDictionary+Json.h
//  CloudXinDemo
//
//  Created by mango on 16/8/26.
//  Copyright © 2016年 mango. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Json)

- (NSString *)jsonString: (NSString *)key;

- (NSDictionary *)jsonDict: (NSString *)key;
- (NSArray *)jsonArray: (NSString *)key;
- (NSArray *)jsonStringArray: (NSString *)key;


- (BOOL)jsonBool: (NSString *)key;
- (NSInteger)jsonInteger: (NSString *)key;
- (long long)jsonLongLong: (NSString *)key;
- (unsigned long long)jsonUnsignedLongLong:(NSString *)key;

- (double)jsonDouble: (NSString *)key;

@end
