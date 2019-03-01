//
//  YPDetailTableViewController.m
//  yaolianti
//
//  Created by qxg on 2018/10/25.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "YPDetailTableViewController.h"
#import "DetailCell.h"
#import "HuanzheStruce.h"
#import "XYYDoctorSDK.h"
@interface YPDetailTableViewController ()
@end
@implementation YPDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBack];
    [self setupTitleWithString:@"药品详情"];
    //[self setShadoff:CGSizeMake(0, 2) withColor:RGB(202, 202, 202)];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension; // 自适应单元格高度
    self.tableView.estimatedRowHeight = 500;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detail" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row ==0) {
        if ([StringUtil QX_NSStringIsNULL:self.model.useFunction]) {
            cell.detailLabel.text = @"用法:无";
        }else{
           cell.detailLabel.text = [NSString stringWithFormat:@"用法:%@",self.model.useFunction];
        }
    }else if (indexPath.row == 1) {
        if ([StringUtil QX_NSStringIsNULL:self.model.useLevel]) {
            cell.detailLabel.text = @"用量:无";
        }else{
            cell.detailLabel.text = [NSString stringWithFormat:@"用量:%@",self.model.useLevel];
        }
    }else if (indexPath.row == 2) {
        if ([StringUtil QX_NSStringIsNULL:self.model.attendingFunctions]) {
            cell.detailLabel.text = @"主治功能:无";
        }else{
            cell.detailLabel
            .text = [NSString stringWithFormat:@"主治功能:%@",self.model.attendingFunctions];
        }
    }else if (indexPath.row ==3 ) {
        if ([StringUtil QX_NSStringIsNULL:self.model.indication]) {
            cell.detailLabel.text = @"适应症:无";
        }else{
            cell.detailLabel
            .text = [NSString stringWithFormat:@"适应症:%@",self.model.indication];
        }
       
    }else if (indexPath.row == 4) {
        if ([StringUtil QX_NSStringIsNULL:self.model.uneffect]) {
            cell.detailLabel.text = @"不良反应:无";
        }else{
            cell.detailLabel
            .text = [NSString stringWithFormat:@"不良反应:%@",self.model.uneffect];
        }
    }else if (indexPath.row == 5) {
        if ([StringUtil QX_NSStringIsNULL:self.model.medLimit]) {
            cell.detailLabel.text = @"用药禁忌:无";
        }else{
            cell.detailLabel
            .text = [NSString stringWithFormat:@"用药禁忌:%@",self.model.medLimit];
        }
    }else{
        if ([StringUtil QX_NSStringIsNULL:self.model.announcements]) {
            cell.detailLabel.text = @"注意事项:无";
        }else{
            cell.detailLabel
            .text = [NSString stringWithFormat:@"注意事项:%@",self.model.announcements];
        }
    }
 
    return cell;
}
@end
