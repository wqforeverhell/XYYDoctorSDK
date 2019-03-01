//
//  HttpNetwork.m
//  DiaoDiao
//
//  Created by wangzeng on 14-10-19.
//  Copyright (c) 2014年 CXZ. All rights reserved.
//

#import "HttpNetwork.h"
#import "FileUtil.h"
#import "StringUtil.h"
#import "AFAppDotNetAPIClient.h"
#import "XYYDoctorSDKDef.h"
@interface HttpNetwork()

@property(nonatomic, strong) NSMutableDictionary* cmdDict;

@end

static HttpNetwork* g_instance = nil;
@implementation HttpNetwork
+ (HttpNetwork*) getInstance {
    @synchronized(self) {
        if (g_instance == nil) {
            g_instance = [[self alloc] init];
        }
        return g_instance;
    }
}

- (id) init {
    if (self = [super init]) {
        _imageQueue = [[NSOperationQueue alloc] init];
        _cmdDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

// 请求消息-默认接口地址
- (void)request:(BaseCommand*)cmd success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self request:cmd success:success failed:failed apiUrl:API_HOST];
}
// 请求消息-自定义接口地址
- (void)request:(BaseCommand*)cmd success:(SuccessBlock)success failed:(FailedBlock)failed apiUrl:(NSString *)apiUrl {
    NSString* key = [NSString stringWithFormat:@"%@|%@",cmd.addr, [cmd toJsonString]];
//    int now = [[NSDate date] timeIntervalSince1970];
//    if ([_cmdDict objectForKey:key] && (now - [[_cmdDict objectForKey:key] intValue])< 4) {
//        // 3秒之类重复请求过滤
//        if (failed) {
//            failed(nil, @"您操作过快，请稍后再试");
//        }
//        return;
//    }
    NSLog(@"json：%@", key);
//    [_cmdDict setObject:[NSNumber numberWithInt:now] forKey:key];
    AFHTTPSessionManager *session = [AFAppDotNetAPIClient sharedManager];
 //   [session.requestSerializer setValue:cmd.token forHTTPHeaderField:@"token"];
//    [session.requestSerializer setValue:@"iphoneapp" forHTTPHeaderField:@"User-Agent"];

    //设置返回类型
    NSString *url = [NSString stringWithFormat:@"%@%@", apiUrl, cmd.addr];
    id dic=[cmd toDicData];
    //[session ]
    [session POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [[HttpNetwork getInstance].cmdDict removeObjectForKey:key];
        BaseRespond* baserespond = [[cmd.respondType alloc] init];
        NSDictionary*respond = (NSDictionary*)responseObject;
        if (respond!=nil) {
            baserespond = [baserespond initWithJsonData:responseObject];
            if(baserespond.errorNo == 1) {
                if (success) {
                    success(baserespond);
                }
            }else {
                if (baserespond.errorNo == 9 && [HttpNetwork getInstance].checkTokenFailed != nil) {
                    [HttpNetwork getInstance].checkTokenFailed(1,@"");
                }else if (baserespond.errorNo == -10 && [HttpNetwork getInstance].checkTokenFailed != nil){
                    [HttpNetwork getInstance].checkTokenFailed(2,@"");
                }else if (baserespond.errorNo == -999 && [HttpNetwork getInstance].checkTokenFailed != nil){
                    [HttpNetwork getInstance].checkTokenFailed(3,[respond objectForKey:@"content"]);
                } else {
                    if (failed) {
                        failed(baserespond, baserespond.errorInfo);
                    }
                }
            }
        }else{
            if (failed) {
                failed(baserespond, @"服务器出现异常，请稍后尝试");
            }
        }
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",task.response);
        if (failed) {
            NSString* errors = @"服务器异常，请稍后重试";
            failed(nil, errors);
        }
    }];
}
- (void)requestGet:(BaseCommand*)cmd success:(SuccessBlock)success failed:(FailedBlock)failed apiUrl:(NSString *)apiUrl{
    NSString* key = [NSString stringWithFormat:@"%@|%@",cmd.addr, [cmd toJsonString]];
    int now = [[NSDate date] timeIntervalSince1970];
    if ([_cmdDict objectForKey:key] && (now - [[_cmdDict objectForKey:key] intValue])< 4) {
        // 3秒之类重复请求过滤
        if (failed) {
            failed(nil, @"您操作过快,稍后再试");
            
        }
        //        [MBProgressHUD hideAllHUDsForView:nil animated:NO];
        return;
    }
    NSLog(@"json：%@", key);
    [_cmdDict setObject:[NSNumber numberWithInt:now] forKey:key];
    AFHTTPSessionManager *session = [AFAppDotNetAPIClient sharedManager];
    //    [session.requestSerializer setValue:cmd.token forHTTPHeaderField:@"Authorization"];
    //    [session.requestSerializer setValue:@"iphoneapp" forHTTPHeaderField:@"User-Agent"];
    
    //设置返回类型
    NSString *url = [NSString stringWithFormat:@"%@%@", apiUrl, cmd.addr];
    id dic=[cmd toDicData];
    //[session ]
    [session GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // [[HttpNetwork getInstance].cmdDict removeObjectForKey:key];
        BaseRespond* baserespond = [[cmd.respondType alloc] init];
        NSDictionary*respond = (NSDictionary*)responseObject;
        if (respond!=nil) {
            baserespond = [baserespond initWithJsonData:responseObject];
            if(baserespond.errorNo == 1) {
                if (success) {
                    success(baserespond);
                }
            }else {
                if (baserespond.errorNo == 9 && [HttpNetwork getInstance].checkTokenFailed != nil) {
                    [HttpNetwork getInstance].checkTokenFailed(1,@"");
                }else if (baserespond.errorNo == 3 && [HttpNetwork getInstance].checkTokenFailed != nil){
                    [HttpNetwork getInstance].checkTokenFailed(2,@"");
                }else if (baserespond.errorNo == -999 && [HttpNetwork getInstance].checkTokenFailed != nil){
                    [HttpNetwork getInstance].checkTokenFailed(3,[respond objectForKey:@"content"]);
                } else {
                    if (failed) {
                        failed(baserespond, baserespond.errorInfo);
                    }
                }
            }
        }else{
            if (failed) {
                failed(baserespond, @"服务器出现异常，请稍后尝试");
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",task.response);
//        AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        //NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        if (failed) {
            NSString* errors = @"服务器异常，请稍后重试";
//            if (appDelegate.netWorkType==0||appDelegate.netWorkType==1) {
//                errors = @"网络异常，请检查网络连接";
//            }
            
            failed(nil, errors);
        }
    }];
}
- (void)requestGet:(BaseCommand*)cmd success:(SuccessBlock)success failed:(FailedBlock)failed {
    [self requestGet:cmd success:success failed:failed apiUrl:API_HOST];
}
#pragma mark 上传图片接口
- (void)upload:(BaseCommand *)cmd filepath:(NSString *)filepath progressView:(UIProgressView *)indicator success:(SuccessBlock)success failed:(FailedBlock)failed {
    NSArray* paths = [[NSArray alloc] initWithObjects:filepath, nil];
    [self upload:cmd filepaths:paths progressView:indicator success:success failed:failed];
}
- (void)upload:(BaseCommand *)cmd filepaths:(NSArray *)filepaths progressView:(UIProgressView *)indicator success:(SuccessBlock)success failed:(FailedBlock)failed {
    if (filepaths == nil || filepaths.count == 0) {
        if (failed) {
            failed(nil, @"不能上传空文件列表");
        }
        return;
    }
    NSString* key = [NSString stringWithFormat:@"%@|%@",cmd.addr, [cmd toJsonString]];
    NSLog(@"%@", key);
    
    AFHTTPSessionManager *session = [AFAppDotNetAPIClient sharedManager];
    session.requestSerializer.timeoutInterval = 120;//请求超时时间
    
    NSString *url = [NSString stringWithFormat:@"%@%@", API_HOST, cmd.addr];
    NSDictionary*dic=[cmd toDicData];
    
    [session POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        
        // 添加上传的文件
        for (int i=0; i < filepaths.count; i++) {
            NSString*filePath=[filepaths objectAtIndex:i];
            NSData *imageData = [NSData dataWithContentsOfFile: filePath];
            [formData appendPartWithFileData:imageData name:@"attachFile" fileName:[filePath lastPathComponent] mimeType:[FileUtil mimeTypeForFileAtPath:filePath]];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%f",1.0*uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
        indicator.progress=1.0*uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
//        if([[UIDevice currentDevice].systemVersion doubleValue]>=9.0){
//            indicator.observedProgress=uploadProgress;
//        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BaseRespond* baserespond = [[BaseRespond alloc] init];
        NSLog(@"response图片 %@", responseObject);
        NSDictionary*respond = (NSDictionary*)responseObject;
        if (respond!=nil) {
            baserespond = [baserespond initWithJsonData:responseObject];
            if(baserespond.errorNo ==0) {
                if (success) {
                    success(baserespond);
                }
            }else{
                if(failed) {
                    failed(baserespond, baserespond.errorInfo);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failed) {
            NSString* errors = error.localizedFailureReason;
            if(IS_EMPTY(errors)) {
                errors = @"服务器异常";
            }
            failed(nil, errors);
        }
        
    }];
  
}

- (void) download:(NSString *)url file:(NSString *)file progressDelegate:(UIProgressView *)indicator success:(FailedBlock)success failed:(FailedBlock)failed {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    NSURLRequest*request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSessionDownloadTask*downloadTask = [session downloadTaskWithRequest:request progress:^(NSProgress*_Nonnull downloadProgress) {
        
        NSLog(@"%f",1.0* downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        indicator.progress=1.0*downloadProgress.completedUnitCount/downloadProgress.totalUnitCount;
        if([[UIDevice currentDevice].systemVersion doubleValue]>=9.0){
            indicator.observedProgress=downloadProgress;
        }
        
    }destination:^NSURL*_Nonnull(NSURL*_Nonnull targetPath,NSURLResponse*_Nonnull response) {
        
        NSLog(@"%@",targetPath);
        
        NSString*fullpath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)lastObject]stringByAppendingPathComponent:response.suggestedFilename];
        
        if (success) {
            success(nil, fullpath);
        }
        return [NSURL fileURLWithPath:fullpath];
    }completionHandler:^(NSURLResponse*_Nonnull response,NSURL*_Nullable filePath,NSError*_Nullable error) {
        
        NSLog(@"%@",filePath);
        if (failed) {
            NSString* errors = error.localizedFailureReason;
            if(IS_EMPTY(errors)) {
                errors = @"网络异常";
            }
            failed(nil, errors);
        }
        
    }];
    
    //执行下载操作
    
    [downloadTask resume];
    
}

