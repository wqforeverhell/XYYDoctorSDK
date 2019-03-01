//
//  HZKaiCFSearchYPController.h
//  yaolianti
//
//  Created by huangliwen on 2018/6/8.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "BaseTableViewController.h"
#import "HuanzheStruce.h"
#import "BaseViewController.h"
@protocol WJSecondViewControllerDelegate <NSObject>
- (void)changeText:(YaopinSearchListModel*)model;
@end
@interface HZKaiCFSearchYPController : BaseViewController
@property(nonatomic,assign)id<WJSecondViewControllerDelegate>delegate;
@end
