//
//  YaopingSmallCell.m
//  yaolianti
//
//  Created by huangliwen on 2018/6/6.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "YaopingSmallCell.h"
#import "HuanzheStruce.h"
@interface YaopingSmallCell(){
    onYpSmallAddBlock _block;
}
@property (weak, nonatomic) IBOutlet UILabel *labYpName;
@property (weak, nonatomic) IBOutlet UILabel *labChangjia;
@property (weak, nonatomic) IBOutlet UILabel *labTcPice;
@end
@implementation YaopingSmallCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setOnYpSmallAddBlock:(onYpSmallAddBlock)block{
    if (block) {
        _block=nil;
        _block=[block copy];
    }
}
- (void)reloadDataWithModel:(YaopinSearchListModel *)model
{
    self.model = model;
    self.labYpName.text = model.commonName;
    self.labChangjia.text = model.factoryName;
    if (model.extractPrice  == nil) {
        self.labTcPice.text = @"诊疗费:0";
    }else{
        self.labTcPice.text = [NSString stringWithFormat:@"诊疗费:%@",model.extractPrice];
    }

}
#pragma mark 点击事件
- (IBAction)onAdd:(id)sender {
    if(_block){
        _block(self.model);
    }
}

@end
