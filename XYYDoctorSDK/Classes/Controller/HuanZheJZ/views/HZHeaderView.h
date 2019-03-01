//
//  HZHeaderView.h
//  yaolianti
//
//  Created by qxg on 2018/10/17.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChufangRecordModel;
@interface HZHeaderView : UITableViewHeaderFooterView
@property (nonatomic,weak)UILabel *dateLabel;
@property (nonatomic,weak)UILabel *zhusuLabel;
@property (nonatomic,weak)UILabel *ZDLabel;
@property (nonatomic,weak) UILabel *optionLabel;
@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,weak) UIButton *selectBtn;
@property (nonatomic,strong) UIImageView *arrowIamgeView;
@property(copy,nonatomic)void(^selectedHeadView)(void);
-(void)reloadDataWithModel:(ChufangRecordModel*)model;
@end
