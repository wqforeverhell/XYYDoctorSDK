//
//  PatientXYTableViewCell.m
//  yaolianti
//
//  Created by qxg on 2018/10/15.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "PatientXYTableViewCell.h"
#import "UserStruce.h"
@interface PatientXYTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *XYLabel;

@end
@implementation PatientXYTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (void)reloadDataWithModel:(GetMyPatientRecordModel *)model
{
    self.timeLabel.text = model.pressureTime;
    self.XYLabel.text = [NSString stringWithFormat:@"%@/%@mmHg",model.systolicPressure,model.diastolicPressure];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
