//
//  HuanzheHomeController.m
//  yaolianti
//
//  Created by huangliwen on 2018/6/6.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "HuanzheHomeController.h"
#import "NetPageStruct.h"
#import "MJRefresh.h"
#import "ImageUtil.h"
#import "HuanzheCmd.h"
#import "SessionViewController.h"
#import "ChufangHomeController.h"
#import "ViewUtil.h"
#import "MyAlertView.h"
#import "UIView+hlwCate.h"
#import "UserCmd.h"
#import "NTESNotificationCenter.h"
#import "BSYTextFiled.h"
#import "HlwTextField.h"
#import "HlwTextView.h"
#import "YLTAlertUtil.h"
#import "StringUtil.h"
#import "HuanzheStruce.h"
#import "HuanZheWithMessageDBStruce.h"
#import "HLWSelectTimeGyq.h"
#import "HZHistoryPrescriptionTableViewController.h"
#import "RecordStruce.h"
#import "XYYDoctorSDK.h"
@interface HuanzheHomeController ()<UITextFieldDelegate,UITextViewDelegate,NIMChatManagerDelegate,HZHistoryPrescriptionDelegate>
{
     UILabel*tishilabel;
     UILabel*tishilabelnet;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) PageParams* pageParams;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet HlwTextView *zhenduanTextView;
//@property (weak, nonatomic) IBOutlet UITextView *optionTextView;
@property (weak, nonatomic) IBOutlet HlwTextView *optionTextView;
@property (weak, nonatomic) IBOutlet UIButton *boyBtn;
@property (weak, nonatomic) IBOutlet UIButton *girlBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet HlwTextField *huanzheNameTF;

@property (weak, nonatomic) IBOutlet UITextField *sexTF;
@property (weak, nonatomic) IBOutlet HlwTextField *ageTF;

//@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet HlwTextField *phoneTF;

@property (weak, nonatomic) IBOutlet BSYTextFiled *numTF;
@property (weak, nonatomic) IBOutlet HlwTextField *guominshiTF;

@property (weak, nonatomic) IBOutlet HlwTextField *zhusuTF;

@property (weak, nonatomic) IBOutlet UIButton *btnCloseWenzhen;
@property (weak, nonatomic) IBOutlet UIButton *btnKaichufang;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;

@property (weak, nonatomic) IBOutlet UIView *fzView;
@property (weak, nonatomic) IBOutlet UITextField *fzTxt;
@property (weak, nonatomic) IBOutlet UIImageView *IconImageView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *healthBtn;

