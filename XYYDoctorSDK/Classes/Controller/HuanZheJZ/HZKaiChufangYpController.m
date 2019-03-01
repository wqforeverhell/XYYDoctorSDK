//
//  HZKaiChufangYpController.m
//  yaolianti
//
//  Created by huangliwen on 2018/6/8.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "HZKaiChufangYpController.h"
#import "YPInChufangCell.h"
#import "ViewUtil.h"
#import "UIView+hlwCate.h"
#import "HZKaiCFSearchYPController.h"
#import "YaopinEditView.h"
#import "MyTextViewAlertView.h"
#import "HuanzheStruce.h"
#import "HuanzheCmd.h"
#import "HZMoBanTableViewController.h"
#import "YLTAlertUtil.h"
#import "YLTSSessionMsgConverter.h"
#import "YLTCustomMessageAttachment.h"
#import "HuanZheWithMessageDBStruce.h"
#import "SessionViewController.h"
#import "ChuPreviewViewController.h"
#import "UIView+NIM.h"
#import "YPEditCell.h"
#import "HZHistoryPrescriptionTableViewController.h"
#import "XYYDoctorSDK.h"
@interface HZKaiChufangYpController ()<UITableViewDelegate,UITableViewDataSource,WJSecondViewControllerDelegate,mobanValueDelegate,HZHistoryPrescriptionDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnSumbit;
@property (weak, nonatomic) IBOutlet UIButton *btnAddYp;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewH;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)YaopinEditView *YpEditView;
@property (nonatomic,strong) YaopinSearchListModel*model;
@property (nonatomic,assign) NSInteger row;
@property (nonatomic,strong) UIView *bgview;
@property (nonatomic,copy) NSArray *saveArray;
@end

