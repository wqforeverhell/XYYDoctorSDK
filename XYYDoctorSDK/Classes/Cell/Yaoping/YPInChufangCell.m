//
//  YPInChufangCell.m
//  yaolianti
//
//  Created by huangliwen on 2018/6/8.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "YPInChufangCell.h"
#import "HuanzheStruce.h"
#import "StringUtil.h"
#import "XYYDoctorSDK.h"
@interface YPInChufangCell(){
    onYPDelBlock _block;
    onWXBlock _wBlock;
}
@property (weak, nonatomic) IBOutlet UILabel *labYPName;
@property (weak, nonatomic) IBOutlet UILabel *labGuige;
@property (weak, nonatomic) IBOutlet UILabel *labChangjia;
@property (weak, nonatomic) IBOutlet UILabel *labYongfa;
@property (weak, nonatomic) IBOutlet UILabel *labFuyong;
@property (weak, nonatomic) IBOutlet UILabel *labNum;
@property (weak, nonatomic) IBOutlet UILabel *labPice;
@property (weak, nonatomic) IBOutlet UILabel *labelDay;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
@implementation YPInChufangCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = RGB(245, 245, 245);
    self.contentView.backgroundColor = RGB(245, 245, 245);
    _deleteBtn.layer.cornerRadius = CGRectGetHeight(_deleteBtn.frame)/2;
    _deleteBtn.layer.masksToBounds = YES;
    _deleteBtn.layer.borderWidth = 1;
    _deleteBtn.layer.borderColor = RGB(245, 166, 35).CGColor;
    
    _editBtn.layer.cornerRadius = CGRectGetHeight(_editBtn.frame)/2;
    _editBtn.layer.masksToBounds = YES;
    _editBtn.layer.borderWidth = 1;
    _editBtn.layer.borderColor = RGB(2, 175, 102).CGColor;
    self.bgView.layer.cornerRadius = 4;
    self.bgView.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)reloadDataWithModel:(YaopinSearchListModel *)model
{
    if (model.isShowColor) {
        [self setBackgroundColor:HexRGBAlpha(0xFF6347, 0.5)];
    }else{
        [self setBackgroundColor:RGB(245, 245, 245)];
    }
    self.labYPName.text = model.commonName;
    self.labGuige.text  = [NSString stringWithFormat:@"规   格:%@",model.packingRule];
    if ([StringUtil QX_NSStringIsNULL:model.factoryName]) {
        self.labChangjia.text = @"厂   商:";
    }else{
        self.labChangjia.text = [NSString stringWithFormat:@"厂   商:%@",model.factoryName];
    }
   
    self.labFuyong.text = [NSString stringWithFormat:@"用法用量:%@%@%@",model.directions,model.singleDosage,model.unitName];
    self.labNum.text = [NSString stringWithFormat:@"服用方式:%@; 用药时长%ld天; 数量%ld%@",model.useFunction,model.directionsTime,model.number,model.packageUnitName];
   
    self.labPice.text = [NSString stringWithFormat:@"诊疗费:¥%ld",(long)model.extraTotal];
    self.labelDay.text = [NSString stringWithFormat:@"用药时长:%ld天",(long)model.directionsTime];
}

-(void)setOnYPDelBlock:(onYPDelBlock)block{
    if (block) {
        _block=nil;
        _block=[block copy];
    }
}
- (void)setonWXBlock:(onWXBlock)block
{
    if (block) {
        _wBlock = nil;
        _wBlock = [block copy];
    }
}
- (IBAction)click:(id)sender {
    if (_wBlock) {
        _wBlock();
    }
}

- (IBAction)onDel:(id)sender {
    if (_block) {
        _block();
    }
}
@end
