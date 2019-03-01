//
//  HZHeaderView.m
//  yaolianti
//
//  Created by qxg on 2018/10/17.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "HZHeaderView.h"
#import "RecordStruce.h"
#import "ViewUtil.h"
#import "XYYDoctorSDK.h"
@implementation HZHeaderView
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
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake375(10, 10, 355, 143)];
    bgView.backgroundColor = RGB(255, 255, 255);
//    bgView.layer.cornerRadius = 4;
//    bgView.layer.masksToBounds = YES;
    [self addSubview:bgView];

    UIView *dateView = [[UIView alloc]initWithFrame:CGRectMake375(0, 0, 355, 37)];
    dateView.backgroundColor = RGB(251, 251, 251);
    [bgView addSubview:dateView];
    [ViewUtil ShearRoundCornersWidthLayer:bgView.layer type:LXKShearRoundCornersTypeTop radiusSize:4];
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake375(10, 8, 300, 22)];
    dateLabel.font = FONT(16);
    dateLabel.text = @"处方日期：2018-09-08";
    dateLabel.textColor = RGB(2, 175, 102);
    [dateView addSubview:dateLabel];
    self.dateLabel = dateLabel;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake375(285, 6, 60, 25);
    [btn setTitle:@"选择" forState:UIControlStateNormal];
    [btn setTitleColor:RGB(245, 166, 35) forState:UIControlStateNormal];
    btn.titleLabel.font = FONT(15);
    btn.layer.cornerRadius = CGRectGetHeight(btn.frame)/2;
    btn.layer.borderWidth =1;
    btn.layer.borderColor = RGB(245, 166, 35).CGColor;
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [dateView addSubview:btn];
    self.selectBtn = btn;
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake375(0, 37, 355, 106)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:bottomView];
    
    UILabel *zhusuLabel = [[UILabel alloc]initWithFrame:CGRectMake375(10, 8, 175, 20)];
    zhusuLabel.font = FONT(14);
    zhusuLabel.text = @"主    诉:";
    zhusuLabel.textColor = RGB(21, 21, 21);
    [bottomView addSubview:zhusuLabel];
    self.zhusuLabel = zhusuLabel;
    
    UILabel *ZDLabel = [[UILabel alloc]initWithFrame:CGRectMake375(10, 28, 175, 20)];
    ZDLabel.font = FONT(14);
    ZDLabel.text = @"初步诊断：流行性感冒";
    ZDLabel.textColor = RGB(21, 21, 21);
    [bottomView addSubview:ZDLabel];
    self.ZDLabel = ZDLabel;
    
    UILabel *optionLabel = [[UILabel alloc]initWithFrame:CGRectMake375(10, 48, 175, 20)];
    optionLabel.font = FONT(14);
    optionLabel.text = @"治疗意见：吃药，多喝水";
    optionLabel.textColor = RGB(21, 21, 21);
    [bottomView addSubview:optionLabel];
    self.optionLabel = optionLabel;
    
    UIView *circleView = [[UIView alloc]initWithFrame:CGRectMake375(10, 85, 10, 10)];
    circleView.backgroundColor = RGB(2, 175, 102);
    circleView.layer.cornerRadius = CGRectGetHeight(circleView.frame)/2;
    circleView.layer.masksToBounds = YES;
    [bottomView addSubview:circleView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake375(23, 80, 280, 20)];
    titleLabel.font = FONT(14);
    titleLabel.text = @"Rp";
    titleLabel.textColor = RGB(2, 175, 102);
    [bottomView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIImageView *arrowIamgeView = [[UIImageView alloc]initWithFrame:CGRectMake375(328, 86, 12, 7)];
    arrowIamgeView.image = [UIImage imageNamed:@"sectionClose"];
    [bottomView addSubview:arrowIamgeView];
    self.arrowIamgeView = arrowIamgeView;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake375(10, 142, 335, 1)];
    lineView.backgroundColor = RGB(245, 245, 245);
    [bgView addSubview:lineView];
    
   
}
- (void)click {
    if (self.selectedHeadView) {
        self.selectedHeadView();
    }
}
- (void)reloadDataWithModel:(ChufangRecordModel *)model
{
    self.dateLabel .text = [NSString stringWithFormat:@"处方日期:%@",model.createTime];
    self.zhusuLabel.text = [NSString stringWithFormat:@"主   诉:%@",model.mainSuit];
    self.ZDLabel.text = [NSString stringWithFormat:@"初步诊断:%@",model.primaryDiagnosis];
    self.optionLabel.text  = [NSString stringWithFormat:@"诊疗意见:%@",model.diagnosisIdea];
}
@end
