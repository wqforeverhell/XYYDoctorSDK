//
//  YPEditCell.h
//  yaolianti
//
//  Created by qxg on 2018/10/25.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^onYPDelBlock)(void);
typedef void  (^onWXBlock)(void);
@class YaopinSearchListModel;
@interface YPEditCell : UITableViewCell
-(void)setOnYPDelBlock:(onYPDelBlock)block;
-(void)reloadDataWithModel:(YaopinSearchListModel*)model;
- (void)setonWXBlock:(onWXBlock)block;
@end
