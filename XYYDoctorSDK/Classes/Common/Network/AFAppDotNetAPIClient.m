//
//  AFAppDotNetAPIClient.m
//  Drugdisc
//
//  Created by 黄黎雯 on 2017/10/25.
//  Copyright © 2017年 Drugdisc. All rights reserved.
//

#import "AFAppDotNetAPIClient.h"
#import "FileUtil.h"
static AFHTTPSessionManager *manager = nil;
@implementation AFAppDotNetAPIClient
+ (AFHTTPSessionManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 60;//请求超时时间
        //添加多的请求格式
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/json", @"text/javascript",@"text/html",nil];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
          manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        [serializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [manager setSecurityPolicy:[self customSecurityPolicy]];//证书验证
    });
    return manager;
}
+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    
    // 2. 载入bundle，即创建bundle对象
    NSBundle *sampleBundle = [NSBundle bundleWithPath:[FileUtil getSDKResourcesPath]];
    NSString *cerPath = [sampleBundle pathForResource:@"ylt" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    NSSet *certificateSet  = [[NSSet alloc] initWithObjects:certData, nil];
    [securityPolicy setPinnedCertificates:certificateSet];
    
    return securityPolicy;
}
@end
