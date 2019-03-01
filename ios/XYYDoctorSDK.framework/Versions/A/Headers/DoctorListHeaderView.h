//
//  DoctorListHeaderView.h
//  yaolianti
//
//  Created by qxg on 2018/10/18.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  YaopinMoBanModel;
@interface DoctorListHeaderView : UITableViewHeaderFooterView
@property (nonatomic,weak)UILabel *nameLabel;
@property (nonatomic,weak) UIButton *deleteBtn;
@property (nonatomic,weak) UIButton *editBtn;
@property (nonatomic,strong)YaopinMoBanModel *model;
@property(copy,nonatomic)void(^selectedEditHeadView)(YaopinMoBanModel *model);
@property(copy,nonatomic)void(^selectedDeleteHeadView)(YaopinMoBanModel *model);
-(void)reloadDataWithModel:(YaopinMoBanModel*)model;
@end
