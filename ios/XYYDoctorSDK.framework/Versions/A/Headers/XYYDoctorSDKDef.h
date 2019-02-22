//
//  yaolianti.pch
//  yaolianti
//
//  Created by huangliwen on 2018/6/5.
//  Copyright © 2018年 hlw. All rights reserved.
//

// Include any system framework and library headers here that should be included in all compilation units.
// You will also need to set the Prefix Header build setting of one or more of your targets to reference this file.
#ifdef __OBJC__

#import "XYYSDK.h"
#import "XYYChatSDK.h"

//app名称配置
#define APP_NAME @"yaolianti"
//底部按钮高度
#define DEFAULT_TABBAR_HEIGHT 49

//导航栏颜色
#define NAV_BAR_COLOR HexRGB(0x252525)

//程序中默认字体
#define DEFAULT_FONT @"Helvetica"

//本地数据库名称
#define LOCAL_DB_NAME @"yaolianti"

// 服务器接口根地址
#define API_HOST @"http://appd.51linked.cn/api/"//正式地址
//#define API_HOST @"http://192.168.1.189:8904/prescript-doctor-web/"//测试地址
//h5页面地址
#define H5_HOST  @"https://p.51linked.cn/app-Xinyiyun/"//正式地址

//版本更新相关
#define DOWNLOAD_PLIST_URL [NSString stringWithFormat:@"%@/app-Xinyiyun/ios/Xinyiyun/versions-p.plist", API_HOST]

#define IMAGE_URL(substr) [NSString stringWithFormat:@"%@/mobile_img/%@", API_HOST,substr]

//灰色
#define HUISE_COLOR HexRGB(0x919191)
//黑色
#define HEISE_COLOR HexRGB(0x414141)
//线条颜色
#define LINE_COLOR HexRGB(0xf0f0f0)
#define DEFAULT_BORDER_COLOR HexRGB(0xd9d9d9)
//主要交互色
#define DEFAULT_JIAOHU_COLOR HexRGB(0x02af66)
#define DEFAULT_JIAOHU_HUISE_COLOR HexRGB(0xc5c5c5)
#define DEFAULT_JIAOHU_ORANGE_COLOR HexRGB(0xF5A623)

#define RectX(f)                            f.origin.x
#define RectY(f)                            f.origin.y
#define RectWidth(f)                        f.size.width
#define RectHeight(f)                       f.size.height

#define AutoSizeX  [UIScreen mainScreen].bounds.size.width/375
#define AutoSizeY  [UIScreen mainScreen].bounds.size.height/667
//自适应长、宽
#define CGRectMake375( x, y, width, height) CGRectMake(x*AutoSizeX, y*AutoSizeY, width*AutoSizeX, height*AutoSizeY)

#define AutoX375(x)  AutoSizeX* x
#define AutoY375(y)  AutoSizeY* y

//图片圆角数值
#define DEFAULT_YUANJIAO 5.0f

//文字默认大小
#define DEFAULT_FONT_SIZE [UIFont systemFontOfSize:15.0f]

//设置字体大小
#define FONT(a) [UIFont systemFontOfSize:a]
//默认间距
#define DEFAULT_JIANJU 12

//sessionKey
//证书名称
#ifdef DEBUG
#define YXCERNAME            @"test"
#else
#define YXCERNAME            @"sehngchan"
#endif
#define USERNAME @"userName"
#define PASSWORD @"password"
#define DOCTOR_TYPE @"doctortype"
#define DOCTOR_AUTHTYPE @"auth_type" // 0：开方权限  1：荐要权限  2：都有
#define DOCTOR_ID @"doctor_ID"
#define HOSTPATIAL_ID @"hospitalId"
#define DOCTORTYPE @"doctorType" // 0 医生 1 药剂师
#define REVIEW @"review" //（1：需要复诊时间   0：不需要复诊时间）
#define DOCTORNAME @"doctorname"
#define STATUE @"statue" //审核状态 0 待审核 1 审核通过 -1 审核不通过 -2 未审核
#define STOREID @"store_Id"
#define EMID @"emId" //员工ID
#define RELATIONTYPE @"relationType"//连接类型 0 药店 1 病人
#define MOBILE @"mobile"
#define YXLOGINACCOUNT @"hxLoginAccount"//自己的云信id
#define LASTCHARTACCOUNT @"lastChartAccount"//最后一次聊天的云信id
#define ACCOUNTaRRAY @"ProductCode"
#define PHONENUM @"phoneNum"
#define COUNTDOWN @"countDown" // 倒计时时间
#define LASTCHARTYDNAME @"lastChartYdName"//最后一次聊天的药店名称
#define ISAPPCLINICALING @"isAPPClinicaling"//是否app接诊中
#define DiAGNOSETYPE @"type"
#define FIRST_LAUNCH @"first_launch"//是否第一次启动
#define HOSTPATIAL_NAME @"hos_name"
#define DEPARTMENT_NAME  @"dep_name"
#define DEPARTMENT_ID   @"dep_id"
#define YPTOALT @"yao_pin_total"
#define PROVINCE @"province"
#define KAICHUFANG_OVER @"kaichufang_over"//开处方后设置为YES。控制聊天界面开处方显示
#define MO_REN_STORE @"store"
#define MO_REN_ADDRE @"address"
#define MO_REN_STOREID @"storeid"
#define SAVE_YP_ARRAY @"save"//保存药品的数组
//通知列表
#define NOTICE_REFRESH_HUANZHE @"notice_refresh_huanzhe"//刷新患者首页
#define NOTICE_JIEDAN_SUCCESS @"notice_jiedan_success"//接单成功
#define NOTICE_KAIDAN_SUCCESS @"notice_kaidan_success"//开单成功
#define NOTICE_KAICHUFANG_SUCESS @"notice_kaichufang_sucess"//开处方成功
#define NOTICE_STORE_END @"notice_store_end"
#define MAXLIMIT @"maxLimit"//最大接单数
#define NOTICE_KAIDAN @"notice_kaidan"
#define RELATIONINFO   @"relationInfo"//接单个数
//
#define REFUSE_SENSON @"reason"
#define REFUSE_SUCESS @"refuse_suce"

#define IMAGE_URL(substr) [NSString stringWithFormat:@"%@/mobile_img/%@", API_HOST,substr]
#endif /* yaolianti_pch */
