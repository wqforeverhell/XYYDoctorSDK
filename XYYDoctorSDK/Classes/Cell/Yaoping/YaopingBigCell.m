//
//  YaopingBigCell.m
//  yaolianti
//
//  Created by huangliwen on 2018/6/6.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "YaopingBigCell.h"
#import "HuanzheStruce.h"
#import "XYYDoctorSDK.h"
@interface YaopingBigCell(){
    onYpBigAddBlock _block;
}
@property (weak, nonatomic) IBOutlet UILabel *labYpName;
@property (weak, nonatomic) IBOutlet UILabel *labGuige;
@property (weak, nonatomic) IBOutlet UILabel *labChangjia;
@property (weak, nonatomic) IBOutlet UILabel *labTc;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIButton *YPDetailBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end
@implementation YaopingBigCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _labYpName.textColor = RGB(51, 51, 51);
    _btnAdd.layer.cornerRadius = CGRectGetHeight(_btnAdd.frame)/2;
    _btnAdd.layer.masksToBounds = YES;
    _btnAdd.layer.borderWidth = 1;
    _btnAdd.layer.borderColor = RGB(2, 175, 102).CGColor;
    //[self.contentView addSubview:_YPDetailBtn];
    _YPDetailBtn.layer.cornerRadius = CGRectGetHeight(_YPDetailBtn.frame)/2;
    _YPDetailBtn.layer.masksToBounds = YES;
    _YPDetailBtn.layer.borderWidth = 1;
    _YPDetailBtn.layer.borderColor = RGB(2, 175, 102).CGColor;
    self.bgView.layer.cornerRadius = 2;
    self.bgView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void)reloadDataWithModel:(YaopinSearchListModel *)model
{
    self.model = model;
    self.labYpName.text = model.commonName;
    self.labGuige.text = model.packingRule;
    self.labChangjia.text = model.factoryName;
    if (model.extractPrice == nil ) {
        self.labTc.text = @"诊疗费:0";
    }else{
       self.labTc.text = [NSString stringWithFormat:@"诊疗费:%@",model.extractPrice];
    }
}
-(void)setOnYpBigAddBlock:(onYpBigAddBlock)block{
    if (block) {
        _block=nil;
        _block=[block copy];
    }
}
#pragma mark 点击事件
- (IBAction)onAdd:(id)sender {
    if(_block){
        _block(self.model);
    }
}
- (IBAction)onDetail:(id)sender {
    if (_detailblock) {
        self.detailblock(self.model);
    }
}

@end
