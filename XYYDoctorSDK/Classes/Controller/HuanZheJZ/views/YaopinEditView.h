//
//  YaopinEditView.h
//  yaolianti
//
//  Created by huangliwen on 2018/6/9.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuanzheStruce.h"
typedef void (^onYpEditOKBlock)(int num,NSString *singleDosage,NSString*unitName,NSString *yypc,NSString*fyff,NSString*day,NSString *ypbz);
@interface YaopinEditView : UIView
@property (nonatomic,strong) YaopinSearchListModel *model;
-(void)setONYpEditOKBlock:(onYpEditOKBlock)block;
- (void)dismissView;
-(void)showView;
@end
