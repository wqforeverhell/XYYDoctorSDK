//
//  MobanListTableViewCell.h
//  yaolianti
//
//  Created by qxg on 2018/10/18.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YaopinSearchListModel;
@interface MobanListTableViewCell : UITableViewCell
-(void)reloadDataWithModel:(YaopinSearchListModel*)model isyj:(BOOL)isyj;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
