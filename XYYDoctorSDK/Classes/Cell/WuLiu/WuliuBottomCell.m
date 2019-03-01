//
//  WuliuBottomCell.m
//  yaolianti
//
//  Created by qxg on 2018/12/14.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "WuliuBottomCell.h"
#import "YaojishiRefuseStruce.h"
#import "TimeUtil.h"
#import "XYYDoctorSDK.h"
@interface WuliuBottomCell()
@property (weak, nonatomic) IBOutlet UILabel *labDateDay;
@property (weak, nonatomic) IBOutlet UILabel *labDateTime;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *labShuoming;

@end
@implementation WuliuBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = RGB(240, 240, 240);
}
- (void)reloadDataWithModel:(DoctorprescriptiontraceModel *)model{
    _labDateDay.text=[[TimeUtil getInstance] dateStringFromSecondYMRorMR:model.initTime];
    _labDateTime.text=[[TimeUtil getInstance] dateStringFromSecondHM:model.initTime];
   _labShuoming.text=[NSString stringWithFormat:@"%@%@",model.operator,model.operateNodeDescription];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
