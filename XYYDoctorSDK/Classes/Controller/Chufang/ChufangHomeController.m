//
//  ChufangHomeController.m
//  yaolianti
//
//  Created by huangliwen on 2018/6/6.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "ChufangHomeController.h"
#import "NetPageStruct.h"
#import "MJRefresh.h"
#import "ChufangHomeCell.h"
#import "ImageUtil.h"
#import "RecordCmd.h"
#import "RecordStruce.h"
#import "NetPageStruct.h"
#import "ChufangPreviewViewController.h"
#import "ChaxunViewController.h"
#import "StringUtil.h"
#import "XYYDoctorSDK.h"
@interface ChufangHomeController ()<chaXunMessageDetegate>
@property (nonatomic, strong) PageParams* pageParams;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *beginTime;
@property (nonatomic,copy)NSString *endTime;
@end
@implementation ChufangHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBack];
    self.tableView.backgroundColor = RGB(240, 240, 240);
    self.pageParams = [[PageParams alloc]init];
    self.tableView .frame =CGRectMake(0, 100, 200, 200) ;
    [self setupTitleWithString:@"处方单记录" withColor:RGB(51, 51, 51)];
    [self setupNextWithString:@"筛选" withColor:RGB(2, 175, 102)];
    //[self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)onNext
{
    [JumpUtil pushChaxunVc:self delegate:self type:1];
}
#pragma -==== chaXunMessageDetegate
- (void)getChaxunMessageWithName:(NSString *)name phoneNum:(NSString *)phoneNum beginTime:(NSString *)beginTime endTime:(NSString *)endTime
{
    _name = name;
    _phone = phoneNum;
    _beginTime = beginTime;
    _endTime = endTime;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    WS(weakSelf);
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf netGetList:YES];
    }];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf netGetList:NO];
    }];
    [self.tableView.header beginRefreshing];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pageParams.result.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ChufangHomeCell";
    ChufangRecordModel *model = self.pageParams.result[indexPath.row];
    ChufangHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.userInteractionEnabled = YES;
    if (cell == nil){
        cell = [[ChufangHomeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.OnWuliuCodeBlock = ^(ChufangRecordModel *model) {
       [JumpUtil pushWuLiuVC:self code:model.code];
    };
    [cell reloadDataWithModel:model isshow:YES];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChufangRecordModel *model = self.pageParams.result[indexPath.row];
    CGFloat h=[StringUtil calculateRowHeight:[NSString stringWithFormat:@"初步诊断:%@",model.primaryDiagnosis] fontSize:14 w:SCREEN_WIDTH-35];
    return 143+h+47;
}
- (BOOL)needRegisterHideKeyboard{
    return NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChufangRecordModel *model = self.pageParams.result[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChufangPreviewViewController *chufangVC = [ChufangPreviewViewController new];
    chufangVC.hidesBottomBarWhenPushed = YES;
    chufangVC.chufangCode = model.code;
    [self.navigationController pushViewController:chufangVC animated:YES];
}
#pragma mark 网络请求
-(void)netGetList:(BOOL) isRefresh {
    if (!isRefresh) {
        if (!self.pageParams.hasMore) {
            [self.tableView.footer noticeNoMoreData];
            return;
        }
        self.pageParams.page++;
    }else {
        self.pageParams.page = 1;
        [self.tableView.footer resetNoMoreData];
    }
   GetPrescriptionListByCmd *cmd=[[GetPrescriptionListByCmd alloc] init];
    cmd.pageNum = self.pageParams.page;
    cmd.pageSize = self.pageParams.num;
    cmd.endDate = _endTime;
    cmd.patientName = _name;
    cmd.patientTel = _phone;
    cmd.startDate = _beginTime;
    WS(weakSelf);
    [[HttpNetwork getInstance] request:cmd success:^(BaseRespond* rsCode) {
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
        id list = [rsCode.data objectForKey:@"result"];
        NSArray* array = [ChufangRecordModel arrayFromData:list];
        if (isRefresh) {
            [weakSelf.pageParams.result removeAllObjects];
        }
        if (array.count<weakSelf.pageParams.num) {
            weakSelf.pageParams.hasMore = NO;
            [weakSelf.tableView.footer noticeNoMoreData];
        }else {
            weakSelf.pageParams.hasMore = YES;
        }
        if (array.count > 0) {
             [weakSelf.tableView.footer setTitle:@"" forState:MJRefreshFooterStateNoMoreData];
            [weakSelf.pageParams.result addObjectsFromArray:array];
        }else if(weakSelf.pageParams.result.count==0){
            [weakSelf.tableView.footer setTitle:@"暂无数据..." forState:MJRefreshFooterStateNoMoreData];
            [weakSelf.tableView.footer noticeNoMoreData];
        }
        [NSGCDThread dispatchAsyncInMailThread:^(){
            [weakSelf.tableView reloadData];
        }];
    } failed:^(BaseRespond* respond, NSString* error) {
        [weakSelf.tableView.header endRefreshing];
        // 访问失败或者取消访问
        //[weakSelf.pageParams.result removeAllObjects];
        if (weakSelf.pageParams.result.count==0) {
            [weakSelf.tableView.footer setTitle:error forState:MJRefreshFooterStateNoMoreData];
            [weakSelf.tableView.footer noticeNoMoreData];
        }
        [MBProgressHUD showError:error toView:weakSelf.view];
        [NSGCDThread dispatchAsyncInMailThread:^(){
            [weakSelf.tableView reloadData];
        }];
    }];
}
@end
