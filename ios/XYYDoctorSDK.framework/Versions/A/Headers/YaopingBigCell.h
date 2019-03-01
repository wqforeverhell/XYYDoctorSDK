//
//  YaopingBigCell.h
//  yaolianti
//
//  Created by huangliwen on 2018/6/6.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuanzheStruce.h"
typedef void (^onYpBigAddBlock)(YaopinSearchListModel*model);
typedef void (^onDetailBlock)(YaopinSearchListModel*model);
@class YaopinSearchListModel;
@interface YaopingBigCell : UITableViewCell
@property(nonatomic,strong)YaopinSearchListModel *model;
@property (nonatomic,copy) onDetailBlock detailblock;
-(void)setOnYpBigAddBlock:(onYpBigAddBlock)block;
-(void)reloadDataWithModel:(YaopinSearchListModel*)model;
@end
