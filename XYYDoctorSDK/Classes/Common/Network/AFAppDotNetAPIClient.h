//
//  AFAppDotNetAPIClient.h
//  Drugdisc
//
//  Created by 黄黎雯 on 2017/10/25.
//  Copyright © 2017年 Drugdisc. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
@interface AFAppDotNetAPIClient : AFHTTPSessionManager
+ (AFHTTPSessionManager *)sharedManager;
@end
