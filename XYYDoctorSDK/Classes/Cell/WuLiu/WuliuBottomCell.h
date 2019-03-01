//
//  WuliuBottomCell.h
//  yaolianti
//
//  Created by qxg on 2018/12/14.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DoctorprescriptiontraceModel;
@interface WuliuBottomCell : UITableViewCell
-(void)reloadDataWithModel:(DoctorprescriptiontraceModel *)model;
@end
