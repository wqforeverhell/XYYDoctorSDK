//
//  PatientPrescriptionCell.m
//  yaolianti
//
//  Created by qxg on 2018/10/17.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "PatientPrescriptionCell.h"
#import "RecordStruce.h"
#import "XYYDoctorSDK.h"
@interface PatientPrescriptionCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *packLabel;
@property (weak, nonatomic) IBOutlet UILabel *useFunLabel;

@end

@implementation PatientPrescriptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = RGB(240, 240, 240);
    self.contentView.backgroundColor = RGB(240, 240, 240);
    self.bgView.frame = CGRectMake375(10, 0, 355, 43);
}
- (void)reloadDataWithModel:(PatientInfoDetailMdel *)model
{
    self.nameLabel .text = model.commonName;
    self.packLabel.text = [NSString stringWithFormat:@"%@ %ld%@",model.packingRule,(long)model.number,model.packageUnitName];
    self.useFunLabel.text = [NSString stringWithFormat:@"%@;%@%@  %@",model.directions,model.singleDosage,model.unitName,model.useFunction];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