@implementation HZKaiChufangYpController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupBack];
    if ([self.userStr[@"patientName"] isEqualToString:@""]) {
        [self setupTitleWithString:@"开处方"];
    }else{
       [self setupTitleWithString:[NSString stringWithFormat:@"正在为%@开处方",self.userStr[@"patientName"]]];
    }
    [self setupNextWithString:@"预览" withColor:RGB(2, 175, 102)];
    [self.view setBackgroundColor:RGB(245, 245, 245)];
    [self setNodataView];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView:) name:@"moban" object:nil];
    _tableView.backgroundColor = RGB(245, 245, 245);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    //_tableView.backgroundColor = [UIColor redColor];
    //[ViewUtil setshadowColorToView:_tableView];
    
    _btnSumbit.layer.cornerRadius=_btnSumbit.height/2;
    _btnSumbit.layer.masksToBounds=YES;
    //[ViewUtil setJianbianToView:_btnSumbit colorType:JianBianGreen frame:CGRectMake(0, 0, SCREEN_HEIGHT/5*2, _btnSumbit.height)];
    _btnSumbit.backgroundColor = RGB(2, 175, 102);
    _btnAddYp.layer.cornerRadius=_btnAddYp.height/2;
    _btnAddYp.layer.masksToBounds=YES;
    //[ViewUtil setJianbianToView:_btnAddYp colorType:JianBianOrange frame:CGRectMake(0, 0, SCREEN_HEIGHT/5*2, _btnAddYp.height)];
    _btnAddYp.backgroundColor = RGB(2, 175, 102);
    self.dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.tableView.hidden = !self.dataArray.count;
    if (self.ypArray) {
        for (int i = 0; i<self.ypArray.count; i++) {
            YaopinSearchListModel *model = [[YaopinSearchListModel alloc]initWithDictionary:self.ypArray[i]];
            //model.extraTotal  = model.number *[model.extractPrice integerValue];
            [self.dataArray addObject:model];
        }
        [self setData];
        [self.tableView reloadData];
    }
    NSArray *array = [ConfigUtil getUserDefaults:SAVE_YP_ARRAY];
    if ([array count]) {
        [self.dataArray removeAllObjects];
        for (int i = 0; i<array.count; i++) {
            YaopinSearchListModel *model = [[YaopinSearchListModel alloc]initWithDictionary:array[i]];
            [self.dataArray addObject:model];
        }
        [self setData];
        [self.tableView reloadData];
    }
    else{
    }

    [self setData];
    [_tableView reloadData];
    [self showHistoryView];
}
- (void)onBack{
    [super onBack];
    if (self.dataArray) {
        self.saveArray = [self toArray:self.dataArray];
        [ConfigUtil setUserDefaults:self.saveArray forKey:SAVE_YP_ARRAY];
    }
}
- (void)showHistoryView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 29)];
    view.backgroundColor = HexRGB(0xddebe5);
    [self.view addSubview:view];
    
    
    UIButton *seleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seleBtn.frame = view.bounds;
    [seleBtn setTitle:[NSString stringWithFormat:@"点击查看%@的历史处方",self.userStr[@"patientName"]] forState:UIControlStateNormal];
    [seleBtn setTitleColor:RGB(2, 175, 102) forState:UIControlStateNormal];
    seleBtn.backgroundColor = [UIColor clearColor];
    seleBtn.titleLabel.font = FONT(15);
    [seleBtn addTarget:self action:@selector(btnSClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:seleBtn];
}
- (void)btnSClick {
    [ConfigUtil saveString:self.userStr[@"patientName"] withKey:LASTCHARTYDNAME];
    [ConfigUtil saveString:self.userStr[@"telPhoneNum"] withKey:PHONENUM];
    NSString *BundlePath = [FileUtil getSDKResourcesPath];
    NSBundle *sampleBundle = [NSBundle bundleWithPath:BundlePath];
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Huanzhe" bundle:sampleBundle];
    HZHistoryPrescriptionTableViewController* ctrl = [story instantiateViewControllerWithIdentifier:@"historyPre"];
    ctrl.hidesBottomBarWhenPushed = YES;
    ctrl.delegate = self;
    ctrl.type = 0;
    [self.navigationController pushViewController:ctrl animated:YES];
}
- (void)setNodataView {
    _bgview = [[UIView alloc]initWithFrame:CGRectMake(87, 180, 200, 202)];
    //_bgview.center = [self.view convertPoint:self.view.center fromView:self.view.superview];
    _bgview.hidden = self.dataArray.count;
    [self.view addSubview:_bgview];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 172)];
    imageView.image = [UIImage XYY_imageInKit:@"nodata"];
    
    [_bgview addSubview:imageView];
    UILabel *labelText = [[UILabel alloc]initWithFrame:CGRectMake(0, 182, 200, 15)];
    labelText.text = @"暂未开具药品，请点击下方按钮添加～";
    labelText.textColor = RGB(102, 102, 102);
    labelText.font = FONT(14);
    [labelText sizeToFit];
    labelText.textAlignment = NSTextAlignmentCenter;
    [_bgview addSubview:labelText];
}
//提交处方
- (void)onNext
{
    if (self.dataArray.count == 0) {
         [MBProgressHUD showError:@"请添加药品" toView:self.view];
        return;
    }
    NSMutableArray *numArray = [[NSMutableArray alloc]initWithCapacity:0];
    BOOL iscf=NO;
    for (int i =0; i<self.dataArray.count; i ++) {
        YaopinSearchListModel *model = self.dataArray[i];
        [numArray addObject:[NSString stringWithFormat:@"%ld",(long)model.number]];
        if (model.isShowColor) {
            iscf=YES;
        }
    }
    if (iscf) {
        [MBProgressHUD showError:@"您添加的药品重复，请核对后操作" toView:self.view];
        return;
    }
    if ([numArray containsObject:@"0"]) {
        [MBProgressHUD showError:@"请输入药品数量" toView:self.view];
        return;
    }
    submitPrescriptFreeMarkeCmd *cmd = [[submitPrescriptFreeMarkeCmd alloc]init];
    cmd.hospitalId = [ConfigUtil stringWithKey:HOSTPATIAL_ID];
    cmd.doctorName = [ConfigUtil stringWithKey:DOCTORNAME];
    cmd.primaryDiagnosis = self.chufangStr[@"primaryDiagnosis"];
    cmd.patientName = self.userStr[@"patientName"];
    cmd.sex = self.userStr[@"sex"];
    cmd.age=self.userStr[@"age"];
    cmd.telPhoneNum = self.userStr[@"telPhoneNum"];
    cmd.cardId=self.userStr[@"cardId"];
    for (YaopinSearchListModel*model in self.dataArray) {
       model.singleDosage = [NSString stringWithFormat:@"%@%@",[self getNumberFromStr:model.singleDosage],model.unitName];
    }
    NSArray *oppp = [self toArray:self.dataArray];
    cmd.list = oppp;
    
    cmd.loginType = 2;
    WS(weakSelf);
    [[HttpNetwork getInstance] request:cmd success:^(BaseRespond *respond) {
        [JumpUtil jumpPreview:weakSelf webstr:respond.data[@"result"] userinfo:weakSelf.userStr patientInfo:self.chufangStr Array:oppp];
        //[ConfigUtil setUserDefaults:oppp forKey:YPTOALT];
    } failed:^(BaseRespond *respond, NSString *error) {
        [MBProgressHUD showError:error toView:weakSelf.view];
    }];
}
//获取提交list
- (NSArray *)toArray:(NSArray*)theData{
    NSMutableArray *d=[[NSMutableArray alloc] init];
    for (YaopinSearchListModel *model in theData) {
        if (![model.singleDosage containsString:model.unitName]) {
           model.singleDosage= [NSString stringWithFormat:@"%@%@",model.singleDosage,model.unitName];
        }
        [d addObject:[model toDictionary]];
    }
    return [d copy];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    if (_YpEditView) {
        [self.YpEditView dismissView];
    }
    [[NSNotificationCenter defaultCenter ] removeObserver:self];
}
//- (void)onBack{
//    [super onBack];
//    NSArray *oppp = [self toArray:self.dataArray];
//    [ConfigUtil setUserDefaults:oppp forKey:YPTOALT];
//}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.dataArray.count) {
        return 50;
    }else{
        return 1;
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    view.backgroundColor = RGB(255, 255, 255);
   
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(8, 15, 180, 20)];
    label.font=[UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    label.text = @"医生推荐药物:";
    label.textColor=RGB(51, 51, 51);
    [view addSubview:label];
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake375(275, 10, 90, 30);
    [sureBtn setTitle:@"确认药品" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = FONT(14);
    [sureBtn setTitleColor:RGB(2, 175, 102) forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = CGRectGetHeight(sureBtn.frame)/2;
    sureBtn.layer.borderWidth = 1;
    sureBtn.layer.borderColor = RGB(2, 175, 102).CGColor;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sureBtn];
    if (_dataArray.count < 1) {
        label.hidden = YES;
    }else{
        label.text = [NSString stringWithFormat:@"本次药品种类共计:%ld",self.dataArray.count];
    }
    if ([[ConfigUtil stringWithKey:RELATIONTYPE] isEqualToString:@"0"]) {
        sureBtn.hidden = NO;
    }else{
        sureBtn.hidden = YES;
    }
    //线
    [ViewUtil setshadowColorToView:view];

    return view;
}
- (void)btnClick {
    if (self.dataArray.count <1) {
        [MBProgressHUD showError:@"您还没有选择药品" toView:self.view];
        return;
    }else{
        NSMutableArray *titleStrArray = [NSMutableArray new];
        for (YaopinSearchListModel *model in self.dataArray) {
            NSString *sureStr = [NSString stringWithFormat:@"%@ %@ %ld %@",model.commonName,model.packingRule,model.number,model.packageUnitName];
            [titleStrArray addObject:sureStr];
        }
        NSString *totalStr =[NSString stringWithFormat:@"请问 %@ 是否有？",[titleStrArray componentsJoinedByString:@","]];
        NIMSession *session = [NIMSession session:[ConfigUtil stringWithKey:LASTCHARTACCOUNT] type:NIMSessionTypeP2P];
        NIMMessage *message = [[NIMMessage alloc] init];
        message.text = totalStr;
        // 错误反馈对象
        NSError *error = nil;
        // 发送消息
        [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:&error];
        SessionViewController *sessionVC = [[SessionViewController alloc] initWithSession:session];
        sessionVC.hxAccount=[ConfigUtil stringWithKey:LASTCHARTACCOUNT];
        sessionVC.strTitle = [ConfigUtil stringWithKey:LASTCHARTYDNAME];
        sessionVC.isShowChufang = NO;
        sessionVC.isQueren=YES;
        sessionVC.hidesBottomBarWhenPushed = YES;
        sessionVC.relationType = [[ConfigUtil stringWithKey:RELATIONTYPE] integerValue];
        [self.navigationController pushViewController:sessionVC animated:YES];
    }
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//    CGFloat sectionHeaderHeight = 45;
//
//    // NSLog(@"%f,%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
//    if(scrollView == self.tableView){
//        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>= 0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//        }
//    }
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"editCell";
    YaopinSearchListModel*model = _dataArray[indexPath.row];
    YPEditCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[YPEditCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell reloadDataWithModel:model];
    
    WS(weakSelf);
    [cell setOnYPDelBlock:^{
       //删除
        [YLTAlertUtil presentAlertViewWithTitle:@"" message:@"是否删除药品" cancelTitle:@"取消" defaultTitle:@"确认" distinct:YES cancel:^{
            
        } confirm:^{
            [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationLeft];
            [weakSelf.tableView endUpdates];
            [weakSelf setData];
            [weakSelf.tableView reloadData];
        }];
        //[MBProgressHUD showSuccess:@"删除" toView:weakSelf.view];
      
    }];
    [cell setonWXBlock:^{
        YaopinSearchListModel *model = weakSelf.dataArray[indexPath.row];
        model.usageLevel = 1;
        weakSelf.model = model;
        
        _row = indexPath.row;
        [weakSelf.YpEditView setHidden:NO];
        weakSelf.YpEditView.model = weakSelf.model;
        
    }];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YaopinSearchListModel *model = self.dataArray[indexPath.row];
    self.model = model;
    _row = indexPath.row;
    [self.YpEditView setHidden:NO];
    self.YpEditView.model = self.model;
}
#pragma mark 网络请求
-(void)setData{
//    [MBProgressHUD showMessag:@"" toView:self.view];
    _bgview.hidden = self.dataArray.count;
    //self.dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    _tableView.hidden = !self.dataArray.count;
   
//    WS(weakSelf);
//    [NSGCDThread dispatchAfterInMailThread:^{
//        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
////        weakSelf.dataArray=[[NSMutableArray alloc] initWithObjects:self.model, nil];
//
////        CGFloat h=(weakSelf.dataArray.count*190+50)>(SCREEN_HEIGHT-TITLE_HEIGHT_WITH_BAR-61-34)?(SCREEN_HEIGHT-TITLE_HEIGHT_WITH_BAR-61-34):(weakSelf.dataArray.count*190+50);
////        weakSelf.tableViewH.constant=h;
//        for (int i=0;i<_dataArray.count;i++) {
//            YaopinSearchListModel*models=[_dataArray objectAtIndex:i];
//            NSArray *typeGoodArray=[weakSelf.dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@" self.commonName==%@ and self.packingRule==%@" , models.commonName,models.packingRule]];
//            if(typeGoodArray.count>1){
//                models.isShowColor  = YES;
//            }else{
//                models.isShowColor = NO;
//            }
//            [_dataArray replaceObjectAtIndex:i
//                                withObject:models];
//        }
//
//        [weakSelf.tableView reloadData];
//    } Delay:15];
}
//提交处方单
-(void)netSumbitOrder:(NSString *)shuoming{
    [self.navigationController popToViewController:[self.navigationController.childViewControllers objectAtIndex:self.navigationController.childViewControllers.count-2] animated:NO];
}

#pragma mark UI界面
-(YaopinEditView*)YpEditView{
    if (!_YpEditView) {
        _YpEditView=[JumpUtil loadFromXib:@"YaopinEditView" withCls:[YaopinEditView class]];
        //YaopinSearchListModel *model = self.dataArray[_row];
        //_YpEditView.model = self.model;
        WS(weakSelf);
        [_YpEditView setONYpEditOKBlock:^(int num,NSString *singleDosage,NSString*unitName,  NSString *yypc, NSString *fyff, NSString *day,NSString*ypbz) {
            //点击确定后
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.row inSection:0];
            YPInChufangCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
            YaopinSearchListModel*model = weakSelf.dataArray[weakSelf.row];
            weakSelf.model.number = num;
            weakSelf.model.singleDosage = singleDosage;
            weakSelf.model.unitName = unitName;
            weakSelf.model.useFunction = fyff;
            weakSelf.model.directions = yypc;
            weakSelf.model.directionsTime = [day integerValue];
            model.extraTotal  = num *[model.extractPrice integerValue];
            model.singleDosage=singleDosage;
            weakSelf.model.remark = ypbz;
            [cell reloadDataWithModel:model];
            [weakSelf.tableView reloadData];
        }];
        [_YpEditView showView];
    }
    return _YpEditView;
}

