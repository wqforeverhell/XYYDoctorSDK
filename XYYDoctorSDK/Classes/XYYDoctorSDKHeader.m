//
//  XYYPatientSDKHeader.m
//  yaolianti-c
//
//  Created by huangliwen on 2018/9/4.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "XYYDoctorSDKHeader.h"
#import "NTESClientUtil.h"
#import "YLTCustomAttachmentDecoder.h"
#import "DataManager.h"
#import "NTESService.h"
#import "NTESNotificationCenter.h"
#import "NTESBundleSetting.h"
#import "UserCmd.h"
#import "UserStruce.h"
#import "MessageTimestampDBStruce.h"
#define NIMSDKAppKey @"d3538d059ba1d192b507ee1bce78cbf4"
static XYYDoctorSDKHeader* _instance = nil;
@interface XYYDoctorSDKHeader()
@property(nonatomic,assign)BOOL isShowBack;
@end
@implementation XYYDoctorSDKHeader
#pragma mark 单例
+ (instancetype) shareInstance {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    }) ;
    return _instance ;
}
+(id) allocWithZone:(struct _NSZone *)zone
{
    return [XYYDoctorSDKHeader shareInstance] ;
}
-(id) copyWithZone:(struct _NSZone *)zone
{
    return [XYYDoctorSDKHeader shareInstance] ;
}

