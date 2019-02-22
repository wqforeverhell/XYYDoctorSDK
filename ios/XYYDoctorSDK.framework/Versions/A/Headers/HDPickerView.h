//
//  HDPickerView.h
//  PickerView
//
//  Created by 侯荡荡 on 17/6/26.
//  Copyright © 2017年 HoHoDoDo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectPickerValue)(NSString *value, NSInteger component, NSInteger row);

@interface HDPickerView : UIView
/*!
 * @brief 初始化picker
 * @param dataSource picker数据源
 * @param block 返回值回调
 * @return self
 */
- (instancetype)initPickerViewWithDataSource:(NSMutableArray *)dataSource selectVaule:(SelectPickerValue)block;
- (void)show;
- (void)hide;
@end
