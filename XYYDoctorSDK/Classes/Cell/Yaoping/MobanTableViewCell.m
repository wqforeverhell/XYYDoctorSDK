//
//  MobanTableViewCell.m
//  yaolianti
//
//  Created by zl on 2018/7/9.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "MobanTableViewCell.h"
#import "XYYDoctorSDK.h"
#import "HuanzheStruce.h"
@interface MobanTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@end
@implementation MobanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.labelPrice.hidden = YES;
    _detailBtn.layer.cornerRadius = CGRectGetHeight(_detailBtn.frame)/2;
    _detailBtn.layer.masksToBounds = YES;
    _detailBtn.layer.borderWidth = 1;
    _detailBtn.layer.borderColor = RGB(2, 175, 102).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)detailClick:(id)sender {
    if (_block) {
        self.block(self.model);
    }
}

- (void)reloadDataWithModel:(YaopinSearchListModel *)model
{
    self.model = model;
    self.labelName.text = model.commonName;
//    if ([model.extractPrice isKindOfClass:[NSNull class]]) {
//        self.labelPrice.text = @"0";
//    }else{
//      self.labelPrice.text = [NSString stringWithFormat:@"诊疗费:%ld",[model.extractPrice integerValue]];
//    }
    self.labelPack.text = model.packingRule;
    self.labelProduct.text = model.factoryName ;
}
@end
