//
//  ImageUtil.m
//  xinyaomeng
//
//  Created by 黄黎雯 on 2017/6/8.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import "ImageUtil.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DDPhotoListViewController.h"
#import "XYYSDK.h"
#import "FileUtil.h"
#define PICK_IMAGE_FLAG @"pick_img_flag"
#define TACK_IMAGE_FLAG @"take_img_flag"
@implementation ImageUtil
+ (UIImage *)imageWithColor:(UIColor *)color Size:(CGSize) size {
    @autoreleasepool {
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}

/**
 *  获取矩形的渐变色的UIImage(此函数还不够完善)
 *
 *  @param bounds       UIImage的bounds
 *  @param colors       渐变色数组，可以设置两种颜色
 *  @param gradientType 渐变的方式：0--->从上到下   1--->从左到右
 *
 *  @return 渐变色的UIImage
 */
+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(int)gradientType imgSize:(CGSize)imgSize {
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case 0:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        case 1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, 0.0);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

//根据图片名字获取bundle中的图片
+(UIImage*)getImageByPatch:(NSString*)imageName{
    return [ImageUtil getImageByPatchAndType:imageName type:@"png"];
}
+(UIImage*)getImageByPatchAndType:(NSString *)imgName type:(NSString*)imgType{
    // 1. 在main bundle中找到特定bundle
    NSString *sampleBundlePath = [FileUtil getSDKResourcesPath];
    // 2. 载入bundle，即创建bundle对象
    NSBundle *sampleBundle = [NSBundle bundleWithPath:sampleBundlePath];
    // 3. 从bundle中获取资源路径
    NSString *pic1Path = [sampleBundle pathForResource:[NSString stringWithFormat:@"%@@2x",imgName] ofType:imgType];
    // 4. 通过路径创建对象
    return [UIImage imageWithContentsOfFile:pic1Path];
}

//跳转图片旋转
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//最大公约数
+ (int)gcda:(int)a b:(int)b {
    int r;
    while(b != 0) {
        r = a % b;
        a = b;
        b = r;
    }
    if(a <= 0) {
        return 1;
    }
    return a;
}

//缩放尺寸到size
+ (UIImage*)scaleImage:(UIImage*)image toSize:(CGSize) size {
    UIImage *finalImage = [ImageUtil fixOrientation:image];
    CGImageRef imgRef = [finalImage CGImage];
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    if(width <= size.width || height <= size.height) {
        return finalImage;
    }
    
    int r = [ImageUtil gcda:width b:height];
    int width1 = width / r;
    int height1 = height / r;
    
    float vRadio = size.height*1.0/height1;
    float hRadio = size.width*1.0/width1;
    float radio = 1;
    if(vRadio>1 && hRadio>1) {
        radio = hRadio > vRadio ? vRadio : hRadio;
        radio = ceil(radio);
    }
    
    width = width1*radio;
    height = height1*radio;
    
    CGSize newSize = CGSizeMake(width, height);
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    
    UIImage* scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaleImage;
}


//压缩图片，尺寸默认屏幕尺寸
+ (UIImage*)ZIPUIImage:(UIImage*)image {
    CGSize size = [[UIScreen mainScreen] bounds].size;
    return [ImageUtil ZIPUIImage:image size:size];
}

//压缩图片，尺寸为size
+ (UIImage*)ZIPUIImage:(UIImage*)image size:(CGSize)size {
    NSData* data = [ImageUtil ZIPUIImageBackData:image size:size];
    return [UIImage imageWithData:data];
}

//压缩图片，返回nsdata
+ (NSData*)ZIPUIImageBackData:(UIImage*)image size:(CGSize)size {
    UIImage* scaleImage = [self scaleImage:image toSize:CGSizeMake(size.width, size.height)];
    return [ImageUtil ZIPImageSize:scaleImage];
}

//质量压缩图片
+ (NSData*)ZIPImageSize:(UIImage*)image {
    CGFloat rate = 1;
    NSData* data = UIImageJPEGRepresentation(image, rate);
    while([data length] > 1843200 && rate > 0.05) {
        rate -= 0.05;
        data = UIImageJPEGRepresentation(image, rate);
    }
    return data;
}

// 上传用压缩图片
+(NSData*)ZIPImageUpload:(UIImage*)image{
//    CGSize size = [[UIScreen mainScreen] bounds].size;
//    UIImage* scaleImage = [self scaleImage:image toSize:CGSizeMake(size.width, size.height)];
    return [self ZIPImageSize:image];
}

//对于一个图片进行中间剪裁
+ (UIImage*)imageWithCenterCrop:(UIImage *)src targetSize:(CGSize)targetSize {
    
    CGFloat width = CGImageGetWidth(src.CGImage);
    CGFloat height = CGImageGetHeight(src.CGImage);
    
    CGRect rect;
    if(width * targetSize.height > height * targetSize.width) {
        rect = CGRectMake((CGImageGetWidth(src.CGImage) - (targetSize.width/targetSize.height) * height) / 2, 0, width, height);
    }
    else {
        rect = CGRectMake(0, (CGImageGetHeight(src.CGImage) - (targetSize.height/targetSize.width) * width) / 2, width, height);
    }
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(src.CGImage, rect);
    
    CGRect smallBounds = CGRectMake(0, 0, targetSize.width, targetSize.height);
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    return smallImage;
}

//获取聊天图片压缩的系数
+ (CGFloat)getChatZipRate:(UIImage*)image {
    CGFloat rate = 1;
    NSData* data = UIImageJPEGRepresentation(image, rate);
    while([data length] > 1638400 && rate > 0.05) {
        rate -= 0.05;
        data = UIImageJPEGRepresentation(image, rate);
    }
    return rate;
}

+ (void) showHeadImage:(NSString *)head withImageView:(UIImageView*) view {
    if(IS_EMPTY(head)) {
        [view setImage:[ImageUtil getImageByPatch:@"default_head"]];
    }
    else {
        if ([head rangeOfString:@"http"].location != NSNotFound) {
            [view sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[ImageUtil getImageByPatch:@"default_head"]];
        } else {
            NSArray* array = [head componentsSeparatedByString:@","];
            NSString* url = [NSString stringWithFormat:@"%@", [array objectAtIndex:0]];
            NSLog(@"MYdata%@",url);
            
            //            NSString* thumbUrl = [ImageUtil thumbName:url];
            //            NSLog(@"thumbUrl%@",thumbUrl);
            [view sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"me_head_default"] options:SDWebImageRefreshCached];
        }
    }
}

