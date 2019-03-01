//
//  HuanzheHistoryListViewController.m
//  yaolianti
//
//  Created by qxg on 2018/9/20.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "HuanzheHistoryListViewController.h"
#import "UIView+hlwCate.h"
#import "XYYDoctorSDK.h"
@interface HuanzheHistoryListViewController ()

@end

@implementation HuanzheHistoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBack];
    [self setupTitleWithString:@"已接诊患者"];
    //[self setShadoff:CGSizeMake(0, 2) withColor:RGB(202, 202, 202)];
    self.emptyTipLabel = [[UILabel alloc] init];
    self.emptyTipLabel.text = @"暂无数据";
    [self.emptyTipLabel sizeToFit];
    self.emptyTipLabel.hidden = self.recentSessions.count;
    [self.view addSubview:self.emptyTipLabel];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self refreshSubview];
}
- (void)refresh{
    [super refresh];
    self.emptyTipLabel.hidden = self.recentSessions.count;
}

- (void)refreshSubview{

    self.emptyTipLabel.centerX = self.view.width * .5f;
    self.emptyTipLabel.centerY = self.tableView.height * .05f;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
@end