@property (strong, nonatomic) UIButton *restBtn;
@property (strong, nonatomic) UIButton *meassageBtn;
@property (weak, nonatomic) UILabel *unReadCommentLabel;
@property (assign, nonatomic) NSInteger unReadCommentNum;
@property (nonatomic,copy)NSString *doctorStatus;
@property (nonatomic,copy)NSString *sexnName;
@property (weak, nonatomic) UIImageView *unReadCommentImage;//消息未读
@property (nonatomic,weak)UIButton *selectedBtn;
@property (nonatomic,strong) HLWSelectTimeGyq *selectDateView;
@property (nonatomic,strong) NSArray *ypArray;
@end
@implementation HuanzheHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[ConfigUtil stringWithKey:RELATIONTYPE] isEqualToString:@"1"]) {
        self.huanzheNameTF.text = [ConfigUtil stringWithKey:LASTCHARTYDNAME];
        self.phoneTF.text = [ConfigUtil stringWithKey:PHONENUM];
        [self motionGetPationInfo];
    }else{
    }
    //[self setShadoff:CGSizeMake(0, 2) withColor:RGBA(202, 202, 202, 0.5)];
    _tipLabel.textColor = RGB(145, 145, 145);
    NSString *calorStr = [NSString stringWithFormat:@"%@",[ConfigUtil stringWithKey:LASTCHARTYDNAME]];
    NSString *beanStr = [NSString stringWithFormat:@"正在为%@提供处方",calorStr];
    NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString: beanStr];
    [attrDescribeStr addAttribute:NSForegroundColorAttributeName
                            value:RGB(2, 175, 102)
     
                            range:[beanStr rangeOfString:calorStr]];
    self.tipLabel.attributedText = attrDescribeStr;
    _nameLabel.text = calorStr;
    [self setupTitleWithString:beanStr];
    [self setupBack];
    
    _infoBtn.layer.cornerRadius = 5;
    _infoBtn.layer.masksToBounds=YES;
    _ageTF.keyboardType = UIKeyboardTypeNumberPad;
    _zhusuTF.tag = 11;
    _zhusuTF.delegate = self;
    _guominshiTF.tag = 12;
    _guominshiTF.delegate = self;
    //身份者键盘
    [self.numTF addViewWithKeyBoardType:BSYIDCardType];
    [self.numTF setShowKeyBoardBackColor:LINE_COLOR];
    [self.numTF setShowKeyBoardToolBarFinshinedBtnTitleColor:HexRGB(0x137ffe)];
    [self.numTF setShowKeyBoardToolBarBackColor:HexRGB(0xeeeeee)];
    
    [self.view setBackgroundColor:BACKGOUND_COLOR];
    [self.tableView setBackgroundColor:BACKGOUND_COLOR];
    [self.bgView setBackgroundColor:BACKGOUND_COLOR];

    [ViewUtil setshadowColorToView:self.zhenduanTextView];
    _sexTF.delegate = self;
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;

    [_tableView reloadData];
    _zhenduanTextView.delegate= self;
    _optionTextView.delegate = self;
    tishilabel =[[UILabel alloc] initWithFrame:CGRectMake375(0, 6, 230, 25)];
    tishilabel.text = @"请输入初步诊断";
    tishilabel.font=[UIFont systemFontOfSize:14];
    tishilabel.textColor= RGB(153, 153, 153);
    [_zhenduanTextView addSubview:tishilabel];
    _zhenduanTextView.tag = 101;
    tishilabelnet =[[UILabel alloc] initWithFrame:CGRectMake375(0, 6, 230, 25)];
    tishilabelnet.text = @"请输入诊疗意见";
    tishilabelnet.font=[UIFont systemFontOfSize:14];
    tishilabelnet.textColor= RGB(153, 153, 153);
    [_optionTextView addSubview:tishilabelnet];
    _optionTextView.tag = 102;

    self.sexTF.inputView=[[UIView alloc] init];
    self.sexTF.inputView.hidden=YES;
    _sexnName = @"男";
    
    //复诊输入框
    _fzTxt.inputView = [[UIView alloc]init];
    _fzTxt.inputView.hidden = YES;
    _fzTxt.tag = 108;
    _fzTxt.delegate = self;
    
    //按钮样式
    _btnCloseWenzhen.layer.cornerRadius=_btnCloseWenzhen.height/2;
    _btnCloseWenzhen.layer.masksToBounds=YES;
    [ViewUtil setJianbianToView:_btnCloseWenzhen colorType:JianBianOrange frame:CGRectMake(0, 0, SCREEN_HEIGHT/5*2, _btnCloseWenzhen.height)];
    
    _btnKaichufang.layer.cornerRadius=CGRectGetHeight(_btnKaichufang.frame)/2;
    _btnKaichufang.layer.shadowOffset =  CGSizeMake(0, 2);
    _btnKaichufang.layer.shadowOpacity = 0.41;
    _btnKaichufang.layer.shadowColor =  RGBA(66,150,115,0.41).CGColor;
    _btnKaichufang.backgroundColor = RGB(2, 175, 102);

    [self registerForKeyboardNotifications];
    [_boyBtn setImage:[UIImage XYY_imageInKit:@"sex_n"] forState:UIControlStateNormal];
    [_boyBtn setImage:[UIImage XYY_imageInKit:@"sex_h"] forState:UIControlStateSelected];
    _boyBtn.tag = 100;
    _girlBtn.tag = 101;
    [_girlBtn setImage:[UIImage XYY_imageInKit:@"sex_n"] forState:UIControlStateNormal];
    [_girlBtn setImage:[UIImage XYY_imageInKit:@"sex_h"] forState:UIControlStateSelected];
    [self setOnView];
    // 去掉通知角标
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
- (void)onBack {
  
    if (_selectedBtn&&_selectedBtn.selected == YES) {
        if (_selectedBtn.tag == 100) {
            _sexnName = @"男";
        }else{
            _sexnName = @"女";
        }
    }else{
        
    }
    HuanZheWithMessageDBStruce *usermodel = [HuanZheWithMessageDBStruce getPatienInfoWithHXAcountId:[ConfigUtil stringWithKey:LASTCHARTACCOUNT]];
    
    NSLog(@"-=======返回的model%@",usermodel);
    NSString *sexString = [_sexnName isEqualToString:@"男"]?@"1":@"0";
    HuanZheWithMessageDBStruce *model = [[HuanZheWithMessageDBStruce alloc]init];
    model.HXAcountId = [ConfigUtil stringWithKey:LASTCHARTACCOUNT];

        model.telPhoneNum = _phoneTF.text;
   
        model.name = _huanzheNameTF.text;
    
        model.age = _ageTF.text;

        model.cardId = _numTF.text;
   
        model.allergyRecord = _guominshiTF.text;
 
        model.mainSuit = _zhusuTF.text;
    
        model.chubuzhenduan = _zhenduanTextView.text;

        model.option = _optionTextView.text;
        model.sex = sexString;
        [model saveToDB];
        [super onBack];
}
-(void)onSaveUserInfoMessage{
    if (_selectedBtn&&_selectedBtn.selected == YES) {
        if (_selectedBtn.tag == 100) {
            _sexnName = @"男";
        }else{
            _sexnName = @"女";
        }
    }else{
        
    }
    NSString *sexString = [_sexnName isEqualToString:@"男"]?@"1":@"0";
    HuanZheWithMessageDBStruce *model = [[HuanZheWithMessageDBStruce alloc]init];
    model.HXAcountId = [ConfigUtil stringWithKey:LASTCHARTACCOUNT];
    
    model.telPhoneNum = _phoneTF.text;
    
    model.name = _huanzheNameTF.text;
    
    model.age = _ageTF.text;
    
    model.cardId = _numTF.text;
    
    model.allergyRecord = _guominshiTF.text;
    
    model.mainSuit = _zhusuTF.text;
    
    model.chubuzhenduan = _zhenduanTextView.text;
    
    model.option = _optionTextView.text;
    model.sex = sexString;
    [model saveToDB];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)setOnView{
    WS(weakSelf);
    [self.zhusuTF setOnTextDoneBlock:^(NSString *text) {
        [weakSelf.zhenduanTextView becomeFirstResponder];
    }];
}
#pragma mark 通知相关
- (void)registerForKeyboardNotifications {
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
- (IBAction)boyClick:(UIButton *)btn {
    if (btn!= self.selectedBtn) {
        self.selectedBtn.selected = NO;
        btn.selected = YES;
        self.selectedBtn = btn;
    }else{
        self.selectedBtn.selected = YES;
    }
}

- (IBAction)girlClick:(UIButton*)btn{
    if (btn!= self.selectedBtn) {
        self.selectedBtn.selected = NO;
        btn.selected = YES;
        self.selectedBtn = btn;
    }else{
        self.selectedBtn.selected = YES;
    }
}

-(void)dealloc{
    //移除键盘通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:UIKeyboardWillHideNotification];
    //云信消息回调
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    self.ypArray = nil;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.contentOffset=CGPointMake(0, 0);
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 300, 0);
    self.tableView.contentOffset=CGPointMake(0, 200);
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag == 101) {
        if (textView.text.length == 0) {
            tishilabel.text = @"请输入初步的诊断";
        }else{
            tishilabel.text = @"";
        }
    }else{
        if (textView.text.length == 0) {
            tishilabelnet.text = @"请输入诊疗意见";
        }else{
            tishilabelnet.text = @"";
        }
    }
}