#pragma 外部方法
//初始化sdk
-(void)setupXYYDoctorSDK:(NSString *)cerName{
    [[NIMSDK sharedSDK] registerWithAppID:NIMSDKAppKey cerName:cerName];
    [[NIMKit sharedKit] setProvider:[DataManager sharedInstance]];
    [[NIMKit sharedKit] registerLayoutConfig:[NIMCellLayoutConfig new]];
    //注册自定义消息的解析器
    [NIMCustomObject registerCustomDecoder:[YLTCustomAttachmentDecoder new]];
    [[NTESNotificationCenter sharedCenter] start];
}
//登录sdk
-(void)loginXYYDoctorSDK:(NSString *)account success:(XYYSuccessBlock)success failed:(XYYFailedBlock)failed{
    [[XYYDoctorSDKHeader shareInstance] loginXYYDoctorSDK:account pwd:@"D06DFB926364FC22A875D47CD32936EC" success:success failed:failed];
}
-(void)loginXYYDoctorSDK:(NSString *)account pwd:(NSString *)pwd success:(XYYSuccessBlock)success failed:(XYYFailedBlock)failed{
    AppLoginCmd *cmd = [[AppLoginCmd alloc]init];
    cmd.loginAccount = account;
    cmd.pwd = pwd;
    [[HttpNetwork getInstance] request:cmd success:^(BaseRespond *respond) {
//        NSLog(@"登录信息MYdata%@",respond.data);
        NSLog(@"XYYLog:UserLoginCmd 请求成功");
        NSDictionary *dic=[respond.data objectForKey:@"result"];
        UserLoginDetailModel *model = [[UserLoginDetailModel alloc]initWithDictionary:dic];
        [ConfigUtil saveString:model.token withKey:APP_TOKEN];//token
        [ConfigUtil saveString:[NSString stringWithFormat:@"%ld",model.docterId] withKey:DOCTOR_ID];//医生id
        [ConfigUtil saveString:cmd.loginAccount withKey:USERNAME];//登录账号
        [ConfigUtil saveteger:model.authType withKey:DOCTOR_AUTHTYPE];
        [ConfigUtil saveteger:model.doctorType withKey:DOCTORTYPE];
        [ConfigUtil saveteger:model.countDown withKey:COUNTDOWN];
        [ConfigUtil saveString:[dic[@"id"] stringValue]withKey:UID];
        [ConfigUtil saveteger:model.review withKey:REVIEW];
        [ConfigUtil saveString:[NSString stringWithFormat:@"%ld",model.hospitalId] withKey:HOSTPATIAL_ID];
        [ConfigUtil saveString:cmd.pwd withKey:PASSWORD];
        [ConfigUtil saveString:model.hosName withKey:HOSTPATIAL_NAME];
        [ConfigUtil saveteger:model.province withKey:PROVINCE];
        [ConfigUtil saveteger:model.state withKey:STATUE];
        if (model.state == 1) {
            if (model.doctorType == 0) {
                if (model.authType ==0 || model.authType ==2) {
                    [ConfigUtil saveteger:model.state withKey:STATUE];
                    [ConfigUtil saveString:model.hxAccount withKey:YXLOGINACCOUNT];
                    [[[NIMSDK sharedSDK] loginManager] login:model.hxAccount
                                                       token:model.hxPwd
                                                  completion:^(NSError *error) {
                                                      if (error != nil){
                                                          NSLog(@"XYYlog:%@",error);
                                                          if (failed) {
                                                              failed([NSString stringWithFormat:@"%@",error]);
                                                          }
                                                      }else{
                                                          NSLog(@"XYYlog:消息服务已启动");
                                                          [[NTESServiceManager sharedManager] start];//启动服务
                                                          if (success) {
                                                              success();
                                                          }
                                                      }
                                                  }];
                }else{
                    [ConfigUtil saveteger:model.state withKey:STATUE];
//                    [JumpUtil jumpMain];
                }
            }else{
                [ConfigUtil saveteger:model.state withKey:STATUE];
//                [JumpUtil jumpMain];
            }
        }else{
            [ConfigUtil saveteger:model.state withKey:STATUE];
//            [JumpUtil jumpMain];
        }
    } failed:^(BaseRespond *respond, NSString *error) {
        NSLog(@"XYYlog:%@",error);
        if (failed) {
            failed(error);
        }
    }];
}
//退出登录
-(void)loginOutXYYDoctorSDK{
    DoctorWtihExitLoginCmd *cmd = [[DoctorWtihExitLoginCmd alloc]init];
    WS(weakSelf);
    [[HttpNetwork getInstance] request:cmd success:^(BaseRespond *respond) {
        //[ConfigUtil saveString:@"" withKey:USERNAME];
        [ConfigUtil saveString:@"" withKey:UID];
        [ConfigUtil saveString:@"" withKey:APP_TOKEN];
        NSArray *array = [ConfigUtil getUserDefaults:ACCOUNTaRRAY];
        NSMutableArray *countArray = [[NSMutableArray alloc]initWithCapacity:0];
        [countArray addObjectsFromArray:array];
        [countArray removeAllObjects];
        [ConfigUtil setUserDefaults:[countArray mutableCopy] forKey:ACCOUNTaRRAY];
        [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error)
         {
         }];
        //self.globalHelper = [MessageTimestampDBStruce getUsingLKDBHelper];
        [LKDBHelper clearTableData:[MessageTimestampDBStruce class]];
        
    } failed:^(BaseRespond *respond, NSString *error) {
        NSLog(@"XYYlog:%@",error);
    }];
}
//接诊列表
-(void)pushToDoctorHome:(UIViewController *)controller{
    [JumpUtil jumpHuanZheList:controller];
}
-(void)showJiedan {
    NSArray *modelArray=[MessageTimestampDBStruce contactWithDocIsAlert:0];
    if (![modelArray count]) {
        return;
    }
    MessageTimestampDBStruce *model=[modelArray objectAtIndex:0];
    NIMSession *session = [NIMSession session:model.doctorId type:NIMSessionTypeP2P];
    NSArray *messages = [[NIMSDK sharedSDK].conversationManager messagesInSession:session messageIds:@[model.messageId]];
    if (messages.count>0)
        //       [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:[NIMSession session:messages.firstObject type:NIMSessionTypeP2P]];
        [[NTESNotificationCenter sharedCenter] showIsJiedan:messages.firstObject];
}
//是否显示返回按钮
-(BOOL)getIsShowBackBtn{
    return _instance.isShowBack;
}
@end
