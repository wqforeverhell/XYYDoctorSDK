//
//  YaopinEditView.m
//  yaolianti
//
//  Created by huangliwen on 2018/6/9.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "YaopinEditView.h"
#import "ViewUtil.h"
#import "HlwTextField.h"
#import "HuanzheCmd.h"
#import "HDPickerView.h"
#import "XYYDoctorSDK.h"
@interface YaopinEditView()<UITextFieldDelegate>{
    onYpEditOKBlock _block;
}
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *guigeLabel;
@property (weak, nonatomic) IBOutlet HlwTextField *txtDCYL;
@property (weak, nonatomic) IBOutlet UITextField *txtDw;
@property (weak, nonatomic) IBOutlet UITextField *txtPC;
@property (weak, nonatomic) IBOutlet HlwTextField *txtDay;
@property (weak, nonatomic) IBOutlet UITextField *txtFyFF;
@property (weak, nonatomic) IBOutlet HlwTextField *txtToal;
@property (weak, nonatomic) IBOutlet UITextField *totalDW;
@property (weak, nonatomic) IBOutlet HlwTextField *txtBz;

//@property (weak, nonatomic) IBOutlet HlwTextField *txtDay;//天数
@property (weak, nonatomic) IBOutlet UIButton *btnQueding;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftJianju;
@property(nonatomic,strong)NSMutableArray *aArr;
@property(nonatomic,strong)NSMutableArray *bArr;
@property(nonatomic,strong)NSMutableArray *cArr;
@property (nonatomic,assign)int maxStr;
@property (nonatomic,assign)int minStr;
@end
@implementation YaopinEditView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH-30, _viewContent.bounds.size.height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(DEFAULT_YUANJIAO, DEFAULT_YUANJIAO)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _viewContent.bounds;
    maskLayer.path = maskPath.CGPath;
    _viewContent.layer.mask = maskLayer;
    
//    [ViewUtil setJianbianToView:_btnQueding colorType:JianBianGreen frame:CGRectMake(0, 0, SCREEN_WIDTH-76, _btnQueding.bounds.size.height)];
    //单次用量
    _txtDCYL.layer.borderColor=RGB(153, 153, 153).CGColor;
    _totalDW.layer.borderWidth=1;
    _totalDW.layer.borderColor = RGB(153, 153, 153).CGColor;
    _totalDW.layer.cornerRadius=DEFAULT_YUANJIAO;
    _totalDW.layer.masksToBounds=YES;
    _totalDW.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 30)];
    _totalDW.leftViewMode=UITextFieldViewModeAlways;
    _totalDW.delegate = self;
    _totalDW.enabled = NO;
    
    _txtDCYL.layer.borderWidth=1;
    _txtDCYL.layer.cornerRadius=DEFAULT_YUANJIAO;
    
    _txtDCYL.layer.masksToBounds=YES;
    _txtDCYL.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 30)];
    _txtDCYL.leftViewMode=UITextFieldViewModeAlways;
    _txtDCYL.tag = 10;
    _txtDCYL.delegate = self;
    //单位
    _txtDw.layer.borderColor=RGB(153, 153, 153).CGColor;
    _txtDw.layer.borderWidth=1;
    _txtDw.layer.cornerRadius=DEFAULT_YUANJIAO;
    _txtDw.layer.masksToBounds=YES;
    _txtDw.inputView = [[UIView alloc]init];
    _txtDw.inputView.hidden = YES;
    _txtDw.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 30)];
    _txtDw.leftViewMode=UITextFieldViewModeAlways;
    _txtDw.tag = 11;
    _txtDw.delegate = self;
    
    //用药频次
    _txtPC.layer.borderColor=RGB(153, 153, 153).CGColor;
    _txtPC.layer.borderWidth=1;
    _txtPC.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 30)];
    _txtPC.leftViewMode=UITextFieldViewModeAlways;
    _txtPC.tag = 12;
    _txtPC.inputView = [[UIView alloc]init];
    _txtPC.inputView.hidden = YES;
    _txtPC.delegate = self;
    _txtPC.layer.cornerRadius=DEFAULT_YUANJIAO;
    _txtPC.layer.masksToBounds=YES;
    //备注
    //用药频次
    _txtBz.layer.borderColor=RGB(153, 153, 153).CGColor;
    _txtBz.layer.borderWidth=1;
    _txtBz.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 30)];
    _txtBz.leftViewMode=UITextFieldViewModeAlways;
    _txtBz.tag = 18;
