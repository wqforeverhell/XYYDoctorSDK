//
//  DiagnoseListTableViewCell.m
//  yaolianti
//
//  Created by qxg on 2018/9/14.
//  Copyright © 2018年 hlw. All rights reserved.
//
#define ImgName(imageName) [UIImage imageNamed:imageName]
#import "DiagnoseListTableViewCell.h"
#import "HuanzheStruce.h"
#import "XYYDoctorSDK.h"
@interface DiagnoseListTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *diagnoseLabel;

@end
@implementation DiagnoseListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)selectClick:(UIButton*)sender {
    
 _select = !_select;
 UIImage *selectBtnImage = (_select)?[UIImage XYY_imageInKit:@"list_choose"]:[UIImage XYY_imageInKit:@"list_unchoose"];
 [_selectBtn setBackgroundImage:selectBtnImage forState:UIControlStateNormal];

if ([self.delegate respondsToSelector:@selector(cell:selected:indexPath:)]) {
    [self.delegate cell:self selected:_select indexPath:self.indexPath];
 }
}
- (void)reloadDataWithModel:(DiagnoselistModel *)model type:(NSInteger)type
{
    _select = model.isSelected;
    UIImage *selectBtnImage = _select?[UIImage XYY_imageInKit:@"list_choose"]:[UIImage XYY_imageInKit:@"list_unchoose"];
    [_selectBtn setBackgroundImage:selectBtnImage forState:UIControlStateNormal];
    _diagnoseLabel.text = type == 1 ? model.sysptomName:model.suitName;
    //_diagnoseLabel.text = model.sysptomName;;
}

@end
