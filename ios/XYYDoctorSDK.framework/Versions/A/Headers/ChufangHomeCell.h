//
//  ChufangHomeCell.h
//  yaolianti
//
//  Created by huangliwen on 2018/6/6.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChufangRecordModel;
@interface ChufangHomeCell : UITableViewCell
@property (nonatomic,copy) void (^OnWuliuCodeBlock)(ChufangRecordModel*model);
@property (nonatomic,strong)ChufangRecordModel*model;
-(void)reloadDataWithModel:(ChufangRecordModel*)model isshow:(BOOL)ishow;
@end