+ (void) showCodeHeadImage:(NSString *)head withImageView:(UIImageView*) view sex:(int)sex {
    NSString*codename=@"me_boy_Icon";
    if(sex==1){
        codename=@"me_gril_Icon";
    }
    if(IS_EMPTY(head)) {
        [view setImage:[UIImage imageNamed:codename]];
    }
    else {
        if ([head rangeOfString:@"http"].location != NSNotFound) {
            [view sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:codename]];
        } else {
            NSArray* array = [head componentsSeparatedByString:@","];
            NSString* url = [NSString stringWithFormat:@"%@", [array objectAtIndex:0]];
            NSLog(@"MYdata%@",url);
            
            //            NSString* thumbUrl = [ImageUtil thumbName:url];
            //            NSLog(@"thumbUrl%@",thumbUrl);
            [view sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:codename] options:SDWebImageRetryFailed];
        }
    }
}

+ (void) showPicImage:(NSString *)head withImageView:(UIImageView*) view size:(CGSize)size {
    if(IS_EMPTY(head)) {
        view.contentMode=UIViewContentModeScaleToFill;
        [view setImage:[UIImage imageNamed:@"img_error_def"]];
    }
    else {
        if ([head rangeOfString:@"http"].location != NSNotFound) {
            NSString *urlutf = [head stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [view sd_setImageWithURL:[NSURL URLWithString:urlutf] placeholderImage:[UIImage imageNamed:@"img_error_def"]];
        } else {
            NSArray* array = [head componentsSeparatedByString:@","];
            NSString* url = [NSString stringWithFormat:@"%@", [array objectAtIndex:0]];
            NSLog(@"MYdata%@",url);
            NSString *urlutf = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString* thumbUrl = [ImageUtil thumbName:urlutf];
            NSLog(@"thumbUrl%@",thumbUrl);
            [view sd_setImageWithURL:[NSURL URLWithString:thumbUrl] placeholderImage:[UIImage imageNamed:@"img_error_def"] options:SDWebImageRetryFailed];
        }
    }
}

+ (void) showNoHcPicImage:(NSString *)head withImageView:(UIImageView*) view size:(CGSize)size defImg:(NSString*)defImg {
    UIImage*image=[UIImage imageNamed:defImg];
    if(IS_EMPTY(head)) {
        if (IS_EMPTY(defImg)) {
            image=[UIImage imageNamed:@"img_error_def"];
            view.contentMode=UIViewContentModeScaleToFill;
            [view setImage:image];
        }else{
            [view setImage:image];
        }
    }
    else {
        if ([head rangeOfString:@"http"].location != NSNotFound) {
            [view sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:image];
        } else {
            NSLog(@"thumbUrl%@",head);
            [view sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:image options:SDWebImageCacheMemoryOnly];
        }
    }
}

//返回缩略图文件名  xxx.yyy  ->   xxx_thumb.yyy
+ (NSString*) thumbName:(NSString*)name {
    if(IS_EMPTY(name)) {
        return name;
    }
    NSString* filename = [name lastPathComponent];
    filename = [NSString stringWithFormat:@"m_%@", filename];
    NSString* finalStr = [NSString stringWithFormat:@"%@/%@", [name stringByDeletingLastPathComponent], filename];
    return finalStr;
}

+ (void)pickPhotosLimit:(NSInteger)limit Orignal:(BOOL)orignal ChooseDelegate:(id<DDChoosePhotoDelegate>)delegate ViewController:(UIViewController*)controller {
    
    BOOL everPicker = [ConfigUtil boolWithKey:PICK_IMAGE_FLAG];
    if (!everPicker) {
        [ConfigUtil saveBool:YES withKey:PICK_IMAGE_FLAG];
        // 该API从iOS8.0开始支持
        // 系统弹出授权对话框
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
                {
                    // 用户拒绝，跳转到自定义提示页面
                    return ;
                }
                else if (status == PHAuthorizationStatusAuthorized)
                {
                    // 用户授权，弹出相册对话框
                    UIStoryboard* story = [UIStoryboard storyboardWithName:@"photo" bundle:nil];
                    UINavigationController* nav = [story instantiateViewControllerWithIdentifier:@"ChoosePhotoNav"];
                    DDPhotoListViewController* listController = [nav.viewControllers objectAtIndex:0];
                    listController.limit = limit;
                    listController.orignal = orignal;
                    listController.delegate = delegate;
                    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    [controller presentViewController:nav animated:YES completion:nil];
                }
            });
        }];
        
    }else{
        if([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized) {
            
            UIStoryboard* story = [UIStoryboard storyboardWithName:@"photo" bundle:nil];
            UINavigationController* nav = [story instantiateViewControllerWithIdentifier:@"ChoosePhotoNav"];
            DDPhotoListViewController* listController = [nav.viewControllers objectAtIndex:0];
            listController.limit = limit;
            listController.orignal = orignal;
            listController.delegate = delegate;
            nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [controller presentViewController:nav animated:YES completion:nil];
        }
        else {
            UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:@"照片权限未开启"
                                                             message:@"请在手机设置－隐私－照片开启照片访问权限以选择照片上传"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
            [prompt setAlertViewStyle:UIAlertViewStyleDefault];
            [prompt show];
        }
    }
}

