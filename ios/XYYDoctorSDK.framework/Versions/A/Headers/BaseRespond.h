//
//  BaseRespond
//
//  Created by hlw on 14-10-19.
//  Copyright (c) 2014年 CXZ. All rights reserved.
//

#ifndef diaodiao_Respond_h
#define diaodiao_Respond_h

#import <Foundation/Foundation.h>
#import "Jastor.h"

#pragma mark - 消息响应基础类
@interface BaseRespond : Jastor

@property(nonatomic, assign) int errorNo;
@property(nonatomic, copy) NSString* errorInfo;
@property(nonatomic, strong) id data;

- (instancetype)initWithJsonData:(NSDictionary*)jsonData;
- (id)initWithDic:(NSData*)jsonData;
- (Class)data_class:(NSNumber*)index;

@end

#endif
