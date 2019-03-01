//
//  JumpUtil.h
//  aide
//
//  Created by huangliwen on 2017/12/11.
//  Copyright © 2017年 xym. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DiagnoseListViewController.h"
#import "HZZhuSTableViewController.h"
//#import "DruggistZXViewController.h"
@class YaopinMoBanModel;
@class YaopinSearchListModel;
@interface JumpUtil : NSObject
// 从xib中加载ui对象
+ (id) loadFromXib:(NSString*) xib withCls:(Class) cls;
#pragma mark -=======开处方相关
//接诊列表
+(void)jumpHuanZheList:(UIViewController*)controller;
//患者血压
+(void)pushHZXueya:(UIViewController*)controller userMessage:(NSString*)userMessage;
//患者信息
+ (void)pushhuanzheMessage:(UIViewController*)controller;

//开处方药品列表
+(void)pushHZKaiChufangYp:(UIViewController *)controller userStr:(NSDictionary*)userStr chufangStr:(NSDictionary*)chufangStr ypArray:(NSArray*)ypArray;
;
//初步诊断列表
+(void)pushDiagnoseVC:(UIViewController*)controller block:(DiagnoseBlock)block;

//主诉列表
+(void)pushZSVC:(UIViewController*)controller block:(ZSBlock)block;

//新增模板
+(void)pushMoBanVC:(UIViewController*)controller model:(YaopinMoBanModel*)model mArray:(NSArray*)mArray;
//预览
+(void)jumpPreview:(UIViewController*)controller webstr:(NSString*)webStr userinfo:(NSDictionary*)userinfo patientInfo:(NSDictionary*)patientInfo Array:(NSArray*)Array
;
//患者历史处方单
+(void)pushHistoryPre:(UIViewController*)controller;
//药品详情
+(void)pushDetail:(UIViewController*)controller dict:(YaopinSearchListModel*)model;
//医生的个人模板列表
+(void)pushDoctorList:(UIViewController*)controller;
//物流界面
+(void)pushWuLiuVC:(UIViewController*)controller code:(NSString*)code;
//新增驳回模板意见
+(void)pushRefuseAddVC:(UIViewController*)controller;
#pragma mark -==== 处方记录
//处方记录
+ (void)pushChufangHomeVC:(UIViewController*)controller;
//查询
+ (void)pushChaxunVc:(UIViewController*)controller delegate:(id)delegate  type:(NSInteger)type;

@end