+ (void)takePhoto:(UIViewController *)controller TakeDelegate:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)takeDelegate {
    
    
    
    BOOL everTake = [ConfigUtil boolWithKey:TACK_IMAGE_FLAG];
    if(!everTake){
        [ConfigUtil saveBool:YES withKey:TACK_IMAGE_FLAG];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = takeDelegate;
        //设置拍照后的图片不可被编辑，因为使用自己的剪裁
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [controller presentViewController:picker animated:YES completion:nil];
    }else{
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(status == AVAuthorizationStatusAuthorized) {
            // authorized
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = takeDelegate;
            //设置拍照后的图片不可被编辑，因为使用自己的剪裁
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [controller presentViewController:picker animated:YES completion:nil];
        } else {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"相册权限未开启" message:@"请在手机设置－隐私－相机开启相册权限以拍照上传照片" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //前往设置
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                //前往设置
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [controller presentViewController:alertController animated:YES completion:nil];
        }
    }
    
}

+(CGSize)pngImageSizeWithHeaderData:(NSString *)urlStr{
    // 初始化请求, 这里是变长的, 方便扩展
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    // 发送同步请求, data就是返回的数据
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (data == nil) {
        NSLog(@"send request failed: %@", error);
        return CGSizeZero;
    }
    int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
    [data getBytes:&w1 range:NSMakeRange(0, 1)];
    [data getBytes:&w2 range:NSMakeRange(1, 1)];
    [data getBytes:&w3 range:NSMakeRange(2, 1)];
    [data getBytes:&w4 range:NSMakeRange(3, 1)];
    int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
    
    int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
    [data getBytes:&h1 range:NSMakeRange(4, 1)];
    [data getBytes:&h2 range:NSMakeRange(5, 1)];
    [data getBytes:&h3 range:NSMakeRange(6, 1)];
    [data getBytes:&h4 range:NSMakeRange(7, 1)];
    int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
    
    return CGSizeMake(w, h);
}

+(CGSize)jpgImageSizeWithHeaderData:(NSString *)urlStr{
    // 初始化请求, 这里是变长的, 方便扩展
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}
@end