#pragma mak 生命周期
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//状态栏
     self.tabBarController.tabBar.hidden = YES;
    if ([ConfigUtil intWithtegerKey:REVIEW] == 1) {
        _fzView.hidden = NO;
    }else{
        _fzView.hidden = YES;
    }
    if ([ConfigUtil intWithtegerKey:PROVINCE] == 430000){
        if ([[ConfigUtil stringWithKey:RELATIONTYPE] isEqualToString:@"1"]) {
            self.huanzheNameTF.text = [ConfigUtil stringWithKey:LASTCHARTYDNAME];
            self.phoneTF.text = [ConfigUtil stringWithKey:PHONENUM];
            _healthBtn.hidden = NO;
        }else{
            _healthBtn.hidden = YES;
        }
    }else{
        _healthBtn.hidden = YES;
    }
    
    HuanZheWithMessageDBStruce *model = [HuanZheWithMessageDBStruce getPatienInfoWithHXAcountId:[ConfigUtil stringWithKey:LASTCHARTACCOUNT]];
    NSLog(@"%@",[ConfigUtil stringWithKey:LASTCHARTACCOUNT]);
    if (!model) {
        return;
    }else{
        _huanzheNameTF.text =model.name ;
        _phoneTF.text =  model.telPhoneNum ;
        _ageTF.text= model.age;
        _numTF.text = model.cardId;
        _guominshiTF.text = model.allergyRecord;
        _zhusuTF.text = model.mainSuit;
        if ([model.sex isEqualToString:@"1"]) {
            _boyBtn.selected = YES;
            _selectedBtn = _boyBtn;
        }else{
            _girlBtn.selected = YES;
            _selectedBtn = _girlBtn;
        }
        if (IS_EMPTY(model.chubuzhenduan)) {
        }else{
            tishilabel.text = @"";
        }
        if (IS_EMPTY(model.option)) {
            
        }else{
            tishilabelnet.text = @"";
        }
        _zhenduanTextView.text = model.chubuzhenduan;
        _optionTextView.text = model.option;
    }
   
    self.restBtn.selected=NO;
    _tipLabel.textColor = RGB(145, 145, 145);
    NSString *calorStr = [NSString stringWithFormat:@"%@",[ConfigUtil stringWithKey:LASTCHARTYDNAME]];
    NSString *beanStr = [NSString stringWithFormat:@"正在为%@提供处方",calorStr];
    NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString: beanStr];
    [attrDescribeStr addAttribute:NSForegroundColorAttributeName
     
                            value:RGB(2, 175, 102)
     
                            range:[beanStr rangeOfString:calorStr]];
    self.tipLabel.attributedText = attrDescribeStr;
    

}
#pragma mark - Table view data source