#pragma mark 点击事件
- (IBAction)onSumbit:(id)sender {
//    MyTextViewAlertView* alert = [[MyTextViewAlertView alloc] initWithTitleName:@"其他说明"];
//    [alert setTextValue:@"" PlaceHolder:@"请输入其他说明(可为空)"];
//    WS(weakSelf);
//    [alert setEditor:^(NSString * sign) {
//        //取消订单
//        [weakSelf netSumbitOrder:sign];
//    }];
//    [alert show];
    HZMoBanTableViewController *VC = [[HZMoBanTableViewController alloc]init];
    VC.delegate = self;
    [self.navigationController pushViewController:VC animated:YES];
    
}
- (void)passValue:(NSArray *)mobanArray{
    
    NSLog(@"%@",[mobanArray[0] class]);
    for (int i = 0; i<mobanArray.count; i++) {
        YaopinSearchListModel *model = [[YaopinSearchListModel alloc]initWithDictionary:mobanArray[i]];
        model.extraTotal  = model.number *[model.extractPrice integerValue];
        [self.dataArray addObject:model];
    }
    [self setData];
    [self.tableView reloadData];
}
- (void)reloadView: (NSNotification *)sender
{
    //这里Sender有一个属性就是object,这个就是所传过来的值.本文中为array这个数组.
    NSArray *mobanArray = sender.object;
    for (int i = 0; i<mobanArray.count; i++) {
        YaopinSearchListModel *model = [[YaopinSearchListModel alloc]initWithDictionary:mobanArray[i]];
        model.extraTotal  = model.number *[model.extractPrice integerValue];
        [self.dataArray addObject:model];
    }
    for (int i=0;i<_dataArray.count;i++) {
        YaopinSearchListModel*models=[_dataArray objectAtIndex:i];
        NSArray *typeGoodArray=[_dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@" self.commonName==%@ and self.packingRule==%@" , models.commonName,models.packingRule]];
        if(typeGoodArray.count>1){
            [_dataArray removeObjectAtIndex:i];
        }
    }
    [self setData];
    [self.tableView reloadData];
}
- (NSString *)getNumberFromStr:(NSString *)str{
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return[[str componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}

//历史处方的delegate
-(void)getHZDruggist:(NSArray *)modelArray model:(id)model{
    for (int i = 0; i<modelArray.count; i++) {
        YaopinSearchListModel *model = [[YaopinSearchListModel alloc]initWithDictionary:modelArray[i]];
       //model.extraTotal  = model.number *[model.extractPrice integerValue];
        [self.dataArray addObject:model];
    }
    [self setData];
    [self.tableView reloadData];
}
- (IBAction)onAdd:(id)sender {
    HZKaiCFSearchYPController *ctrl=[[HZKaiCFSearchYPController alloc] init];
    UINavigationController *nv=[[UINavigationController alloc] initWithRootViewController:ctrl];
    ctrl.delegate = self;
    [self presentViewController:nv animated:YES completion:nil];
}
- (void)changeText:(YaopinSearchListModel *)model
{
    self.model = model;
    model.extraTotal  = model.number *[model.extractPrice integerValue];
    
    [self.dataArray addObject:self.model];
    for (int i=0;i<_dataArray.count;i++) {
        YaopinSearchListModel*models=[_dataArray objectAtIndex:i];
        NSArray *typeGoodArray=[_dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@" self.commonName==%@ and self.packingRule==%@" , models.commonName,models.packingRule]];
        if(typeGoodArray.count>1){
            [_dataArray removeObjectAtIndex:i];
            [MBProgressHUD showError:@"您添加的药品已存在，请重新选择" toView:self.view];
        }
    }
    [self setData];
    [self.tableView reloadData];
}
@end
