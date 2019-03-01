//
//  YLTCustomAttachmentDecoder.m
//  yaolianti-c
//
//  Created by huangliwen on 2018/7/24.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "YLTCustomAttachmentDecoder.h"
#import "YLTCustomMessageAttachment.h"
#import "NSDictionary+Json.h"
@implementation YLTCustomAttachmentDecoder
- (id<NIMCustomAttachment>)decodeAttachment:(NSString *)content
{
    id<NIMCustomAttachment> attachment = nil;
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            NSInteger type     = [dict jsonInteger:@"type"];
            
            switch (type) {
                case ChufangMessageTypeJDCG:
                {
                    attachment = [[YLTCustomMessageAttachment alloc] init];
                    ((YLTCustomMessageAttachment *)attachment).type=ChufangMessageTypeJDCG;
                }
                    break;
                case ChufangMessageTypeJSWZ:
                {
                    attachment = [[YLTCustomMessageAttachment alloc] init];
                    ((YLTCustomMessageAttachment *)attachment).type=ChufangMessageTypeJSWZ;
                }
                    break;
                case ChufangMessageTypeSQKF:
                {
                    attachment = [[YLTCustomMessageAttachment alloc] init];
                    ((YLTCustomMessageAttachment *)attachment).type=ChufangMessageTypeSQKF;
                }
                    break;
                   
                case ChufangMessageTypeYDJSWZ:
                {
                    attachment = [[YLTCustomMessageAttachment alloc] init];
                    ((YLTCustomMessageAttachment *)attachment).type=ChufangMessageTypeYDJSWZ;
                }
                    break;
                case chufangMessageTypeHZXX :
                {
                    NSDictionary*messageDict = [dict jsonDict:@"content"];
                    attachment = [[YLTCustomMessageAttachment alloc] init];
                    ((YLTCustomMessageAttachment *)attachment).type=chufangMessageTypeHZXX;
                    ((YLTCustomMessageAttachment *)attachment).messageDict =  messageDict;
                }
                break;
                  
                case chufangMessageTypeYDCD :
                {
                    attachment = [[YLTCustomMessageAttachment alloc] init];
                    ((YLTCustomMessageAttachment *)attachment).type=chufangMessageTypeYDCD;
                }
                    break;
                case chufangMessageTypeQXJS :
                {
                    attachment = [[YLTCustomMessageAttachment alloc] init];
                    ((YLTCustomMessageAttachment *)attachment).type=chufangMessageTypeQXJS;
                }
                    break;
                case chufangMessageTypeXTGB:{
                    attachment = [[YLTCustomMessageAttachment alloc] init];
                    ((YLTCustomMessageAttachment *)attachment).type=chufangMessageTypeXTGB;
                }
                    break;
                default:
                    break;
            }
            attachment = [self checkAttachment:attachment] ? attachment : nil;
        }
    }
    return attachment;
}


- (BOOL)checkAttachment:(id<NIMCustomAttachment>)attachment{
    BOOL check = NO;
    if ([attachment isKindOfClass:[YLTCustomMessageAttachment class]])
    {
        check = YES;
    }
    return check;
}
@end
