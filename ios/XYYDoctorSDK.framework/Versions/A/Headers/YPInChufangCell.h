//
//  YPInChufangCell.h
//  yaolianti
//
//  Created by huangliwen on 2018/6/8.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^onYPDelBlock)(void);
typedef void  (^onWXBlock)(void);
@class YaopinSearchListModel;
@interface YPInChufangCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;

-(void)setOnYPDelBlock:(onYPDelBlock)block;
-(void)reloadDataWithModel:(YaopinSearchListModel*)model;
- (void)setonWXBlock:(onWXBlock)block;

@end
