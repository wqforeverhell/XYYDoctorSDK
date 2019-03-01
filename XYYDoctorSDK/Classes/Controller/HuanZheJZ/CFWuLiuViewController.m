//
//  CFWuLiuViewController.m
//  yaolianti
//
//  Created by qxg on 2018/12/14.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "CFWuLiuViewController.h"
#import "WuliuTopCell.h"
#import "WuliuNakaCell.h"
#import "WuliuBottomCell.h"
#import "NetPageStruct.h"
#import "YaojishiRefuseCmd.h"
#import "YaojishiRefuseStruce.h"
#import "XYYDoctorSDK.h"
@interface CFWuLiuViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)PageParams *pageParams;
@end
@implementation CFWuLiuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBack];
    self.pageParams = [[PageParams alloc]init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = RGB(240, 240, 240);
    self.codeLabel.text = [NSString stringWithFormat:@"处方单号:%@",self.code];
    [self netGetList:YES];
    [self setupTitleWithString:@"处方流程"];
}
#pragma mark tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.pageParams.result.count>0) {
        return self.pageParams.result.count;
    }
    return 0;
}
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifierTop = @"WuliuTopCell";
    static NSString *CellIdentifierNaka=@"WuliuNakaCell";
    static NSString *CellIdentifierBottom=@"WuliuBottomCell";
    DoctorprescriptiontraceModel *model=[self.pageParams.result objectAtIndex:indexPath.row];
    if (indexPath.row==0) {
        WuliuTopCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierTop];
        if (cell == nil){
            cell = [[WuliuTopCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierTop];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell reloadDataWithModel:model];
        return cell;
    }else if (indexPath.row==self.pageParams.result.count-1){
        WuliuBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierBottom];
        if (cell == nil){
            cell = [[WuliuBottomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierBottom];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell reloadDataWithModel:model];
        return cell;
    }else{
        WuliuNakaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierNaka];
        if (cell == nil){
            cell = [[WuliuNakaCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierNaka];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell reloadDataWithModel:model];
        return cell;
    }
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0||indexPath.row==self.pageParams.result.count-1) {
        return 100;
    }
    return 80;
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
    DoctorprescriptiontraceCmd*cmd=[[DoctorprescriptiontraceCmd alloc] init];
    //[MBProgressHUD showMessag:@"" toView:weakSelf.view];
    cmd.code = self.code;
    [[HttpNetwork getInstance] requestGet:cmd success:^(BaseRespond* rsCode) {
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        id list = [rsCode.data objectForKey:@"result"];
        NSArray* array = [DoctorprescriptiontraceModel arrayFromData:list];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
