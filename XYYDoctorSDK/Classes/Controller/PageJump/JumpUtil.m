//
//  JumpUtil.m
//  aide
//
//  Created by huangliwen on 2017/12/11.
//  Copyright © 2017年 xym. All rights reserved.
//

#import "JumpUtil.h"
#import "CALayer+Transition.h"
#import "CALayer+Anim.h"
#import "HZKaiChufangYpController.h"
#import "ChufangHomeController.h"
#import "HuanzheHomeController.h"
#import "ChuPreviewViewController.h"
#import "ChaxunViewController.h"
#import "DiagnoseListViewController.h"
#import "HZXYTableViewController.h"
#import "DoctorSelectMoBanViewController.h"
#import "HZHistoryPrescriptionTableViewController.h"
#import "HZMobanListTableViewController.h"
#import "YPDetailTableViewController.h"
#import "HuanzheListViewController.h"
#import "CFWuLiuViewController.h"
#import "XYYDoctorSDK.h"
@implementation JumpUtil
// 从xib中加载ui对象
+ (id)loadFromXib:(NSString *)xib withCls:(__unsafe_unretained Class)cls {
    NSString *BundlePath = [FileUtil getSDKResourcesPath];
    NSBundle *sampleBundle = [NSBundle bundleWithPath:BundlePath];
    NSArray* array = [sampleBundle loadNibNamed:xib owner:nil options:nil];
    if (array && array.count > 0) {
        for (id obj in array) {
            if ([obj isKindOfClass:cls]) {
                return obj;
            }
        }
    }
    return nil;
}
#pragma mark 开处方相关

