//
//  ChaxunViewController.m
//  yaolianti
//
//  Created by qxg on 2018/9/13.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "ChaxunViewController.h"
#import "HlwTextField.h"
#import "HLWSelectTimeGyq.h"
#import "XYYDoctorSDK.h"
@interface ChaxunViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet HlwTextField *nameTF;
@property (weak, nonatomic) IBOutlet HlwTextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *beginTF;
@property (weak, nonatomic) IBOutlet UITextField *endTF;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameH;
@property(nonatomic,strong)HLWSelectTimeGyq *selectDateView;
@end

@implementation ChaxunViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.selectDateView) {
        [self.selectDateView dissmis];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBack];
   
    self.sureBtn.layer .cornerRadius = CGRectGetHeight(_sureBtn.frame)/2;
    self.sureBtn.layer.masksToBounds = YES;
    if (self.type ==1) {
        [self setupTitleWithString:@"处方筛选"];
    }else if (self.type ==3){
         [self setupTitleWithString:@"建议单筛选"];
    }
    else{
         [self setupTitleWithString:@"患者筛选"];
    }
    
    _beginTF.delegate = self;
    _beginTF.inputView = [[UIView alloc]init];
    _beginTF.tag = 100;
    _beginTF.inputView.hidden = YES;
    
    _endTF.delegate = self;
    _endTF.inputView = [[UIView alloc]init];
    _endTF.tag = 101;
    _endTF.inputView.hidden = YES;
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}
- (IBAction)sureBtn:(id)sender {
//    if (IS_EMPTY(_nameTF.text) && IS_EMPTY(_phoneTF.text)&& IS_EMPTY(_beginTF.text)&&IS_EMPTY(_endTF.text)) {
//        [MBProgressHUD showError:@"请至少输入一项您的查询条件" toView:self.view];
//        return;
//    }
    if (self.delegate &&[self.delegate respondsToSelector:@selector(getChaxunMessageWithName:phoneNum:beginTime:endTime:)]) {
        [self.delegate getChaxunMessageWithName:_nameTF.text phoneNum:_phoneTF.text beginTime:_beginTF.text endTime:_endTF.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    WS(weakSelf);
    [self.selectDateView dissmis];
    if (textField.tag == 100) {
        [weakSelf.selectDateView show];
        [weakSelf.selectDateView setOnDoneBlock:^(NSString *time) {
            _beginTF.text = time;
        }];
    }else{
        [weakSelf.selectDateView show];
        [weakSelf.selectDateView setOnDoneBlock:^(NSString *time) {
            _endTF.text = time;
        }];
    }
    
}
-(HLWSelectTimeGyq *)selectDateView{
    if (!_selectDateView) {
        _selectDateView=[[HLWSelectTimeGyq alloc] init];
//        WS(weakSelf);
//        [_selectDateView setOnDoneBlock:^(NSString *time) {
//        }];
    }
    return _selectDateView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