//    _txtBz.inputView = [[UIView alloc]init];
//    _txtBz.inputView.hidden = YES;
    _txtBz.delegate = self;
    _txtBz.layer.cornerRadius=DEFAULT_YUANJIAO;
    _txtBz.layer.masksToBounds=YES;

    
    //天数
    _txtDay.layer.borderColor=RGB(153, 153, 153).CGColor;
    _txtDay.layer.borderWidth=1;
    _txtDay.tag = 13;
    
    _txtDay.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 30)];
    _txtDay.leftViewMode=UITextFieldViewModeAlways;
    _txtDay.layer.cornerRadius = DEFAULT_YUANJIAO;
    _txtDay.layer.masksToBounds=YES;
  
    _txtDay.delegate = self;
    //使用方法
    _txtFyFF.layer.borderColor=RGB(153, 153, 153).CGColor;
    _txtFyFF.layer.borderWidth=1;
    _txtFyFF.tag = 14;
    _txtFyFF.inputView = [[UIView alloc]init];
    _txtFyFF.inputView.hidden = YES;
    _txtFyFF.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 30)];
    _txtFyFF.leftViewMode=UITextFieldViewModeAlways;
    _txtFyFF.layer.cornerRadius=DEFAULT_YUANJIAO;
    _txtFyFF.layer.masksToBounds=YES;
    _txtFyFF.keyboardType = UIKeyboardTypeNumberPad;
    _txtFyFF.delegate = self;
    _txtFyFF.text = self.model.useFunction;
    
    _txtToal.layer.borderColor=RGB(153, 153, 153).CGColor;
    _txtToal.layer.borderWidth=1;
    _txtToal.keyboardType = UIKeyboardTypeNumberPad;
    
    _txtToal.text = @"";
    _txtToal.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 30)];
    _txtToal.leftViewMode=UITextFieldViewModeAlways;
    _txtToal.layer.cornerRadius=DEFAULT_YUANJIAO;
    _txtToal.layer.masksToBounds=YES;
    _txtToal.delegate = self;
    
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    self.userInteractionEnabled=YES;
    [self addGestureRecognizer:tapGesturRecognizer];
    
    UITapGestureRecognizer *tapGesturRecognizercon=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActioncon)];
    [_viewContent addGestureRecognizer:tapGesturRecognizercon];
    [self netGetData];
