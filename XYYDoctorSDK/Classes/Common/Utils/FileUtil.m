//
//  FileUtil.m
//  xinyaomeng
//
//  Created by 黄黎雯 on 2017/6/8.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import "FileUtil.h"
#import "ImageUtil.h"
#import <MobileCoreServices/MobileCoreServices.h>
#define TEMP_DIR @"tmp/"
@implementation FileUtil
//获取本地存储目录 指定目录
+ (NSString*)getLocalPath:(NSString*)pathName {
    return [FileUtil getLocalPath:pathName ForCache:YES];
}

//获取本地存储目录 指定目录
+ (NSString*)getLocalPath:(NSString*)pathName ForCache:(BOOL)forCache {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(forCache?NSCachesDirectory:NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:pathName];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    return path;
}

//获取本地存储文件名 指定目录和文件名
+ (NSString*)getLocalFilename:(NSString*)name Path:(NSString*)path {
    return [[FileUtil getLocalPath:path] stringByAppendingPathComponent:name];
}

+ (NSString*)getThumb:(NSString*)pathName{
    NSString*filename=[pathName lastPathComponent];
    NSString*newName=[NSString stringWithFormat:@"%@m_%@",[pathName stringByReplacingOccurrencesOfString:filename withString:@""],filename];
    return newName;
}

//保存数据到指定文件
+ (NSString*)saveData:(NSData *)data Dir:(NSString *)dir Filename:(NSString *)filename {
    NSString* realDir = [NSString stringWithFormat:@"%@/%@", dir, [filename stringByDeletingLastPathComponent]];
    NSString* realName = [filename lastPathComponent];
    
    NSString *filePath = [FileUtil getLocalPath:realDir];
    
    NSString *absFilePath = [filePath stringByAppendingPathComponent:realName];
    [self saveData:data Path:absFilePath];
    return absFilePath;
}

//保存数据到指定文件
+ (BOOL)saveData:(NSData *)data Path:(NSString*)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL res = [fileManager createFileAtPath:path contents:data attributes:nil];
    return res;
}

// 保存为临时文件
+ (NSString*) saveTempImage:(UIImage*) image {
    NSTimeInterval sec = [NSDate date].timeIntervalSince1970;
    
    NSData* data = [ImageUtil ZIPImageUpload:image];
     //   NSData* data = UIImageJPEGRepresentation(image, 1.0f);
    
    NSString* path = [FileUtil getLocalPath:TEMP_DIR ForCache:YES];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%.3f.jpg", sec]];
    NSLog(@"------path%@",path);
    if ([FileUtil saveData:data Path:path]) {
        return path;
    } else {
        return nil;
    }
}

+ (NSString*) saveImage:(UIImage *)image path:(NSString *)file {
    if ([FileUtil saveData:UIImageJPEGRepresentation(image, 1.0f) Path:file]) {
        return file;
    } else {
        return nil;
    }
}

+ (NSString *)saveImage:(UIImage *)image dir:(NSString *)dir {
    NSTimeInterval sec = [NSDate date].timeIntervalSince1970;
    NSData* data = UIImageJPEGRepresentation(image, 1.0f);
    
    NSString* path = [FileUtil getLocalPath:dir ForCache:NO];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%.0f.jpg", sec]];
    if ([FileUtil saveData:data Path:path]) {
        return path;
    } else {
        return nil;
    }
}

//删除指定文件
+ (BOOL)deleteFile:(NSString*)filename Dir:(NSString*)dir {
    return [self deleteFilename:[FileUtil getLocalFilename:filename Path:dir]];
}

//删除指定文件
+ (BOOL)deleteFilename:(NSString*)filename {
    NSError* error = nil;
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filename error:&error];
    if(error != nil) {
        return NO;
    }
    return YES;
}

// 删除
+ (void) cleanTmp {
    NSString* path = [FileUtil getLocalPath:TEMP_DIR ForCache:YES];
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        [FileUtil deleteFilename:filename];
    }
}

+ (BOOL)fileExists:(NSString *)filepath {
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filepath];
}

//单个文件的大小
+ (long long)fileSizeAtPath:(NSString*)filePath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少Bit
+ (long long)folderSizeAtPath:(NSString*)folderPath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

+(void)readyDatabase:(NSString*)dbName patch:(NSString*)patch{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;
    BOOL success;
    
    NSString* localDBPath = [FileUtil getDBDataPath];
    
    success = [fileManager fileExistsAtPath:localDBPath];
    if(!success) {
        
        // 1. 在main bundle中找到特定bundle
        NSString *sampleBundlePath =[FileUtil getSDKResourcesPath];
        // 2. 载入bundle，即创建bundle对象
        NSBundle *sampleBundle = [NSBundle bundleWithPath:sampleBundlePath];
        // 3. 从bundle中获取资源路径
        NSString *defaultDBPath = [sampleBundle pathForResource:[NSString stringWithFormat:@"%@", dbName] ofType:@"db"];
        
        success = [fileManager fileExistsAtPath:defaultDBPath];
        if(!success) {
            NSLog(@"no extis");
        }
        success = [fileManager copyItemAtPath:defaultDBPath toPath:localDBPath error:&error];
        if(!success) {
            NSLog(@"error : %@", [error description]);
        }
    }
}
//获取数据路径
+(NSString*)getDBDataPath{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* document = [paths objectAtIndex:0];
    NSString* localDBPath = [document stringByAppendingString:@"/db/yaolianti.db"];
    NSString* path = [document stringByAppendingPathComponent:@"db"];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    return localDBPath;
}
//获取sdk资源包路径路径
//+(NSString*)getSDKResourcesPath{
//    return [[NSBundle mainBundle] pathForResource:@"Frameworks/XYYDoctorSDK.framework/XYYDoctorSDK.bundle" ofType:nil];
//
//}
//重新打包需要的资源路径
+(NSString*)getSDKResourcesPath{
    return [[NSBundle mainBundle] pathForResource:@"/XYYDoctorSDK.bundle" ofType:nil];
}
+ (NSString *)mimeTypeForFileAtPath:(NSString *)path
{
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
        return nil;
    }
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        return @"application/octet-stream";
    }
    return CFBridgingRelease(MIMEType);
}
@end
