//
//  DoctorSelectMoBanViewController.m
//  yaolianti
//
//  Created by qxg on 2018/10/16.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "DoctorSelectMoBanViewController.h"
#import "HlwTextField.h"
#import "YPInChufangCell.h"
#import "HZKaiCFSearchYPController.h"
#import "YaopinEditView.h"

#import "HuanzheCmd.h"
#import "YLTAlertUtil.h"
#import "YaopinEditView.h"
#import "XYYDoctorSDK.h"
@interface DoctorSelectMoBanViewController ()<UITableViewDelegate,UITableViewDataSource,WJSecondViewControllerDelegate>
@property (weak, nonatomic) IBOutlet HlwTextField *nameTF;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewH;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong) YaopinSearchListModel*model;
@property (weak, nonatomic) IBOutlet UIButton *XYBtn;
@property (weak, nonatomic) IBOutlet UIButton *ZYBtn;
@property(nonatomic,strong)YaopinEditView *YpEditView;
@property (nonatomic,assign) NSInteger row;
//记录状态的按钮
@property (strong,nonatomic)UIButton * tmpBtn;
@end

@implementation DoctorSelectMoBanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBack];
  
    if (self.listModel) {
          [self setupTitleWithString:@"修改模板"];
    }else{
        [self setupTitleWithString:@"新增模板"];
    }
    [self setupNextWithString:@"完成" withColor:RGB(2, 175, 102)];
    self.view.backgroundColor = RGB(245, 245, 245);
    self.myTableView.backgroundColor = RGB(245, 245, 245);
    self.sureBtn.layer.cornerRadius = CGRectGetHeight(self.sureBtn.frame)/2;
    self.sureBtn.layer.masksToBounds = YES;
    self.myTableView .dataSource = self;
    self.myTableView.delegate = self;
    [self netGetData];
    self.dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.XYBtn.tag =100;
    self.ZYBtn.tag = 101;
    [_XYBtn setImage:[UIImage XYY_imageInKit:@"sex_n"] forState:UIControlStateNormal];
    [_XYBtn setImage:[UIImage XYY_imageInKit:@"sex_h"] forState:UIControlStateSelected];
    [_ZYBtn setImage:[UIImage XYY_imageInKit:@"sex_n"] forState:UIControlStateNormal];
    [_ZYBtn setImage:[UIImage XYY_imageInKit:@"sex_h"] forState:UIControlStateSelected];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.listModel) {
        _nameTF.text = self.listModel.templateName;
        if (self.listModel.templateType == 0) {
            self.XYBtn.selected = YES;;
            _tmpBtn = self.XYBtn;
        }else{
            self.ZYBtn .selected = YES;
            _tmpBtn = self.ZYBtn;
        }
        NSArray *array = [YaopinSearchListModel arrayFromData:self.listModel.hospDoctorPrescriptTemplateDetail];
        [self.dataArray addObjectsFromArray:array];
        [self netGetData];
    }else{
        
    }
    if (self.mArray) {
        NSArray *array = [YaopinSearchListModel arrayFromData:self.mArray];
        [self.dataArray addObjectsFromArray:array];
        [self netGetData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"YPInChufangCell";
      YaopinSearchListModel*model = _dataArray[indexPath.row];
    YPInChufangCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[YPInChufangCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell reloadDataWithModel:model];
    WS(weakSelf);
    [cell setOnYPDelBlock:^{
        //删除
        [YLTAlertUtil presentAlertViewWithTitle:@"" message:@"是否删除药品" cancelTitle:@"取消" defaultTitle:@"确认" distinct:YES cancel:^{
            
        } confirm:^{
            [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
            [weakSelf.myTableView beginUpdates];
            [weakSelf.myTableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationLeft];
            [weakSelf.myTableView endUpdates];
            [self netGetData];
        }];
        //[MBProgressHUD showSuccess:@"删除" toView:weakSelf.view];
        
    }];
    cell.wxBtn.hidden = YES;
    [cell setonWXBlock:^{
        YaopinSearchListModel *model = self.dataArray[indexPath.row];
        self.model = model;
        [self.YpEditView setHidden:NO];
        self.YpEditView.model = self.model;
         _row = indexPath.row;
        
    }];

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sureClick:(id)sender {
    HZKaiCFSearchYPController *ctrl=[[HZKaiCFSearchYPController alloc] init];
    UINavigationController *nv=[[UINavigationController alloc] initWithRootViewController:ctrl];
    ctrl.delegate = self;
    [self presentViewController:nv animated:YES completion:nil];
}
-(void)netGetData{
    [MBProgressHUD showMessag:@"" toView:self.view];

    WS(weakSelf);
    [NSGCDThread dispatchAfterInMailThread:^{
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
        //        weakSelf.dataArray=[[NSMutableArray alloc] initWithObjects:self.model, nil];
        
        CGFloat h=(weakSelf.dataArray.count*190)>(SCREEN_HEIGHT-TITLE_HEIGHT_WITH_BAR-61-98)?(SCREEN_HEIGHT-TITLE_HEIGHT_WITH_BAR-61-98):(weakSelf.dataArray.count*190);
        weakSelf.tableViewH.constant=h;
        for (int i=0;i<_dataArray.count;i++) {
            YaopinSearchListModel*models=[_dataArray objectAtIndex:i];
            NSArray *typeGoodArray=[weakSelf.dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@" self.commonName==%@ and self.packingRule==%@" , models.commonName,models.packingRule]];
            if(typeGoodArray.count>1){
                for (YaopinSearchListModel*model in typeGoodArray) {
                    model.isShowColor  = YES;
                    [_dataArray replaceObjectAtIndex:i withObject:model];
                }
            }else{
                models.isShowColor = NO;
            }
        }
        
        [weakSelf.myTableView reloadData];
    } Delay:15];
}
- (void)onNext{
    if (self.listModel) {
        [self updateNet];
    }else{
       [self commitNet];
    }
    
}
- (IBAction)btnClick:(UIButton*)sender {
    if (_tmpBtn == nil){
        sender.selected = YES;
        _tmpBtn = sender;
    }
    else if (_tmpBtn !=nil && _tmpBtn == sender){
        sender.selected = YES;
    }
    else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
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
            YPInChufangCell *cell = [weakSelf.myTableView cellForRowAtIndexPath:indexPath];
            YaopinSearchListModel*model = weakSelf.dataArray[weakSelf.row];
            weakSelf.model.number = num;
            weakSelf.model.singleDosage =singleDosage;
            weakSelf.model.unitName = unitName;
            weakSelf.model.useFunction = fyff;
            weakSelf.model.directions = yypc;
            weakSelf.model.directionsTime = [day integerValue];
            model.extraTotal  = num *[model.extractPrice integerValue];
            
            [cell reloadDataWithModel:model];
            [weakSelf.myTableView reloadData];
        }];
        [_YpEditView showView];
    }
    return _YpEditView;
}
- (void)updateNet {
     [MBProgressHUD showMessag:@"" toView:self.view];
    HospDoctorPrescriptTemplateUpdateCmd *cmd = [[HospDoctorPrescriptTemplateUpdateCmd alloc]init];
    cmd.equalId = self.listModel.equalId;
    cmd.templateName = _nameTF.text;
    if (_tmpBtn.tag == 100&& _tmpBtn.selected == YES) {
        cmd.templateType =@"0";
    }else if (_tmpBtn.tag == 101 && _tmpBtn.selected == YES){
        cmd.templateType = @"1";
    }
    WS(weakSelf);
    cmd.hospDoctorPrescriptTemplateDetail = [self toArray:self.dataArray];
    [[HttpNetwork getInstance] request:cmd success:^(BaseRespond *respond) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failed:^(BaseRespond *respond, NSString *error) {
        [MBProgressHUD showError:error toView:weakSelf.view];
    }];
}
//新增模板
- (void)commitNet{
    if (IS_EMPTY(_nameTF.text)) {
        [MBProgressHUD showError:@"请输入模板名称" toView:self.view];
        return;
    }
    [MBProgressHUD showMessag:@"" toView:self.view];
    HospDoctorPrescriptTemplateInsertCmd *cmd = [[HospDoctorPrescriptTemplateInsertCmd alloc]init];
    cmd.templateName = _nameTF.text;
    if (_tmpBtn.tag == 100&& _tmpBtn.selected == YES) {
        cmd.templateType =@"0";
    }else if (_tmpBtn.tag == 101 && _tmpBtn.selected == YES){
        cmd.templateType = @"1";
    }
    WS(weakSelf);
    cmd.hospDoctorPrescriptTemplateDetail = [self toArray:self.dataArray];
    [[HttpNetwork getInstance] request:cmd success:^(BaseRespond *respond) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failed:^(BaseRespond *respond, NSString *error) {
        [MBProgressHUD showError:error toView:weakSelf.view];
    }];
}
//获取提交list
- (NSArray *)toArray:(NSArray*)theData{
    NSMutableArray *d=[[NSMutableArray alloc] init];
    for (YaopinSearchListModel *model in theData) {
        [d addObject:[model toDictionary]];
    }
    return [d copy];
}
- (void)changeText:(YaopinSearchListModel *)model
{
    self.model = model;
    model.extraTotal  = model.number *[model.extractPrice integerValue];
    [self.dataArray addObject:self.model];
    [self netGetData];
    //    [self.tableView reloadData];
}
@end
