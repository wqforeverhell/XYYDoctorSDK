//
//  YLTSessionListCell.h
//  yaolianti
//
//  Created by zl on 2018/7/18.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIMAvatarImageView;
@class NIMRecentSession;
@class NIMBadgeView;
@class DoctorWithListDetailModel;
typedef void (^onjieshuBlock)(DoctorWithListDetailModel*recent);
@interface YLTSessionListCell : UITableViewCell

@property (nonatomic,strong) NIMAvatarImageView *avatarImageView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *messageLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) NIMBadgeView *badgeView;
@property (nonatomic,strong) UIButton *jieshuBtn;
@property (nonatomic,strong)DoctorWithListDetailModel *model;
-(void)reloadDataWithModel:(DoctorWithListDetailModel*)model;
-(void)setOnYpBigAddBlock:(onjieshuBlock)block;
@end

