//
//  YPEditCell.m
//  yaolianti
//
//  Created by qxg on 2018/10/25.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "YPEditCell.h"
#import "HuanzheStruce.h"
#import "XYYDoctorSDK.h"
@interface YPEditCell()
{
    onYPDelBlock _block;
    onWXBlock _wBlock;
}
@property (weak, nonatomic) IBOutlet UIView *bgView;
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

@end
@implementation YPEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = RGB(245, 245, 245);
    self.bgView.layer.cornerRadius = 2;
    self.bgView.layer.masksToBounds = YES;
    _deleteBtn.layer.cornerRadius = CGRectGetHeight(_deleteBtn.frame)/2;
    _deleteBtn.layer.masksToBounds = YES;
    _deleteBtn.layer.borderWidth = 1;
    _deleteBtn.layer.borderColor = RGB(245, 166, 35).CGColor;
    
    _editBtn.layer.cornerRadius = CGRectGetHeight(_editBtn.frame)/2;
    _editBtn.layer.masksToBounds = YES;
    _editBtn.layer.borderWidth = 1;
    _editBtn.layer.borderColor = RGB(2, 175, 102).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)reloadDataWithModel:(YaopinSearchListModel *)model
{
    if (model.isShowColor) {
        [_bgView setBackgroundColor:HexRGBAlpha(0xFF6347, 0.2)];
    }else{
        [_bgView setBackgroundColor:RGB(255, 255, 255)];
    }
    self.labYPName.text = model.commonName;
    self.labGuige.text  = [NSString stringWithFormat:@"规   格:%@",model.packingRule];
    if ([StringUtil QX_NSStringIsNULL:model.factoryName]) {
        self.labChangjia.text = @"厂   商:";
    }else{
        self.labChangjia.text = [NSString stringWithFormat:@"厂   商:%@",model.factoryName];
    }
   
    if ([model.singleDosage containsString:model.unitName]) {
        self.labFuyong.text = [NSString stringWithFormat:@"用法用量:%@,%@",model.directions,model.singleDosage];
    }else{
        self.labFuyong.text = [NSString stringWithFormat:@"用法用量:%@,%@%@",model.directions,model.singleDosage,model.unitName];
    }
    self.labNum.text = [NSString stringWithFormat:@"服用方式:%@; 用药时长%ld天; 数量%ld%@",model.useFunction,model.directionsTime,model.number,model.packageUnitName];
    
    self.labPice.text = [NSString stringWithFormat:@"诊疗费:¥%ld",(long)model.extraTotal];
    self.labelDay.text = [NSString stringWithFormat:@"用药时长:%ld天",(long)model.directionsTime];
}
- (NSString *)getNumberFromStr:(NSString *)str{
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return[[str componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
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
- (IBAction)delete:(id)sender {
    if (_block) {
        _block();
    }
}
- (IBAction)edit:(id)sender {
    if (_wBlock) {
        _wBlock();
    }
}

@end
