//
//  MessageTimestampDBStruce.h
//  yaolianti
//
//  Created by zl on 2018/7/27.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "DBBase.h"

@interface MessageTimestampDBStruce : DBBase
@property(nonatomic,nonnull,copy)NSString *doctorId;
@property(nonatomic,nonnull,copy)NSString *messageId;//消息id
@property (nonatomic,assign) int isAlert;
@property (nonatomic,assign) int isEnd;
+ (MessageTimestampDBStruce *__nonnull)contactWithDocId:(NSString *__nonnull)docId;
+ (MessageTimestampDBStruce *__nonnull)contactWithDocId:(NSString *)docId  isAlert:(int)isAlert;
+ (NSArray *__nonnull)contactWithDocIsAlert:(int)isAlert;
+ (NSArray *__nonnull)contactWithDocIsEnd:(int)isEnd;
- (BOOL)saveToDB;
@end