#pragma mark 点击事件
- (IBAction)kaichufangClick:(id)sender {
    if (_selectedBtn&&_selectedBtn.selected == YES) {
        if (_selectedBtn.tag == 100) {
            _sexnName = @"男";
        }else{
            _sexnName = @"女";
        }
    }else{
    }
    if (IS_EMPTY(_phoneTF.text)) {
        [MBProgressHUD showError:@"请输入手机号码" toView:self.view];
        return;
    }
    if (IS_EMPTY(_huanzheNameTF.text)) {
        [MBProgressHUD showError:@"请输入患者姓名" toView:self.view];
        return;
    }
    if (IS_EMPTY(_sexnName)) {
         [MBProgressHUD showError:@"请选择性别" toView:self.view];
        return;
    }if (IS_EMPTY(_ageTF.text)) {
         [MBProgressHUD showError:@"请输入患者年龄" toView:self.view];
        return;
    }if (IS_EMPTY(_guominshiTF.text)) {
         [MBProgressHUD showError:@"请填写患者过敏史" toView:self.view];
        return;
    }if (IS_EMPTY(_zhusuTF.text)) {
         [MBProgressHUD showError:@"请填写患者主诉意见" toView:self.view];
        return;
    }if (IS_EMPTY(_zhenduanTextView.text)) {
         [MBProgressHUD showError:@"请填写诊断意见" toView:self.view];
        return;
    }if (![StringUtil validateMobile:_phoneTF.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号" toView:self.view];
        return;
    }if (IS_EMPTY(_optionTextView.text)) {
        _optionTextView.text = @"无";
    }if (![StringUtil validateAge:_ageTF.text]) {
        [MBProgressHUD showError:@"您输入的年龄不对" toView:self.view];
        return;
    }
    
    if ([_ageTF.text integerValue] <=6) {
        [MBProgressHUD showError:@"年龄必须大于六岁" toView:self.view];
        return;
    }
    NSString *sexString = [_sexnName isEqualToString:@"男"]?@"1":@"0";
    HuanZheWithMessageDBStruce *model = [[HuanZheWithMessageDBStruce alloc]init];
    model.HXAcountId = [ConfigUtil stringWithKey:LASTCHARTACCOUNT];
    
    model.name = _huanzheNameTF.text;
    
    model.telPhoneNum = _phoneTF.text;
    
    model.age = _ageTF.text;
    
    model.cardId = _numTF.text;
    
    model.allergyRecord = _guominshiTF.text;
    
    model.mainSuit = _zhusuTF.text;
    
    model.chubuzhenduan = _zhenduanTextView.text;
    
    model.option = _optionTextView.text;
    model.sex = sexString;
    [model saveToDB];
    
    NSDictionary *dict1 = @{@"hxLoginAccount":[ConfigUtil stringWithKey:LASTCHARTACCOUNT],@"storeId":[ConfigUtil stringWithKey:STOREID],@"patientName":_huanzheNameTF.text,@"telPhoneNum":_phoneTF.text,@"age":_ageTF.text,@"sex":sexString,@"allergyRecord":_guominshiTF.text,@"cardId":_numTF.text};
    NSDictionary *dict2 = @{@"primaryDiagnosis":_zhenduanTextView.text,@"diagnosisIdea":_optionTextView.text,@"mainSuit":_zhusuTF.text,@"visitDate":_fzTxt.text};
    NIMSession *session = [NIMSession session:[ConfigUtil stringWithKey:LASTCHARTACCOUNT] type:NIMSessionTypeP2P];
    NIMMessage *message = [[NIMMessage alloc]init];
    message.text = @"去开处方中…请稍后";
    NSError *error = nil;
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:&error];
    if (self.ypArray.count>0) {
        [ConfigUtil setUserDefaults:@[] forKey:SAVE_YP_ARRAY];
    }
    [JumpUtil pushHZKaiChufangYp:self userStr:dict1 chufangStr:dict2 ypArray:self.ypArray];
}
- (IBAction)fuClick:(id)sender {
     WS(weakSelf);
    [weakSelf.selectDateView show];
    [weakSelf.selectDateView setOnDoneBlock:^(NSString *time) {
        _fzTxt.text = time;
    }];
}

