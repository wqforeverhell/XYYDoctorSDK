//
//  YLTCustomMessageAttachment.m
//  yaolianti
//
//  Created by zl on 2018/7/24.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "YLTCustomMessageAttachment.h"

@implementation YLTCustomMessageAttachment
- (NSString *)encodeAttachment {
    
    NSDictionary *dict = @{CMType: @(self.type),CMData:self.messageText?self.messageText:@""};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:0
                                                         error:nil];
    
    return [[NSString alloc] initWithData:jsonData
                                 encoding:NSUTF8StringEncoding];
}

@end
