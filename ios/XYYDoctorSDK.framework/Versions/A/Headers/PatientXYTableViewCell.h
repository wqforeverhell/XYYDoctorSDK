//
//  PatientXYTableViewCell.h
//  yaolianti
//
//  Created by qxg on 2018/10/15.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GetMyPatientRecordModel;
@interface PatientXYTableViewCell : UITableViewCell
-(void)reloadDataWithModel:(GetMyPatientRecordModel*)model;
@end