//复诊时间
-(HLWSelectTimeGyq *)selectDateView{
    if (!_selectDateView) {
        _selectDateView=[[HLWSelectTimeGyq alloc] init];
        //        WS(weakSelf);
        //        [_selectDateView setOnDoneBlock:^(NSString *time) {
        //        }];
    }
    return _selectDateView;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    WS(weakSelf);
    if (textField.tag == 11) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 300, 0);
        self.tableView.contentOffset=CGPointMake(0, 200);
    }else if (textField.tag == 12){
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 300, 0);
        self.tableView.contentOffset=CGPointMake(0, 200);
    }else if (textField.tag== 108) {
        [weakSelf.selectDateView show];
        [weakSelf.selectDateView setOnDoneBlock:^(NSString *time) {
            _fzTxt.text = time;
        }];
    }
    else{
    }
}

- (void)messageClick{
    //消息点击
    //构造会话
    NIMSession *session = [NIMSession session:[ConfigUtil stringWithKey:LASTCHARTACCOUNT] type:NIMSessionTypeP2P];
    SessionViewController *sessionVC = [[SessionViewController alloc] initWithSession:session];
    sessionVC.strTitle=[ConfigUtil stringWithKey:LASTCHARTYDNAME];
    [self.navigationController pushViewController:sessionVC animated:YES];
}

#pragma mark 网络请求
- (IBAction)click:(id)sender {
    WS(weakSelf);
    [JumpUtil pushDiagnoseVC:self block:^(NSString *diagnoseStr) {
        weakSelf.zhenduanTextView .text = diagnoseStr;
        HuanZheWithMessageDBStruce *model = [HuanZheWithMessageDBStruce getPatienInfoWithHXAcountId:[ConfigUtil stringWithKey:LASTCHARTACCOUNT]];
        model.chubuzhenduan = weakSelf.zhenduanTextView.text;
        model.name = _huanzheNameTF.text;
        
        model.telPhoneNum = _phoneTF.text;
        
        model.age = _ageTF.text;
        
        model.cardId = _numTF.text;
        
        model.allergyRecord = _guominshiTF.text;
        
        model.mainSuit = _zhusuTF.text;
        model.option = _optionTextView.text;
        [model saveToDB];
        tishilabel.text = @"";
    }];
}

