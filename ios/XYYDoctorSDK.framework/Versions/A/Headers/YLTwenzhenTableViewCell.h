//
//  YLTwenzhenTableViewCell.h
//  yaolianti
//
//  Created by qxg on 2018/9/10.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NIMAvatarImageView;
@class NIMRecentSession;
@class NIMBadgeView;
@class DoctorWithListDetailModel;
typedef void (^onjieshuBlock)(DoctorWithListDetailModel*recent);
@interface YLTwenzhenTableViewCell : UITableViewCell
@property (nonatomic,strong)DoctorWithListDetailModel *model;
-(void)reloadDataWithModel:(DoctorWithListDetailModel*)model;
-(void)setOnYpBigAddBlock:(onjieshuBlock)block;
@end
