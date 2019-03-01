//
//  YLTwenzhenTableViewCell.m
//  yaolianti
//
//  Created by qxg on 2018/9/10.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "YLTwenzhenTableViewCell.h"
#import "UIView+NIM.h"
#import "NIMKitUtil.h"
#import "NIMBadgeView.h"
#import "HuanzheStruce.h"
#import "XYYDoctorSDK.h"
@interface YLTwenzhenTableViewCell()
{
    onjieshuBlock _block;
}
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;

@end
@implementation YLTwenzhenTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _timeLabel.hidden = YES;
    _endBtn.backgroundColor = RGBA(2, 175, 102, 0.02);
    
}
#define NameLabelMaxWidth    160.f
#define MessageLabelMaxWidth 130.f
-(void)reloadDataWithModel:(DoctorWithListDetailModel*)model{
    self.model = model;

    self.nameLabel.nim_width = self.nameLabel.nim_width > NameLabelMaxWidth ? NameLabelMaxWidth : self.nameLabel.nim_width;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.headPicUrl]] placeholderImage:[UIImage XYY_imageInKit:@"icon_symr"]];
    self.nameLabel.text = model.storeName;
}
-(void)setOnYpBigAddBlock:(onjieshuBlock)block{
    if (block) {
        _block=nil;
        _block=[block copy];
    }
}

- (IBAction)jieshuBtn:(id)sender {
    if(_block){
        _block(self.model);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
