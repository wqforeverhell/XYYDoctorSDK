//
//  HZXYTableViewController.m
//  yaolianti
//
//  Created by qxg on 2018/10/15.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "HZXYTableViewController.h"
#import "NetPageStruct.h"
#import "MJRefresh.h"
#import "UserCmd.h"
#import "UserStruce.h"
#import "PatientXYTableViewCell.h"
#import "XYYDoctorSDK.h"
@interface HZXYTableViewController ()
@property (nonatomic, strong)  PageParams *pageParams;
@end
@implementation HZXYTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBack];
    self.pageParams = [[PageParams alloc]init];
    WS(weakSelf);
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf netGetList:YES];
    }];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf netGetList:NO];
    }];
    [self.tableView.header beginRefreshing];
    [self setupTitleWithString:[NSString stringWithFormat:@"%@的健康档案",[ConfigUtil stringWithKey:LASTCHARTYDNAME]]];
    self.tableView.tableFooterView = [UIView new];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.pageParams.result.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PatientXYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xyCell" forIndexPath:indexPath];
    GetMyPatientRecordModel *model = self.pageParams.result[indexPath.row];
    [cell reloadDataWithModel:model];
     return cell;
}
//网络数据
-(void)netGetList:(BOOL) isRefresh   {
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
    
    WS(weakSelf);
    GetPatientHealthCmd*cmd=[[GetPatientHealthCmd alloc] init];
    cmd.pageSize = self.pageParams.num;
    cmd.pageNum = self.pageParams.page;
    cmd.name = [ConfigUtil stringWithKey:LASTCHARTYDNAME];
    cmd.phoneNum = [ConfigUtil stringWithKey:PHONENUM];
    [MBProgressHUD showMessag:@"" toView:weakSelf.view];
    [[HttpNetwork getInstance] requestGet:cmd success:^(BaseRespond* rsCode) {
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        id list = [rsCode.data objectForKey:@"result"];
        NSArray* array = [GetMyPatientRecordModel arrayFromData:list] ;
        if (isRefresh) {
            [weakSelf.pageParams.result removeAllObjects];
        }
        if (array.count<weakSelf.pageParams.num) {
            weakSelf.pageParams.hasMore = NO;
            //[weakSelf.tableView.footer noticeNoMoreData];
        }else {
            weakSelf.pageParams.hasMore = YES;
        }
        if (array.count > 0) {
            [weakSelf.pageParams.result addObjectsFromArray:array];
            [weakSelf.tableView.footer setTitle:@"" forState:MJRefreshFooterStateNoMoreData];
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
