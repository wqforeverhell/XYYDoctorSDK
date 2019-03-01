//
//  DoctorListHeaderView.m
//  yaolianti
//
//  Created by qxg on 2018/10/18.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "DoctorListHeaderView.h"
#import "HuanzheStruce.h"
#import "ViewUtil.h"
#import "XYYDoctorSDK.h"
@implementation DoctorListHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = RGB(245, 245, 245);
        self.contentView .backgroundColor = RGB(240, 240, 240);
        [self setUpUI];
    }
    return  self;
}
- (void)setUpUI {
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake375(10, 10, 355, 40)];
    bgview.backgroundColor = RGB(255, 255, 255);
    [self addSubview:bgview];
     [ViewUtil ShearRoundCornersWidthLayer:bgview.layer type:LXKShearRoundCornersTypeTop radiusSize:4];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake375(10, 9, 100, 22)];
    nameLabel.text = @"消化道不适";
    nameLabel.textColor = RGB(51, 51, 51);
    nameLabel.font = FONT(16);
    [bgview addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake375(285, 8, 60, 24);
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    editBtn.layer.cornerRadius = CGRectGetHeight(editBtn.frame)/2;
    editBtn.layer.masksToBounds = YES;
    editBtn.titleLabel.font = FONT(14);
    editBtn.layer.borderWidth = 1;
    [editBtn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    editBtn.layer.borderColor = RGB(2, 175, 102).CGColor;
    [editBtn setTitleColor:RGB(2, 175, 102) forState:UIControlStateNormal];
    [bgview addSubview:editBtn];
    self.editBtn = editBtn;
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake375(215, 8, 60, 24);
    deleteBtn.layer.cornerRadius = CGRectGetHeight(editBtn.frame)/2;
    deleteBtn.layer.masksToBounds = YES;
    deleteBtn.layer.borderWidth = 1;
    deleteBtn.titleLabel.font = FONT(14);
    deleteBtn.layer.borderColor = RGB(245, 166, 35).CGColor;
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setTitleColor:RGB(245, 165, 35) forState:UIControlStateNormal];
    [bgview addSubview:deleteBtn];
    self.deleteBtn = deleteBtn;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake375(10, 39, 335, 1)];
    lineView.backgroundColor = RGB(245, 245, 245);
    [bgview addSubview:lineView];
}
- (void)editClick {
    if (self.selectedEditHeadView) {
        self.selectedEditHeadView(self.model);
    }
}
- (void)deleteClick {
    if (self.selectedDeleteHeadView) {
        self.selectedDeleteHeadView(self.model);
    }
}
- (void)reloadDataWithModel:(YaopinMoBanModel *)model
{
    self.nameLabel.text = model.templateName;
    self.model = model;
}

@end
