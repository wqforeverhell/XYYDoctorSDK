//
//  XYYPatientSDKHeader.h
//  yaolianti-c
//
//  Created by huangliwen on 2018/9/4.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYYDoctorSDK.h"
typedef void (^XYYSuccessBlock)(void);
typedef void (^XYYFailedBlock)(NSString* error);
@interface XYYDoctorSDKHeader : NSObject
/**
 *  获取SDK实例
 *
 *  @return XYYPatientSDKHeader实例
 */
+ (instancetype)shareInstance;

/**
 *  初始化sdk
 *
 * @cerName 证书名称
 */
-(void)setupXYYPatientSDK:(NSString *)cerName;
/**
 *  登录sdk
 *
 * @account 账号
 * @success 登录成功回调
 * @failed 登录失败回调
 */
-(void)loginXYYDoctorSDK:(NSString *)account success:(XYYSuccessBlock)success failed:(XYYFailedBlock)failed;
-(void)loginXYYDoctorSDK:(NSString *)account pwd:(NSString *)pwd success:(XYYSuccessBlock)success failed:(XYYFailedBlock)failed;
/**
 *  退出登录
 *
 */
-(void)loginOutXYYDoctorSDK;
/**
 *  跳转到接诊
 *
 */
-(void)pushToDoctorHome:(UIViewController *)controller;
/**
 *  获取
 *
 */
//是否显示返回按钮
-(BOOL)getIsShowBackBtn;

/**
 接单弹框

 @param message 开单信息
 */
-(void)showJiedan;
@end
