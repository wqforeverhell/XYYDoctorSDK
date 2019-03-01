//
//  HuanzheListViewController.m
//  yaolianti
//
//  Created by zl on 2018/7/16.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "HuanzheListViewController.h"
#import "UIView+NIM.h"
#import "ViewUtil.h"
#import "HuanzheCmd.h"
#import "NTESSessionUtil.h"
//#import "MainTabBarController.h"
#import "SessionViewController.h"
#import "UserCmd.h"
#import "UIView+hlwCate.h"
#import "NTESNotificationCenter.h"
#import "HuanzheStruce.h"
#import "NetPageStruct.h"
#import "MJRefresh.h"
#import "YLTCustomAttachmentDecoder.h"
#import "YLTCustomMessageAttachment.h"
#import "YLTSSessionMsgConverter.h"
#import "YLTAlertUtil.h"
#import "HuanZheWithMessageDBStruce.h"
#import "NIMSessionListCell.h"
#import "NIMAvatarImageView.h"
#import "YLTwenzhenTableViewCell.h"
#import "HuanzheHistoryListViewController.h"
#import "MessageTimestampDBStruce.h"
#import <AVFoundation/AVFoundation.h>
#import "XYYDoctorSDK.h"
@interface HuanzheListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *bigArray;
@property (nonatomic,strong)NSMutableArray *smallArray;
@property (nonatomic,strong) UIButton *restBtn;
@property (nonatomic,copy)NSString *doctorStatus;
@property (nonatomic,strong)PageParams *pageParams;
@property (nonatomic,strong)UITextView *textview;
@property (nonatomic,strong)AVAudioPlayer *audioPlayer;
@end
@implementation HuanzheListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self setupTitleWithString:@"患者列表" withColor:[UIColor whiteColor]];
    [self setupBack];
    _restBtn.layer.cornerRadius=_restBtn.height/2;
    _restBtn.layer.masksToBounds=YES;
    [self netGetDoctorStatus];
    self.pageParams = [[PageParams alloc]init];
    [_restBtn setImage:[UIImage imageNamed:@"rest_n"] forState:UIControlStateNormal];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGB(245, 245, 245);
    [self.view addSubview:self.tableView];
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    //注册cell
    NSString *BundlePath = [FileUtil getSDKResourcesPath];
    NSBundle *sampleBundle = [NSBundle bundleWithPath:BundlePath];
    UINib* nib = [UINib nibWithNibName:@"YLTwenzhenTableViewCell" bundle:sampleBundle];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"wenzhen"];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake375(0, 0, 375, 10)];
    // 设置header
    header.backgroundColor = RGB(240, 240, 240);
    self.tableView.tableHeaderView = header;
    self.tableView.tableFooterView  = [[UIView alloc] init];
    self.tableView.tableFooterView.backgroundColor = RGB(245, 245, 245);
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    // 去掉通知角标
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self registerForKeyboardNotifications];
    [self setupNextWithString:@"处方单" withColor:RGB(2, 175, 102)];
    
 }

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.restBtn.selected = NO;
   [self netGetDoctorStatus];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