-(NSString*)getSign:(NSString*)parmas
{
//    [parmas removeObjectForKey:@"respondType"];
//    [parmas removeObjectForKey:@"addr"];
    NSString*str=[[NSString alloc] init];
//    NSMutableArray* array=[[NSMutableArray alloc] init];
//    for (NSString* key in parmas) {
//        [array addObject:[NSString stringWithFormat:@"%@=%@",key,[parmas objectForKey:key]]];
//        //char c = pinyinFirstLetter([key characterAtIndex:0]);
//    }
//    NSArray *newArray = [array sortedArrayUsingSelector:@selector(compare:)];
//    newArray=[[newArray reverseObjectEnumerator] allObjects];
//    for (int i=0; i<newArray.count; i++) {
//        str=[str stringByAppendingString:[NSString stringWithFormat:@"%@&",newArray[i]]];
//    }
//    str=[str substringToIndex:[str length] - 1];
    str=[str stringByAppendingString:parmas];
    //str=[str stringByAppendingString:Session_Key];
    NSLog(@"签名前：%@",str);
    str=[StringUtil md5:str];
    return str;
}

//判断网络环境
-(void)getNetWorkStart:(SuccessBlock)failed{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                // 未知网络
                if (failed) {
                    BaseRespond*res=[BaseRespond new];
                    res.errorNo=0;
                    res.data=@"未知网络";
                    failed(res);
                }
                break;
            case AFNetworkReachabilityStatusNotReachable:
                // 没有网络(断网)
                if (failed) {
                    BaseRespond*res=[BaseRespond new];
                    res.errorNo=1;
                    res.data=@"没有网络";
                    failed(res);
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                // 手机自带网络
                if (failed) {
                    BaseRespond*res=[BaseRespond new];
                    res.errorNo=2;
                    res.data=@"手机自带网络";
                    failed(res);
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                // WIFI
                if (failed) {
                    BaseRespond*res=[BaseRespond new];
                    res.errorNo=3;
                    res.data=@"WIFI";
                    failed(res);
                }
                break;
        }
    }];
    // 3.开始监控
    [manager startMonitoring];
}
@end
