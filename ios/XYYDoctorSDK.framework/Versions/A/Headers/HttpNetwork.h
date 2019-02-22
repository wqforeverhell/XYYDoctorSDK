//
//  HttpNetwork.h
//  DiaoDiao
//
//  Created by wangzeng on 14-10-19.
//  Copyright (c) 2014年 CXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCommand.h"
#import "BaseRespond.h"
#import <AFNetworking/AFNetworking.h>
//@import AFNetworking;
@class BaseRespond;
@class BaseCommand;

typedef void (^SuccessBlock)(BaseRespond* respond);
typedef void (^FailedBlock)(BaseRespond* respond, NSString* error);

//网络监测
@interface HttpNetwork : NSObject {
    NSOperationQueue* _imageQueue; //图片请求队列
}

@property(nonatomic, copy) void(^checkTokenFailed)(int type,NSString* content);

+ (HttpNetwork*) getInstance;

// 请求消息-默认接口地址
- (void)request:(BaseCommand*)cmd success:(SuccessBlock)success failed:(FailedBlock)failed;
//get请求
- (void)requestGet:(BaseCommand*)cmd success:(SuccessBlock)success failed:(FailedBlock)failed;
// 请求消息-自定义接口地址
- (void)request:(BaseCommand*)cmd success:(SuccessBlock)success failed:(FailedBlock)failed apiUrl:(NSString *)apiUrl;
// 上传接口
- (void)upload:(BaseCommand *)cmd filepath:(NSString*)filepath progressView:(UIProgressView*)indicator success:(SuccessBlock)success failed:(FailedBlock)failed;

- (void)upload:(BaseCommand *)cmd filepaths:(NSArray *)filepaths progressView:(UIProgressView *)indicator success:(SuccessBlock)success failed:(FailedBlock)failed;

- (void)download:(NSString*)url file:(NSString*)file progressDelegate:(UIProgressView *)indicator success:(FailedBlock)success failed:(FailedBlock)failed;

//判断网络环境
-(void)getNetWorkStart:(SuccessBlock)failed;
@end
