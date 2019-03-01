//
//  BaseCommand
//
//  Created by hlw on 14-10-19.
//  Copyright (c) 2014年 CXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBBase.h"
#import <UIKit/UIKit.h>

#pragma mark - 消息基础类
@interface BaseCommand : DBBase
@property(nonatomic,nonnull,copy) NSString*sign; //签名
//@property(nonatomic,assign)NSInteger timespan;
@property(nonatomic,nonnull,copy) NSString* addr; // 本地使用 拼接url用的
@property(nonatomic,nonnull,copy)NSString*token;
@property(nonatomic,nonnull,copy)NSString *deviceToken;
//@property(nonatomic,assign)NSInteger deviceType;
@property(nonatomic,nonnull,copy)NSString*longitude;//经度
@property(nonatomic,nonnull,copy)NSString*latitude;//纬度
@property(nonatomic,nonnull,copy) Class respondType;

- (NSString*_Nullable) toJsonString;
- (NSData*_Nullable) toJsonData;
- (NSDictionary*_Nullable) toDicData;
- (NSDictionary*_Nullable) toDicDataNoAction;
@end



