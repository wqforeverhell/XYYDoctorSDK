//
//  HZHistoryPrescriptionTableViewController.m
//  yaolianti
//
//  Created by qxg on 2018/10/17.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "HZHistoryPrescriptionTableViewController.h"
#import "HZHeaderView.h"
#import "PatientPrescriptionCell.h"
#import "NetPageStruct.h"
#import "MJRefresh.h"
#import "RecordCmd.h"
#import "RecordStruce.h"
#import "ViewUtil.h"
#import "XYYDoctorSDK.h"
@interface HZHistoryPrescriptionTableViewController ()
@property (nonatomic,strong)NSMutableArray *isOpenArr;
@property (nonatomic, strong)  PageParams *pageParams;
@end

@implementation HZHistoryPrescriptionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBack];
    self.pageParams = [[PageParams alloc]init];
    [self setShadoff:CGSizeMake(0, 2) withColor:RGB(202, 202, 202)];
    [self setupTitleWithString:[NSString stringWithFormat:@"%@的历史处方",[ConfigUtil stringWithKey:LASTCHARTYDNAME]]];
    self.view.backgroundColor = RGB(240, 240, 240);
    self.tableView.backgroundColor = RGB(240, 240, 240);
    self.tableView.tableFooterView = [UIView new];
    self.isOpenArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.estimatedRowHeight = 60;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    WS(weakSelf);
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf netGetList:YES];
    }];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf netGetList:NO];
    }];
    [self.tableView.header beginRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.pageParams.result.count;
}
-(BOOL)needRegisterHideKeyboard{
    return NO;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//   NSString*  state=[self.isOpenArr objectAtIndex:section];
//    if ([state isEqualToString:@"open"]) {
        ChufangRecordModel *model = self.pageParams.result[section];
        NSArray*  arr= model.detailList;;
        return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PatientPrescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"preCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ChufangRecordModel *model = self.pageParams.result[indexPath.section];
    NSArray *array = model.detailList;
    PatientInfoDetailMdel *detailModel = [[PatientInfoDetailMdel alloc]initWithDictionary:array[indexPath.row]];
    [cell reloadDataWithModel:detailModel];
    [NSGCDThread dispatchAfterInMailThread:^{
        if (indexPath.row == array.count -1) {
            cell.bottIamge.hidden = YES;
            [ViewUtil ShearRoundCornersWidthLayer:cell.bgView.layer type:LXKShearRoundCornersTypeBottom radiusSize:4];
        }
    } Delay:1000];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return AutoY375(153);
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat sectionHeaderHeight = 153;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y> 0) {
    scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }else if(scrollView.contentOffset.y >= sectionHeaderHeight){
   scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
     }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ChufangRecordModel*model = self.pageParams.result[section];
    HZHeaderView *headerView = [[HZHeaderView alloc]initWithReuseIdentifier:@"header"];
    [headerView reloadDataWithModel:model];
    headerView.arrowIamgeView.hidden =YES;
    if (_type==0) {
        headerView.selectBtn .hidden = NO;
    }else{
        headerView.selectBtn.hidden = YES;
    }
    WS(weakSelf);
    headerView.selectedHeadView = ^{
        NSArray *array = model.detailList;
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(getHZDruggist:model:)]) {
            [weakSelf.delegate getHZDruggist:array model:model];
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    return headerView;
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    ChufangRecordModel *model = self.pageParams.result[indexPath.section];
//    NSArray *array = model.detailList;
//    if (self.delegate && [self.delegate respondsToSelector:@selector(getHZDruggist:)]) {
//        [self.delegate getHZDruggist:array model:model];
//    }
//    [self.navigationController popViewControllerAnimated:YES];
//}
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
    GetHistroyPrescriptionListByCmd*cmd=[[GetHistroyPrescriptionListByCmd alloc] init];
    cmd.pageSize = self.pageParams.num;
    cmd.pageNum = self.pageParams.page;
    cmd.startDate = @"";
    cmd.endDate = @"";
    cmd.patientName = [ConfigUtil stringWithKey:LASTCHARTYDNAME] ;
    cmd.patientTel = [ConfigUtil stringWithKey:PHONENUM];
    [MBProgressHUD showMessag:@"" toView:weakSelf.view];
    [[HttpNetwork getInstance] request:cmd success:^(BaseRespond* rsCode) {
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        id list = [rsCode.data objectForKey:@"result"];
        NSArray* array = [ChufangRecordModel arrayFromData:list] ;
        if (isRefresh) {
            [weakSelf.pageParams.result removeAllObjects];
            [self.isOpenArr removeAllObjects];
        }
        if (array.count<weakSelf.pageParams.num) {
            weakSelf.pageParams.hasMore = NO;
            //[weakSelf.tableView.footer noticeNoMoreData];
        }else {
            weakSelf.pageParams.hasMore = YES;
        }
        if (array.count > 0) {
            [weakSelf.pageParams.result addObjectsFromArray:array];
            for (int i=0; i<self.pageParams.result.count; i++) {
                NSString*  state=@"close";
                [self.isOpenArr addObject:state];
            }
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
