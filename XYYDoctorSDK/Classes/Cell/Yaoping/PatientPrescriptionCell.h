//
//  PatientPrescriptionCell.h
//  yaolianti
//
//  Created by qxg on 2018/10/17.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PatientInfoDetailMdel;
@interface PatientPrescriptionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *bottIamge;
-(void)reloadDataWithModel:(PatientInfoDetailMdel*)model;
@end
