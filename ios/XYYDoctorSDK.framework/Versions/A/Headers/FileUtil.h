//
//  FileUtil.h
//  xinyaomeng
//
//  Created by 黄黎雯 on 2017/6/8.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ImageDir @"image/"
@interface FileUtil : NSObject
//获取本地存储目录 指定目录
+ (NSString*)getLocalPath:(NSString*)pathName;

//获取本地存储目录 指定目录
+ (NSString*)getLocalPath:(NSString*)pathName ForCache:(BOOL)forCache;

//获取本地存储文件名 指定目录和文件名
+ (NSString*)getLocalFilename:(NSString*)name Path:(NSString*)path;

//返回图片名称加上m_
+ (NSString*)getThumb:(NSString*)pathName;

//保存数据到指定文件
+ (NSString*)saveData:(NSData *)data Dir:(NSString *)dir Filename:(NSString *)filename;

//保存数据到指定文件
+ (BOOL)saveData:(NSData *)data Path:(NSString*)path;

// 保存为临时文件
+ (NSString*) saveTempImage:(UIImage*) image;

// 保存到指定路径
+ (NSString*) saveImage:(UIImage*) image path:(NSString*) file;

// 保存文件到指定目录
+ (NSString*) saveImage:(UIImage*) image dir:(NSString*) dir;

//删除指定文件
+ (BOOL)deleteFile:(NSString*)filename Dir:(NSString*)dir;

//删除指定文件
+ (BOOL)deleteFilename:(NSString*)filename;

//清理临时文件夹
+ (void)cleanTmp;

// 文件是否存在
+ (BOOL) fileExists:(NSString*) filepath;

//单个文件的大小
+ (long long)fileSizeAtPath:(NSString*)filePath;

//遍历文件夹获得文件夹大小，返回多少Bit
+ (long long)folderSizeAtPath:(NSString*)folderPath;

//读取数据库文件
+(void)readyDatabase:(NSString*)dbName patch:(NSString*)patch;
//获取数据路径
+(NSString*)getDBDataPath;
//获取数据路径
+(NSString*)getSDKResourcesPath;
//获取文件类型
+ (NSString *)mimeTypeForFileAtPath:(NSString *)path;
@end
