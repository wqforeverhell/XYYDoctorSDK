//
//  MobanListTableViewCell.m
//  yaolianti
//
//  Created by qxg on 2018/10/18.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "MobanListTableViewCell.h"
#import "HuanzheStruce.h"
#import "ViewUtil.h"
#import "XYYDoctorSDK.h"
@interface MobanListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *packLabel;


@end
@implementation MobanListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = RGB(240, 240, 240);
//    self.bgView.layer.cornerRadius = 4;
//    self.bgView.layer.masksToBounds = YES;
    
}
-(void)reloadDataWithModel:(YaopinSearchListModel*)model isyj:(BOOL)isyj {
    _nameLabel.text = model.commonName;
    _packLabel.text = model.packingRule;
    if (isyj) {
        [ViewUtil ShearRoundCornersWidthLayer:_bgView.layer type:LXKShearRoundCornersTypeBottom radiusSize:4];
    }else{
        [ViewUtil ShearRoundCornersWidthLayer:_bgView.layer type:LXKShearRoundCornersTypeBottom radiusSize:0];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