//    [self.txtDCYL setOnTextDoneBlock:^(NSString *text) {
//        [self.txtDw becomeFirstResponder];
//    }];
//    [self.txtDay setOnTextDoneBlock:^(NSString *text) {
//        [self.txtFyFF becomeFirstResponder];
//    }];
    [self registerForKeyboardNotifications];
}
- (void)registerForKeyboardNotifications {
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    //注册键盘弹出通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
}
-(void)dealloc{
    //移除键盘通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
//-(void)keyboardWillShow:(NSNotification *)note
//{
//    NSDictionary *info = [note userInfo];
//    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    //目标视图UITextField
//    CGRect frame = _txtBz.frame;
//    int y = frame.origin.y + frame.size.height - (self.frame.size.height - keyboardSize.height)+AutoY375(200);
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeView" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    if(y > 0)
//    {
//        self.frame = CGRectMake(0, -y, self.frame.size.width, self.frame.size.height);
//    }
//    [UIView commitAnimations];
//}
- (void)keyboardWillHide:(NSNotification *)notification {
   //self.viewContent.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
   // self.viewContent.contentOffset=CGPointMake(0, 0);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
}
-(void)setONYpEditOKBlock:(onYpEditOKBlock)block{
    if (block) {
        _block=nil;
        _block=[block copy];
    }
}
#pragma mark 点击事件
-(void)tapAction{
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
    self.hidden=YES;
}
-(void)tapActioncon{
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self netGetData];
    textField.layer.borderColor = RGB(2, 175, 102).CGColor;
    if (textField.tag == 12) {
        [[[HDPickerView alloc] initPickerViewWithDataSource:self.aArr
                                                selectVaule:^(NSString *value, NSInteger component, NSInteger row) {
                                                     _txtPC.text = value;
                                                    //[self.txtDay becomeFirstResponder];
                                                }] show];
    }else if (textField.tag == 11){
    [[[HDPickerView alloc] initPickerViewWithDataSource:self.bArr
                                                selectVaule:^(NSString *value, NSInteger component, NSInteger row) {
                                                    //                                                    self.bankName = cell.inputModel.text = value;
                                                    //[self.tableView reloadData];
                                                   _txtDw.text = value;
                                                   // [self.txtPC becomeFirstResponder];
                                                }] show];
    } else if (textField.tag == 14){
        [[[HDPickerView alloc] initPickerViewWithDataSource:self.cArr
                                                selectVaule:^(NSString *value, NSInteger component, NSInteger row) {
                                                    //                                                    self.bankName = cell.inputModel.text = value;
                                                    //[self.tableView reloadData];
                                                    //[_txtToal becomeFirstResponder];
                                                    _txtFyFF.text = value;
                                                }] show];
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.layer.borderColor = RGB(153, 153, 153).CGColor;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==_txtToal||textField==_txtBz) {
        CGRect frame = _txtBz.frame;
        int y = frame.origin.y + frame.size.height - (self.frame.size.height - 275)+AutoY375(200);
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        if(y > 0)
        {
            self.frame = CGRectMake(0, -y, self.frame.size.width, self.frame.size.height);
        }
        [UIView commitAnimations];
    }
    return YES;
}
- (IBAction)onQueding:(id)sender {
    if (IS_EMPTY(_txtDCYL.text)) {
        [MBProgressHUD showError:@"请输入单次用量" toView:_viewContent];
        return;
    }
    if (IS_EMPTY(_txtDw.text)) {
        [MBProgressHUD showError:@"请选择单位" toView:_viewContent];
        return;

    }
    if (IS_EMPTY(_txtPC.text)) {
        [MBProgressHUD showError:@"请选择用药频次" toView:_viewContent];
        return;
    }
    if (IS_EMPTY(_txtDay.text)) {
        [MBProgressHUD showError:@"请选择用药天数" toView:_viewContent];
        return;
    }
    if (IS_EMPTY(_txtFyFF.text)) {
        [MBProgressHUD showError:@"请选择服用方法" toView:_viewContent];
        return;
    }
    if (IS_EMPTY(_txtToal.text)) {
        [MBProgressHUD showError:@"请输入总量" toView:_viewContent];
        return;
    }
    if (_model.useLevelMin>0&&_model.useLevelMax>0&&[_txtDCYL.text intValue]>self.maxStr) {
        //没有控制最大最小值不用填写备注
        if (IS_EMPTY(_txtBz.text)) {
            [MBProgressHUD showError:@"请您填写备注说明" toView:_viewContent];
            return;
        }else{
            
        }
    }
//    if ( [_txtDCYL.text intValue]<self.minStr) {
//        [MBProgressHUD showError:[NSString stringWithFormat:@"单次用量不得小于%d",self.minStr] toView:_viewContent];
//        return;
//    }
//    if ([_txtDCYL.text intValue]>self.maxStr){
//        [MBProgressHUD showError:[NSString stringWithFormat:@"单次用量不得大于%d",self.maxStr] toView:_viewContent];
//        return;
//    }
   
    //NSString *danStr =[NSString stringWithFormat:@"%@%@",_txtDCYL.text,_txtDw.text];
    //int num,NSString *yfyl,NSString *yypc,NSString*fyff,NSString*day);
    if(_block){
        _block([_txtToal.text intValue],_txtDCYL.text,_txtDw.text,_txtPC.text,_txtFyFF.text,_txtDay.text,_txtBz.text);
    }
    self.hidden=YES;
//    [self dismissView];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 10) {
        if ([StringUtil isPureInt:string]) {
            if ([self judgeFirstChar:string]) {
                return YES;
            }else{
               NSString*  all_price = [textField.text stringByReplacingCharactersInRange:range withString:string];
                if (self.minStr ==0 || self.maxStr == 0) {
                    return YES;
                }
                else{
                    if ([all_price intValue] <self.minStr) {
                        [MBProgressHUD showError:[NSString stringWithFormat:@"单次用量不得小于%d",self.minStr] toView:_viewContent];
                        return YES;
                    }else if ([all_price intValue] >self.maxStr){
                        [MBProgressHUD showError:[NSString stringWithFormat:@"单次用量不得大于%d",self.maxStr] toView:_viewContent];
                        return YES;
                    }else{
                        return YES;
                    }
                }
            }
            
        }else{
            
        }
        return YES;
    }
    return YES;
}
-(BOOL)judgeFirstChar:(NSString*)string{
    
    if (_txtDCYL.text.length==0 &&[string isEqualToString:@"0"]) {
      return YES;
          }
    else{
            return NO;
    }
    
}