//开处方药品列表
+(void)pushHZKaiChufangYp:(UIViewController *)controller userStr:(NSDictionary*)userStr chufangStr:(NSDictionary*)chufangStr ypArray:(NSArray *)ypArray;
{
    NSString *BundlePath = [FileUtil getSDKResourcesPath];
    NSBundle *sampleBundle = [NSBundle bundleWithPath:BundlePath];
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Huanzhe" bundle:sampleBundle];
    HZKaiChufangYpController* ctrl = [story instantiateViewControllerWithIdentifier:@"HZKaiChufangYp"];
    ctrl.userStr=userStr;
    ctrl.chufangStr = chufangStr;
    ctrl.ypArray = ypArray;
    ctrl.hidesBottomBarWhenPushed = YES;
    [controller.navigationController pushViewController:ctrl animated:YES];
}
//处方预览
+(void)jumpPreview:(UIViewController*)controller webstr:(NSString*)webStr userinfo:(NSDictionary*)userinfo patientInfo:(NSDictionary*)patientInfo Array:(NSArray*)Array{
    NSString *BundlePath = [FileUtil getSDKResourcesPath];
    NSBundle *sampleBundle = [NSBundle bundleWithPath:BundlePath];
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Huanzhe" bundle:sampleBundle];
    ChuPreviewViewController* ctrl = [story instantiateViewControllerWithIdentifier:@"preview"];
    ctrl.webStr = webStr;
    ctrl.userDict = userinfo;
    ctrl.patienDict = patientInfo;
    ctrl.commitArray = Array;
    ctrl.hidesBottomBarWhenPushed = YES;
    [controller.navigationController pushViewController:ctrl animated:YES];
}
//患者的血压情况
+(void)pushHZXueya:(UIViewController*)controller userMessage:(NSString*)userMessage {
    NSString *BundlePath = [FileUtil getSDKResourcesPath];
    NSBundle *sampleBundle = [NSBundle bundleWithPath:BundlePath];
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Huanzhe" bundle:sampleBundle];
    HZXYTableViewController* ctrl = [story instantiateViewControllerWithIdentifier:@"xueya"];
    ctrl.hidesBottomBarWhenPushed = YES;
    [controller.navigationController pushViewController:ctrl animated:YES];
}
//处方列表
+ (void)pushChufangHomeVC:(UIViewController*)controller   {
    NSString *BundlePath = [FileUtil getSDKResourcesPath];
    NSBundle *sampleBundle = [NSBundle bundleWithPath:BundlePath];
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"XYYMain" bundle:sampleBundle];
    ChufangHomeController* ctrl = [story instantiateViewControllerWithIdentifier:@"chufangHome"];
    ctrl.hidesBottomBarWhenPushed = YES;
    
    [controller.navigationController pushViewController:ctrl animated:YES];
}
//医生选取模板
+(void)pushMoBanVC:(UIViewController*)controller model:(YaopinMoBanModel*)model mArray:(NSArray*)mArray {
    NSString *BundlePath = [FileUtil getSDKResourcesPath];
    NSBundle *sampleBundle = [NSBundle bundleWithPath:BundlePath];
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Huanzhe" bundle:sampleBundle];
    DoctorSelectMoBanViewController* ctrl = [story instantiateViewControllerWithIdentifier:@"DoctorMB"];
    ctrl.hidesBottomBarWhenPushed = YES;
    ctrl.listModel = model;
    ctrl.mArray = mArray;
    [controller.navigationController pushViewController:ctrl animated:YES];
}
//患者的历史处方
+(void)pushHistoryPre:(UIViewController*)controller {
    NSString *BundlePath = [FileUtil getSDKResourcesPath];
    NSBundle *sampleBundle = [NSBundle bundleWithPath:BundlePath];
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Huanzhe" bundle:sampleBundle];
    HZHistoryPrescriptionTableViewController* ctrl = [story instantiateViewControllerWithIdentifier:@"historyPre"];
    ctrl.hidesBottomBarWhenPushed = YES;
    [controller.navigationController pushViewController:ctrl animated:YES];
}
//开处方患者信息
+ (void)pushhuanzheMessage:(UIViewController*)controller {
    NSString *BundlePath = [FileUtil getSDKResourcesPath];
    NSBundle *sampleBundle = [NSBundle bundleWithPath:BundlePath];
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"XYYMain" bundle:sampleBundle];
    HuanzheHomeController* ctrl = [story instantiateViewControllerWithIdentifier:@"huanzheMessage"];
    ctrl.hidesBottomBarWhenPushed = YES;
    
    [controller.navigationController pushViewController:ctrl animated:YES];
}
//医生自己的模板列表
+(void)pushDoctorList:(UIViewController*)controller {
    NSString *BundlePath = [FileUtil getSDKResourcesPath];
    NSBundle *sampleBundle = [NSBundle bundleWithPath:BundlePath];
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Huanzhe" bundle:sampleBundle];
    HZMobanListTableViewController* ctrl = [story instantiateViewControllerWithIdentifier:@"MBList"];
    ctrl.hidesBottomBarWhenPushed = YES;
    [controller.navigationController pushViewController:ctrl animated:YES];
}
//处方流程
+(void)pushWuLiuVC:(UIViewController*)controller code:(NSString*)code {
    NSString *BundlePath = [FileUtil getSDKResourcesPath];
    NSBundle *sampleBundle = [NSBundle bundleWithPath:BundlePath];
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Huanzhe" bundle:sampleBundle];
    CFWuLiuViewController* ctrl = [story instantiateViewControllerWithIdentifier:@"wuliu"];
    ctrl.hidesBottomBarWhenPushed = YES;
    ctrl.code = code;
    [controller.navigationController pushViewController:ctrl animated:YES];
}
//初步诊断列表
+(void)pushDiagnoseVC:(UIViewController*)controller block:(DiagnoseBlock)block {
    NSString *BundlePath = [FileUtil getSDKResourcesPath];
    NSBundle *sampleBundle = [NSBundle bundleWithPath:BundlePath];
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Huanzhe" bundle:sampleBundle];
    DiagnoseListViewController* ctrl = [story instantiateViewControllerWithIdentifier:@"diagnose"];
    ctrl.block = block;
    ctrl.hidesBottomBarWhenPushed = YES;
    [controller.navigationController pushViewController:ctrl animated:YES];
}
//主诉列表
+(void)pushZSVC:(UIViewController*)controller block:(ZSBlock)block{
    NSString *BundlePath = [FileUtil getSDKResourcesPath];
    NSBundle *sampleBundle = [NSBundle bundleWithPath:BundlePath];
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Huanzhe" bundle:sampleBundle];
    HZZhuSTableViewController* ctrl = [story instantiateViewControllerWithIdentifier:@"zhusu"];
    ctrl.block = block;
    ctrl.hidesBottomBarWhenPushed = YES;
    [controller.navigationController pushViewController:ctrl animated:YES];
}
//药品详情
+(void)pushDetail:(UIViewController*)controller dict:(YaopinSearchListModel*)model {
    NSString *BundlePath = [FileUtil getSDKResourcesPath];
    NSBundle *sampleBundle = [NSBundle bundleWithPath:BundlePath];
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Huanzhe" bundle:sampleBundle];
    YPDetailTableViewController* ctrl = [story instantiateViewControllerWithIdentifier:@"detail"];
    ctrl.model = model;
    ctrl.hidesBottomBarWhenPushed = YES;
    [controller.navigationController pushViewController:ctrl animated:YES];
}

//医生接诊列表
+(void)jumpHuanZheList:(UIViewController*)controller {
    NSString *BundlePath = [FileUtil getSDKResourcesPath];
    NSLog(@"sdk-hlw:%@",BundlePath);
    NSBundle *sampleBundle = [NSBundle bundleWithPath:BundlePath];
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"XYYMain" bundle:sampleBundle];
    HuanzheListViewController* ctrl = [story instantiateViewControllerWithIdentifier:@"list"];
    ctrl.hidesBottomBarWhenPushed = YES;
    [controller.navigationController pushViewController:ctrl animated:YES];
}
+ (void)pushChaxunVc:(UIViewController*)controller delegate:(id)delegate  type:(NSInteger)type{
    NSString *BundlePath = [FileUtil getSDKResourcesPath];
    NSBundle *sampleBundle = [NSBundle bundleWithPath:BundlePath];
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Huanzhe" bundle:sampleBundle];
    ChaxunViewController* ctrl = [story instantiateViewControllerWithIdentifier:@"cha"];
    ctrl.delegate = delegate;
    ctrl.type = type;
    ctrl.hidesBottomBarWhenPushed = YES;
    [controller.navigationController pushViewController:ctrl animated:YES];
}
@end