- (void)onNext {
    [JumpUtil pushChufangHomeVC:self];
}
- (void)refresh{
    self.recentSessions=[NSMutableArray array];
    NSArray *array=[[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
    for (NIMRecentSession *session in array) {
        NSArray *typeGoodArray=[self.pageParams.result filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@" self.storeHxAccount==%@" , session.session.sessionId]];
        if (typeGoodArray.count>0) {
            continue;
        }
        [self.recentSessions addObject:session];
    }
    [self.tableView reloadData];
}
- (void)registerForKeyboardNotifications{
    //开单成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kaidancg)   name:NOTICE_KAIDAN_SUCCESS object:nil];
}
- (void)kaidancg {
    NIMSession *session = [NIMSession session:[ConfigUtil stringWithKey:LASTCHARTACCOUNT] type:NIMSessionTypeP2P];
    [NTESSessionUtil removeRecentSessionMark:session type:NTESRecentSessionMarkTypeAt];
    NSArray *array = [ConfigUtil getUserDefaults:ACCOUNTaRRAY];
    NSMutableArray *bigArray = [[NSMutableArray alloc]initWithCapacity:0];
    [bigArray addObjectsFromArray:array];
    [bigArray removeObject:[ConfigUtil stringWithKey:LASTCHARTACCOUNT]];
    [ConfigUtil setUserDefaults:[bigArray mutableCopy] forKey:ACCOUNTaRRAY];
    //挂断电话
    [[NIMAVChatSDK sharedSDK].netCallManager hangup:[NTESNotificationCenter sharedCenter].lastCallID];
    [[NTESNotificationCenter sharedCenter]  onHangup:[NTESNotificationCenter sharedCenter].lastCallID by:nil];
}
-(UIButton *)restBtn{
    //工作状态按钮
    if (!_restBtn) {
        _restBtn=[[UIButton alloc] initWithFrame:CGRectMake(15, SCREEN_HEIGHT-TITLE_HEIGHT_WITH_BAR-160, 100, 100)];
        _restBtn.centerX = self.view.centerX;
        NSString *imagStr = [FileUtil getSDKResourcesPath];
        [_restBtn setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",[imagStr stringByAppendingPathComponent:@"home_xiuxi_icon"]]] forState:UIControlStateNormal];
      
        //[_restBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@/home_jiedan_icon",imagStr]] forState:UIControlStateSelected];
        NSString *path = [imagStr stringByAppendingPathComponent:@"home_jiedan_icon"];
        [_restBtn setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateSelected];
        [_restBtn addTarget:self action:@selector(restClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_restBtn];
    }
    return _restBtn;
}
//休息按钮
- (void)restClick:(UIButton*)sender {
    //默认是休息状态
    [MBProgressHUD showMessag:@"" toView:self.view];
    WS(weakSelf);
    if (!sender.selected) {
        DoctorWorkToRestCmd *cmd = [[DoctorWorkToRestCmd alloc]init];
        [[HttpNetwork getInstance] request:cmd success:^(BaseRespond *respond) {
            //[MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showSuccess:@"设置状态成功,当前休息中" toView:weakSelf.view];
            [weakSelf setupTitleWithString:@"休息中"];
            weakSelf.restBtn.selected = !sender.selected;
        } failed:^(BaseRespond *respond, NSString *error) {
            [MBProgressHUD showError:error toView:weakSelf.view];
        }];
    }else{
        DoctorRestToWorkCmd *cmd = [[DoctorRestToWorkCmd alloc]init];
        [[HttpNetwork getInstance] request:cmd success:^(BaseRespond *respond) {
            //[MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showSuccess:@"设置状态成功，当前接诊中" toView:weakSelf.view];
            [weakSelf setupTitleWithString:@"在线问诊中"];
            weakSelf.restBtn.selected = !sender.selected;
        } failed:^(BaseRespond *respond, NSString *error) {
            [MBProgressHUD showError:error toView:weakSelf.view];
        }];
    }
}
#pragma mark 网络请求
//获取医生的接单的相关信息
-(void)netGetDoctorStatus{
    [MBProgressHUD showMessag:@"" toView:self.view];
    WS(weakSelf);
    GetDoctorCurrentStatusCmd *cmd = [[GetDoctorCurrentStatusCmd alloc]init];
    [[HttpNetwork getInstance] request:cmd success:^(BaseRespond *respond) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        [weakSelf.pageParams.result removeAllObjects];
        weakSelf.doctorStatus=[respond.data objectForKey:@"result"][@"currentStatus"];
        id list = [respond.data objectForKey:@"result"][@"relationInfo"];
        NSArray* array = [DoctorWithListDetailModel arrayFromData:list];
        NSInteger limitCount =[respond.data[@"result"][@"maxLimit"] integerValue];
        [ConfigUtil saveteger:limitCount withKey:MAXLIMIT];
        NSInteger relationCount ;
        if (array.count < 1) {
            relationCount = 0;
        }else{
            relationCount = array.count;
        }
        [ConfigUtil saveteger:relationCount withKey:RELATIONINFO];
        if (array.count > 0) {
            [weakSelf.pageParams.result addObjectsFromArray:array];
        }
        [NSGCDThread dispatchAsyncInMailThread:^{
            [weakSelf refresh];
        }];
    } failed:^(BaseRespond *respond, NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
        if(!IS_EMPTY(error))
            [MBProgressHUD showError:error toView:weakSelf.view];
    }];
}
//获取医生的状态
-(void)setDoctorStatus:(NSString *)doctorStatus{
    //AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _doctorStatus=doctorStatus;
    if ([_doctorStatus isEqualToString:@"online"]) {
        //在线接单
        self.restBtn.selected=NO;
        self.restBtn.hidden = NO;
        //appDelegate.isclinicaling = NO;
        [self setupTitleWithString:@"等待接诊中"];
    }else if ([_doctorStatus isEqualToString:@"clinicaling_web"]){
        //在线接诊中WEB
        [MBProgressHUD showError:@"您正在web端接诊中，请先结束" toView:self.view];
        self.restBtn.selected=NO;
        self.restBtn.hidden = NO;
        [self setupTitleWithString:@"您正在web端接诊"];
        //appDelegate.isclinicaling = NO;
    }else if ([_doctorStatus isEqualToString:@"clinicaling_app"]){
        //在线接诊中APP
        self.restBtn.selected=NO;
        self.restBtn.hidden = YES;
        [self setupTitleWithString:@"在线接诊中"];
        //appDelegate.isclinicaling = YES;
    }else{
        //休息
        self.restBtn.selected=YES;
        self.restBtn.hidden = NO;
        //appDelegate.isclinicaling = NO;
        [self setupTitleWithString:@"休息中"];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        NIMRecentSession *recentSession = [self.recentSessions firstObject];
        [self onSelectedRecent:recentSession atIndexPath:indexPath];
    }else{
        DoctorWithListDetailModel *model = self.pageParams.result[indexPath.row];
        NIMSession *session = [NIMSession session:model.storeHxAccount type:0];
        SessionViewController *vc = [[SessionViewController alloc] initWithSession:session];
        vc.hxAccount = model.storeHxAccount;
        vc.strTitle = model.storeName;
        vc.isShowChufang = YES;
        vc.relationType = model.relationType;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        __weak typeof(self) weakSelf = self;
        UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            NIMRecentSession *recentSession = weakSelf.recentSessions[indexPath.row];
            [weakSelf onDeleteRecentAtIndexPath:recentSession atIndexPath:indexPath];
            [tableView setEditing:NO animated:YES];
        }];
        return @[delete];
    }else{
        return @[] ;
    }
}
- (void)onDeleteRecentAtIndexPath:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath
{
    id<NIMConversationManager> manager = [[NIMSDK sharedSDK] conversationManager];
    [manager deleteRecentSession:recent];
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    // All tasks are handled by blocks defined in editActionsForRowAtIndexPath, however iOS8 requires this method to enable editing
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        if (self.recentSessions.count<=1) {
          return self.recentSessions.count;
        }else{
            return 1;
        }
    }
    return self.pageParams.result.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 0.01;
    }
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        static NSString * cellId = @"cellId";
        NIMSessionListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[NIMSessionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            [cell.avatarImageView addTarget:self action:@selector(onTouchAvatar:) forControlEvents:UIControlEventTouchUpInside];
        }
        NIMRecentSession *recent;
        if (self.recentSessions.count <= 1) {
            recent = self.recentSessions[indexPath.row];
        }else{
            recent = self.recentSessions[0];
        }
        //cell.nameLabel.textColor = RGB(153, 153, 153);
        cell.nameLabel.text = [self nameForRecentSession:recent];
        [cell.avatarImageView setAvatarBySession:recent.session];
        [cell.nameLabel sizeToFit];
        cell.messageLabel.attributedText  = [self contentForRecentSession:recent];
        [cell.messageLabel sizeToFit];
        cell.timeLabel.text = [self timestampDescriptionForRecentSession:recent];
        [cell.timeLabel sizeToFit];
        [cell refresh:recent];
        return cell;
        
    }else{
        static NSString * cellIdIdentifier = @"wenzhen";
        YLTwenzhenTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdIdentifier];
        if (!cell) {
            cell = [[YLTwenzhenTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdIdentifier];
        }
        DoctorWithListDetailModel *model = self.pageParams.result[indexPath.row];
        [cell reloadDataWithModel:model];
        WEAK_SELF(weakSelf)
        [cell setOnYpBigAddBlock:^(DoctorWithListDetailModel *recent) {
            
            [YLTAlertUtil presentAlertViewWithTitle:@"" message:@"您确定要结束本次问诊？" cancelTitle:@"取消" defaultTitle:@"确定" distinct:YES cancel:^{
                [ConfigUtil saveBool:NO withKey:KAICHUFANG_OVER];
            } confirm:^{
                [MBProgressHUD showMessag:@"" toView:weakSelf.view];
                GetDoctordoctorRefuseCmd *cmd = [[GetDoctordoctorRefuseCmd alloc]init];
                cmd.hxLoginAccount = model.storeHxAccount;
                [[HttpNetwork getInstance] request:cmd success:^(BaseRespond *respond) {
                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
                  
                    [NSGCDThread dispatchAfterInMailThread:^{
                        [weakSelf netGetDoctorStatus];
                    } Delay:2000];
                    [weakSelf.pageParams.result removeObjectAtIndex:indexPath.row];
                    [weakSelf.tableView beginUpdates];
                    [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationLeft];
                    [weakSelf.tableView endUpdates];
                    NIMSession *session = [NIMSession session:model.storeHxAccount type:NIMSessionTypeP2P];
                    YLTCustomMessageAttachment *attacment = [[YLTCustomMessageAttachment alloc] init];
                    attacment.type = ChufangMessageTypeJSWZ;
                    attacment.messageText = @"结束通话";
                    NIMMessage *message = [YLTSSessionMsgConverter msgWithCustomMessage:attacment];
                    
                    message.text = @"结束通话";
                    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
                    
                    NSArray *array = [ConfigUtil getUserDefaults:ACCOUNTaRRAY];
                    NSMutableArray *countArray = [[NSMutableArray alloc]initWithCapacity:0];
                    [countArray addObjectsFromArray:array];
                    [countArray removeObject:recent.storeHxAccount];
                    [ConfigUtil setUserDefaults:[countArray mutableCopy] forKey:ACCOUNTaRRAY];
                    HuanZheWithMessageDBStruce *modelMeaa = [HuanZheWithMessageDBStruce getPatienInfoWithHXAcountId:model.storeHxAccount];
                    [modelMeaa deleteToDB];
                    [ConfigUtil setUserDefaults:@[] forKey:SAVE_YP_ARRAY];
                    //挂断电话
                    [[NIMAVChatSDK sharedSDK].netCallManager hangup:[NTESNotificationCenter sharedCenter].lastCallID];
                    [[NTESNotificationCenter sharedCenter]  onHangup:[NTESNotificationCenter sharedCenter].lastCallID by:nil];
                    //[[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_KAIDAN object:self];
                    [[UIApplication sharedApplication] cancelAllLocalNotifications];
                } failed:^(BaseRespond *respond, NSString *error) {
                    [MBProgressHUD showError:error toView:weakSelf.view];
                }];
                
            }];
        }];
        
        return cell;
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView*  sectionBackView=[[UIView alloc] initWithFrame:CGRectMake375(0, 0, 375, 40)];
    
    sectionBackView.backgroundColor=[UIColor whiteColor];
    //[ViewUtil setJianbianToView:sectionBackView colorType:JianBianGreen frame:sectionBackView.bounds];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake375(0, 39, 375, 1)];
    lineView.backgroundColor = RGB(217, 217, 217);
    [sectionBackView addSubview:lineView];
    
    UIView *jianView = [[UIView alloc]initWithFrame:CGRectMake375(10, 10, 6, 17)];
    [sectionBackView addSubview:jianView];
    if (section == 1) {
        [ViewUtil setVerJianbianToView:jianView colorType:jianBianOne frame:jianView.bounds];
        lineView.backgroundColor = RGB(217, 217, 217);
    }else{
        [ViewUtil setVerJianbianToView:jianView colorType:jianBianTwo frame:jianView.bounds];
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake375(280, 0, 90, 40);
    [btn setImage:[UIImage XYY_imageInKit:@"home_back"] forState:UIControlStateNormal];
    [btn setTitle:@"查看更多" forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, - btn.imageView.image.size.width, 0, btn.imageView.image.size.width)];
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [btn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    btn.titleLabel.font = FONT(14);
    if (UIScreenWidth <=320) {
       [btn setImageEdgeInsets:UIEdgeInsetsMake(0, AutoX375(70), 0, -btn.titleLabel.bounds.size.width)];
    }else{
         [btn setImageEdgeInsets:UIEdgeInsetsMake(0, AutoX375(50), 0, -btn.titleLabel.bounds.size.width)];
    }
   
    [sectionBackView addSubview:btn];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];

    UILabel*  numLabel=[[UILabel alloc] initWithFrame:CGRectMake(25, 0, 180, 40)];
    
    numLabel.font = FONT(14);
    
    numLabel.textColor = RGB(51, 51, 51);
    if (section == 0) {
        numLabel.text = @"接诊中患者";
        btn.hidden = YES;
        
    }else{
        numLabel.text = @"已接诊患者";
        btn.hidden = NO;
    }
    [sectionBackView addSubview:numLabel];
    return sectionBackView;
}
- (void)click {
    HuanzheHistoryListViewController *listVC = [[HuanzheHistoryListViewController alloc]init];
    listVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listVC animated:YES];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

- (void)onTouchAvatar:(id)sender{
    UIView *view = [sender superview];
    while (![view isKindOfClass:[UITableViewCell class]]) {
        view = view.superview;
    }
    UITableViewCell *cell  = (UITableViewCell *)view;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NIMRecentSession *recent = self.recentSessions[indexPath.row];
    [super onSelectedAvatar:recent atIndexPath:indexPath];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