- (IBAction)cancelClick:(id)sender {
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
    self.hidden=YES;
}
#pragma 外部调用方法
-(void)showView{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
-(void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
    if (!hidden) {
        //[_txtNum becomeFirstResponder];
    }
}
- (void)dismissView{
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
    [self removeFromSuperview];
}
-(void)getColorChoiceValues:(NSString *)values
{
    //self.selectedResultLabel.text = values;
}

- (void)netGetData {
    GetListCmd *cmd = [[GetListCmd alloc]init];
    [[HttpNetwork getInstance] request:cmd success:^(BaseRespond *respond) {
        NSArray *array = respond.data[@"result"][@"frequency"];
        for (NSDictionary*dic in array) {
            [self.aArr addObject:dic[@"value"]];
//            [self.bArr addObject:dic[@"code"]];
//            [self.cArr addObject:dic[@"note"]];
        }
        NSArray *array1 = respond.data[@"result"][@"unit"];
        for (NSDictionary*dic in array1) {
            [self.bArr addObject:dic[@"value"]];
         
        }
        NSArray *array2 = respond.data[@"result"][@"usage"];
        for (NSDictionary*dic in array2) {
            [self.cArr addObject:dic[@"value"]];
          
        }
    } failed:^(BaseRespond *respond, NSString *error) {
        
    }];
}
- (void)setModel:(YaopinSearchListModel *)model
{

    self.maxStr = model.useLevelMax;
    self.minStr = model.useLevelMin;
    //self.model = model;
    self.txtFyFF.text = model.useFunction;
    self.txtDay.text =  [NSString stringWithFormat:@"%ld",(long)model.directionsTime];
    self.txtToal .text = [NSString stringWithFormat:@"%ld",(long)model.number];
    if ([self.txtToal.text isEqualToString:@"0"]) {
        self.txtToal .text = @"";
    }if ([self.txtDay.text isEqualToString:@"0"]) {
        self.txtDay.text= @"";
    }
    self.nameLabel.text = model.commonName;
    self.guigeLabel.text = model.packingRule;
    self.txtPC.text = model.modifyFrequency;
    if (IS_EMPTY(model.modifyFrequency)) {
        self.txtPC.text = model.directions;
    }
    
    if(model.usageLevel>0)
        _txtDCYL.text = [NSString stringWithFormat:@"%d",model.usageLevel];
    if ([StringUtil QX_NSStringIsNULL:model.modifyUseDosage]) {
        self.txtDw.text = model.unitName;
    }else{
       self.txtDw.text = model.modifyUseDosage;
    }
    self.totalDW.text = model.packageUnitName;
    //self.txtPC.text = model.directions;
    self.txtBz.text=model.remark;
}
-(NSMutableArray *)aArr
{
    if (!_aArr) {
        _aArr = [NSMutableArray array];
    }
    return _aArr;
}
-(NSMutableArray *)bArr
{
    if (!_bArr) {
        _bArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _bArr;
}
-(NSMutableArray *)cArr
{
    if (!_cArr) {
        _cArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _cArr;
}
 
@end
