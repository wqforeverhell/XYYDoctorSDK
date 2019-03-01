//
//  HZMoBanTableViewController.h
//  yaolianti
//
//  Created by zl on 2018/7/9.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "BaseViewController.h"
@protocol mobanValueDelegate <NSObject>
- (void)passValue:(NSArray *)mobanArray;
@end
@interface HZMoBanTableViewController : BaseViewController
@property(nonatomic,assign)id<mobanValueDelegate>delegate;
@end
