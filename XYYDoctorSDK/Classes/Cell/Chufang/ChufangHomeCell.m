//
//  ChufangHomeCell.m
//  yaolianti
//
//  Created by huangliwen on 2018/6/6.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "ChufangHomeCell.h"
#import "ViewUtil.h"
#import "RecordStruce.h"
#import "XYYDoctorSDK.h"
@interface ChufangHomeCell()
@property (weak, nonatomic) IBOutlet UIView *viewBg;
@property (weak, nonatomic) IBOutlet UILabel *labelDC;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labZhusu;
@property (weak, nonatomic) IBOutlet UILabel *labZhenD;
@property (weak, nonatomic) IBOutlet UILabel *labelYJ;
@property (weak, nonatomic) IBOutlet UILabel *labelNum;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;

@property (weak, nonatomic) IBOutlet UILabel *labelTiem;
@property (weak, nonatomic) IBOutlet UILabel *labelYD;
@property (weak, nonatomic) IBOutlet UIButton *cflcBtn;

@end
@implementation ChufangHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //[ViewUtil setshadowColorToView:_viewBg];
    _viewBg.layer.cornerRadius = 4;
    _viewBg.layer.masksToBounds = YES;
    _cflcBtn.layer.borderColor = RGB(2, 175, 102).CGColor;
    _cflcBtn.layer.cornerRadius = CGRectGetHeight(_cflcBtn.frame)/2;
    _cflcBtn.layer.borderWidth = 1;
}
- (void)reloadDataWithModel:(ChufangRecordModel *)model isshow:(BOOL)ishow
{
    self.labelDC.text = [NSString stringWithFormat:@"处方单号：%@",model.code];
    self.labelName.text = [NSString stringWithFormat:@"患者姓名:%@",model.storePatientInfo.patientName];
    self.labZhusu.text = [NSString stringWithFormat:@"主       诉:%@",model.mainSuit];
    self.labZhenD.text = [NSString stringWithFormat:@"初步诊断:%@",model.primaryDiagnosis];
    self.labelYJ.text = [NSString stringWithFormat:@"诊疗意见:%@",model.diagnosisIdea];
    self.labelNum.text = [NSString stringWithFormat:@"开药数量:%@",model.goodsNumber];
    if (model.diagnosisFee == nil) {
        self.labelPrice.text = @"诊疗费:0";
    }else{
       self.labelPrice.text = [NSString stringWithFormat:@"诊疗费用:%@",model.diagnosisFee];
    }
   
    self.labelTiem.text = [NSString stringWithFormat:@"开具时间:%@",model.createTime];
    self.model = model;
    if (ishow) {
        self.labelYD.hidden = NO;
        if (model.isTakeDrug == 1) {
            self.labelYD.text = @"已取药";
            self.labelYD.textColor = RGB(2, 175, 102);
        }else{
            self.labelYD.text = @"未取药";
            self.labelYD.textColor = RGB(245, 165, 35);
        }
    }else{
        self.labelYD.hidden = NO;
        if (model.checkStatus == 1) {
            self.labelYD .text = @"审核通过";
            self.labelYD.textColor = RGB(2, 175, 102);
        }else if (model.checkStatus == 2){
            self.labelYD.text = @"审核驳回";
            self.labelYD.textColor = RGB(245, 165, 35);
        }else{
            self.labelYD.hidden = YES;
        }
    }
   
}
- (IBAction)cflcClick:(id)sender {
    self.OnWuliuCodeBlock(self.model);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
