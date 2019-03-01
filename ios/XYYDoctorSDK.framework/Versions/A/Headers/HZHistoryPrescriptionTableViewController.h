//
//  HZHistoryPrescriptionTableViewController.h
//  yaolianti
//
//  Created by qxg on 2018/10/17.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "BaseTableViewController.h"
@class ChufangRecordModel;
@protocol HZHistoryPrescriptionDelegate <NSObject>
- (void)getHZDruggist:(NSArray*)modelArray model:(ChufangRecordModel*)model;
@end
@interface HZHistoryPrescriptionTableViewController : BaseTableViewController
@property (nonatomic,assign) id <HZHistoryPrescriptionDelegate> delegate;
@property (nonatomic,assign) NSInteger type;
@end
