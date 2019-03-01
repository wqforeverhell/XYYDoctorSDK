//
//  HZZhuSTableViewController.h
//  yaolianti
//
//  Created by qxg on 2018/10/29.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "BaseTableViewController.h"
typedef void (^ZSBlock)(NSString*zhusuStr);
@interface HZZhuSTableViewController : BaseTableViewController
@property (nonatomic,copy) ZSBlock block;
@end
