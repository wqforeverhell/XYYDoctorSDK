//
//  YLTVideoXuanfuView.h
//  yaolianti
//
//  Created by huangliwen on 2018/7/4.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NTESNetCallChatInfo;
@interface YLTVideoXuanfuView : UIButton
+ (instancetype) shareInstance;

@property (nonatomic,strong) NTESNetCallChatInfo *callInfo;

- (void)viewShow;// 试图出现
- (void)viewHidden;//视图消失
@end
