//
//  DBBase.m
//  xinyaomeng
//
//  Created by hlw on 17/6/8.
//  Copyright (c) 2015年 xinyaomeng. All rights reserved.
//

#import "DBBase.h"
#import "NSObject+LKDBHelper.h"
#import "FileUtil.h"
@implementation DBBase
+ (LKDBHelper*) getUsingLKDBHelper {
    static LKDBHelper* helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 拷贝本地数据库到沙盒 //dbcentiwu
        NSFileManager* fileMgr = [NSFileManager defaultManager];
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* document = [paths objectAtIndex:0];
        NSString* dbfile = [document stringByAppendingString:@"/db/yaolianti.db"];
        NSString* path = [document stringByAppendingPathComponent:@"db"];
        NSLog(@"dbfile--%@",dbfile);
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (![fileMgr fileExistsAtPath:dbfile]) {
            NSString *sampleBundlePath = [FileUtil getSDKResourcesPath];
            // 2. 载入bundle，即创建bundle对象
            NSBundle *sampleBundle = [NSBundle bundleWithPath:sampleBundlePath];
            NSString *sampleBundlePatha = [sampleBundle pathForResource:@"YaoliantiBundle.bundle" ofType:nil];
            NSBundle *sampleBundlea = [NSBundle bundleWithPath:sampleBundlePatha];
            // 3. 从bundle中获取资源路径
            NSString *src = [sampleBundlea pathForResource:@"yaolianti" ofType:@"db"];

            
            NSError* error;
            BOOL success = [fileMgr copyItemAtPath:src
                                            toPath:dbfile
                                             error:&error];
            if (!success) {
                NSLog(@"拷贝数据库失败, 错误描述:%@", [error localizedDescription]);
            }
        }
        // 数据库操作对象实例化
        helper = [[LKDBHelper alloc] init];
        [helper setDBName:@"yaolianti"];
    });
    return helper;
}
@end
