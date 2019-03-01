//
//  YaopingSmallCell.h
//  yaolianti
//
//  Created by huangliwen on 2018/6/6.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuanzheStruce.h"
typedef void (^onYpSmallAddBlock)(YaopinSearchListModel*model);
//typedef void (^onYpSmallAddBlock)(YaopinSearchListModel*model);
@class YaopinSearchListModel;
@interface YaopingSmallCell : UITableViewCell
@property(nonatomic,strong)YaopinSearchListModel *model;
-(void)setOnYpSmallAddBlock:(onYpSmallAddBlock)block;
-(void)reloadDataWithModel:(YaopinSearchListModel*)model;
@end