- (IBAction)getPationInfo:(id)sender {
  if (IS_EMPTY(_phoneTF.text)) {
        [MBProgressHUD showError:@"请输入手机号码" toView:self.view];
        return;
    }
    if (![StringUtil validateMobile:_phoneTF.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号码" toView:self.view];
        return;
    }
    GetPatientInfoCmd *cmd = [[GetPatientInfoCmd alloc]init];
    cmd.telPhoneNum = _phoneTF.text;
    cmd.relationType = [[ConfigUtil stringWithKey:RELATIONTYPE] integerValue];
    WS(weakSelf);
    [[HttpNetwork getInstance] request:cmd success:^(BaseRespond *respond) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        NSArray *ifonArray =respond.data[@"result"];
        if (![ifonArray count]) {
             [MBProgressHUD showError:@"无上次诊断记录" toView:self.view];
            return ;
        }
       NSDictionary *dict = ifonArray[0];
       PatientionInfoModel*model = [[PatientionInfoModel alloc]initWithDictionary:dict];
        if (model.sex ==1) {
            _boyBtn.selected = YES;
            _selectedBtn = _boyBtn;
        }if (model.sex ==0) {
            _girlBtn.selected = YES;
            _selectedBtn = _girlBtn;
        }if (model.sex == 2) {
            //sex = @"未设置";
        }
        if (![StringUtil QX_NSStringIsNULL:model.patientName]) {
           weakSelf.huanzheNameTF.text =dict[@"patientName"];
        }
//        if ([dict[@"patientName"] isKindOfClass:[NSNull class]]) {
//            //[MBProgressHUD showError:@"无上次诊断记录" toView:self.view];
//        }else{
//            weakSelf.huanzheNameTF.text =dict[@"patientName"];
//        }
        if ([dict[@"age"] isKindOfClass:[NSNull class]]) {
            //[MBProgressHUD showError:@"无上次诊断记录" toView:self.view];
        }else{
            self.ageTF.text = [NSString stringWithFormat:@"%ld",[dict[@"age"] integerValue]] ;
        }
        if ([dict[@"mainSuit"] isKindOfClass:[NSNull class]]) {
            [MBProgressHUD showError:@"无上次诊断记录" toView:self.view];
        }else{
            weakSelf.zhusuTF.text =dict[@"mainSuit"];
        }
        if ([dict[@"cardId"] isKindOfClass:[NSNull class]]) {
            
        }else{
            weakSelf.numTF.text =dict[@"cardId"];
        }
        if ([dict[@"allergyRecord"] isKindOfClass:[NSNull class]]) {
            
        }else{
            weakSelf.guominshiTF.text =dict[@"allergyRecord"];
        }
        
        if ([dict[@"primaryDiagnosis"] isKindOfClass:[NSNull class]]) {
            
        }else{
            weakSelf.zhenduanTextView.text =dict[@"primaryDiagnosis"];
            tishilabel.text =@"";
            
        }
        
        if ([dict[@"diagnosisIdea"] isKindOfClass:[NSNull class]]) {
            
        }else{
            weakSelf.optionTextView.text =dict[@"diagnosisIdea"];
            tishilabelnet.text = @"";
        }

    } failed:^(BaseRespond *respond, NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
        if(!IS_EMPTY(error))
            [MBProgressHUD showError:error toView:weakSelf.view];
    }];
}
- (IBAction)zhusuClick:(id)sender {
    WS(weakSelf);
    [JumpUtil pushZSVC:self block:^(NSString *zhusuStr) {
        weakSelf.zhusuTF .text = zhusuStr;
        HuanZheWithMessageDBStruce *model = [HuanZheWithMessageDBStruce getPatienInfoWithHXAcountId:[ConfigUtil stringWithKey:LASTCHARTACCOUNT]];
        model.mainSuit = weakSelf.zhusuTF.text;
        
        model.name = _huanzheNameTF.text;
        
        model.telPhoneNum = _phoneTF.text;
        
        model.age = _ageTF.text;
        
        model.cardId = _numTF.text;
        
        model.allergyRecord = _guominshiTF.text;
        
        model.chubuzhenduan = _zhenduanTextView.text;
        model.option = _optionTextView.text;
        [model saveToDB];
        tishilabel.text = @"";
    }];
}
//自动获取病人的信息
- (void)motionGetPationInfo{
    GetPatientInfoCmd *cmd = [[GetPatientInfoCmd alloc]init];
//    cmd.hxLoginAccount = [ConfigUtil stringWithKey:LASTCHARTACCOUNT];
    cmd.telPhoneNum = [ConfigUtil stringWithKey:PHONENUM];
     cmd.relationType = [[ConfigUtil stringWithKey:RELATIONTYPE] integerValue];
    [MBProgressHUD showMessag:@"" toView:self.view];
    WS(weakSelf);
    [[HttpNetwork getInstance] request:cmd success:^(BaseRespond *respond) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        NSArray *ifonArray =respond.data[@"result"];
        if (![ifonArray count]) {
            [MBProgressHUD showError:@"无上次诊断记录" toView:self.view];
            return ;
        }
        NSDictionary *dict = ifonArray[0];
        PatientionInfoModel*model = [[PatientionInfoModel alloc]initWithDictionary:dict];
        NSString *sex;
        if ([StringUtil QX_NSStringIsNULL:model.cardId]) {
            _numTF.text = @"";
        }else{
            _numTF.text = model.cardId;
        }
        if ([StringUtil QX_NSStringIsNULL:model.allergyRecord]) {
            _guominshiTF.text = @"无";
        }else{
            _guominshiTF.text = model.allergyRecord;
        }
        if ([StringUtil QX_NSStringIsNULL:model.address]) {
            model.address = @"无";
        }else{
            
        }
        if (model.sex ==1) {
            _boyBtn.selected = YES;
            _selectedBtn = _boyBtn;
        }if (model.sex ==0) {
            _girlBtn.selected = YES;
            _selectedBtn = _girlBtn;
        }if (model.sex == 2) {
            sex = @"未设置";
        }
        if (model.age ==0) {
           _ageTF.text = @"";
        }else{
            _ageTF.text = [NSString stringWithFormat:@"%ld",(long)model.age];
        }
        if ([StringUtil QX_NSStringIsNULL:model.mainSuit]) {
            _zhusuTF.text = @"无";
        }else{
            _zhusuTF.text = model.mainSuit;
        }if ([StringUtil QX_NSStringIsNULL:model.primaryDiagnosis]) {
            _zhenduanTextView.text = @"无";
            tishilabel.text = @"";
        }else{
            _zhenduanTextView.text = model.primaryDiagnosis;
            tishilabel.text = @"";
        }if ([StringUtil QX_NSStringIsNULL:model.diagnosisIdea]) {
            _optionTextView.text = @"无";
            tishilabelnet.text = @"";
        }else{
            _optionTextView.text = model.diagnosisIdea;
            tishilabelnet.text = @"";
        }
    } failed:^(BaseRespond *respond, NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
        if(!IS_EMPTY(error))
            [MBProgressHUD showError:error toView:weakSelf.view];
    }];
}
//健康档案
- (IBAction)healthClick:(id)sender {
    [ConfigUtil saveString:_huanzheNameTF.text withKey:LASTCHARTYDNAME];
    [ConfigUtil saveString:_phoneTF.text withKey:PHONENUM];
    [JumpUtil pushHZXueya:self userMessage:@""];
}
//历史处方
- (IBAction)historycf:(id)sender {
    [ConfigUtil saveString:_huanzheNameTF.text withKey:LASTCHARTYDNAME];
    [ConfigUtil saveString:_phoneTF.text withKey:PHONENUM];
    [self onSaveUserInfoMessage];
    NSString *BundlePath = [FileUtil getSDKResourcesPath];
    NSBundle *sampleBundle = [NSBundle bundleWithPath:BundlePath];
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Huanzhe" bundle:sampleBundle];
    HZHistoryPrescriptionTableViewController* ctrl = [story instantiateViewControllerWithIdentifier:@"historyPre"];
    ctrl.hidesBottomBarWhenPushed = YES;
    ctrl.delegate = self;
    ctrl.type =0;
    [self.navigationController pushViewController:ctrl animated:YES];
}
- (void)getHZDruggist:(NSArray *)modelArray model:(ChufangRecordModel *)model
{
    if (model) {
        _zhusuTF.text = model.mainSuit;
        self.ypArray = modelArray;
        _zhenduanTextView .text= model.primaryDiagnosis;
         HuanZheWithMessageDBStruce *modelStruce = [HuanZheWithMessageDBStruce getPatienInfoWithHXAcountId:[ConfigUtil stringWithKey:LASTCHARTACCOUNT]];
        modelStruce.mainSuit = _zhusuTF.text;
        modelStruce.chubuzhenduan = _zhenduanTextView.text;
        tishilabel.text = @"";
        [modelStruce updateToDB];
    }
}
-(void)viewDidLayoutSubviews{
    if (self.view.bounds.size.height<(SCREEN_HEIGHT-TITLE_HEIGHT_WITH_BAR)) {
        //切换到页面时因为统一用一个navigationController在绘制view的时候会去掉navigationController的高度64所以要加上64
        CGRect frame=[self.view frame];
        frame.size.height=SCREEN_HEIGHT-TITLE_HEIGHT_WITH_BAR;
        self.view.frame=frame;
    }
}

@end
