//
//  ImageUtil.h
//  xinyaomeng
//
//  Created by 黄黎雯 on 2017/6/8.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigUtil.h"
#import "ChoosePhotoViewController.h"
@interface ImageUtil : NSObject
+ (UIImage*) imageWithColor:(UIColor*) color Size:(CGSize) size;
+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(int)gradientType imgSize:(CGSize)imgSize;
// 调整图片方向
+ (UIImage *)fixOrientation:(UIImage *)aImage;

//压缩图片，尺寸默认屏幕尺寸
+ (UIImage*)ZIPUIImage:(UIImage*)image;

+ (UIImage*)ZIPUIImageqita:(UIImage*)image;
+ (UIImage*)ZIPUIImage:(UIImage*)image size:(CGSize)size;

+ (UIImage*)imageWithCenterCrop:(UIImage *)src targetSize:(CGSize)targetSize;
+ (UIImage*)scaleImage:(UIImage*)image toSize:(CGSize) size;

//根据图片名字获取bundle中的图片
+(UIImage*)getImageByPatch:(NSString*)imageName;
+(UIImage*)getImageByPatchAndType:(NSString *)imgName type:(NSString*)imgType;

//对于一个图片进行中间剪裁
+ (UIImage*)imageWithCenterCrop:(UIImage *)src targetSize:(CGSize)targetSize;

// 上传用压缩图片
+(NSData*)ZIPImageUpload:(UIImage*)image;

//获取聊天图片压缩的系数
+ (CGFloat)getChatZipRate:(UIImage*)image;

// 显示头像
+ (void) showHeadImage:(NSString *)head withImageView:(UIImageView*) view;
+ (void) showCodeHeadImage:(NSString *)head withImageView:(UIImageView*) view sex:(int)sex;

//显示图片
+ (void) showPicImage:(NSString *)head withImageView:(UIImageView*) view size:(CGSize)size;
+ (void) showNoHcPicImage:(NSString *)head withImageView:(UIImageView*) view size:(CGSize)size defImg:(NSString*)defImg;

//返回缩略图文件名  xxx.yyy  ->   xxx_thumb.yyy
+ (NSString*) thumbName:(NSString*)name;

// 从相册获取图片
+ (void)pickPhotosLimit:(NSInteger)limit Orignal:(BOOL)orignal ChooseDelegate:(id<DDChoosePhotoDelegate>)delegate ViewController:(UIViewController*)controller;

// 从相机获取图片
+ (void)takePhoto:(UIViewController *)controller TakeDelegate:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)takeDelegate;

//预加载png图片大小
+(CGSize)pngImageSizeWithHeaderData:(NSString *)urlStr;

//预加载png图片大小
+(CGSize)jpgImageSizeWithHeaderData:(NSString *)urlStr;
@end
