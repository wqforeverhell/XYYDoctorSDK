//
//  MobanTableViewCell.h
//  yaolianti
//
//  Created by zl on 2018/7/9.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YaopinSearchListModel;
typedef void (^onDetailBlock)(YaopinSearchListModel*model);
@interface MobanTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelPack;
@property (weak, nonatomic) IBOutlet UILabel *labelProduct;
@property (nonatomic,strong) YaopinSearchListModel *model;
@property (nonatomic,copy) onDetailBlock block;
-(void)reloadDataWithModel:(YaopinSearchListModel*)model;
@end
