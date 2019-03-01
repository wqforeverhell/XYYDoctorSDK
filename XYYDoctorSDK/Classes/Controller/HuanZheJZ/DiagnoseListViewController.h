//
//  DiagnoseListViewController.h
//  yaolianti
//
//  Created by qxg on 2018/9/14.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^DiagnoseBlock)(NSString*diagnoseStr);
@interface DiagnoseListViewController : BaseViewController
@property (nonatomic,copy) DiagnoseBlock block;
@end
