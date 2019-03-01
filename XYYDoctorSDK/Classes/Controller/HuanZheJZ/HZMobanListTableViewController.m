//
//  HZMobanListTableViewController.m
//  yaolianti
//
//  Created by qxg on 2018/10/18.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "HZMobanListTableViewController.h"
#import "MobanListTableViewCell.h"
#import "DoctorListHeaderView.h"
#import "HuanzheCmd.h"
#import "NetPageStruct.h"
#import "MJRefresh.h"
#import "HuanzheStruce.h"
#import "ViewUtil.h"
#import "XYYDoctorSDK.h"
@interface HZMobanListTableViewController ()
@property (nonatomic,strong)PageParams *pageParams;
@end

@implementation HZMobanListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBack];
    [self setupTitleWithString:@"模板列表" ];
    self.tableView.backgroundColor = RGB(240, 240, 240);
    self.tableView.tableFooterView = [UIView new];
    self.view.backgroundColor = RGB(240, 240, 240);
    [self setShadoff:CGSizeMake(0, 2) withColor:RGBA(202, 202, 202, 0.5)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.pageParams = [[PageParams alloc]init];
}
- (void)viewWillAppear:(BOOL)animated {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    YaopinMoBanModel *model = self.pageParams.result[section];
    NSArray*  arr= model.hospDoctorPrescriptTemplateDetail;;
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MobanListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YaopinMoBanModel *model = self.pageParams.result[indexPath.section];
    NSArray *array = model.hospDoctorPrescriptTemplateDetail;
    YaopinSearchListModel *detailModel = [[YaopinSearchListModel alloc]initWithDictionary:array[indexPath.row]];
     [cell reloadDataWithModel:detailModel isyj:(indexPath.row == array.count -1)];
//    [NSGCDThread dispatchAfterInMailThread:^{
//        if (indexPath.row == array.count -1) {
////            cell.bottIamge.hidden = YES;
//            [ViewUtil ShearRoundCornersWidthLayer:cell.bgView.layer type:LXKShearRoundCornersTypeBottom radiusSize:4];
//        }
//    } Delay:1000];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AutoY375(50);
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    YaopinMoBanModel *model = self.pageParams.result[section];
    DoctorListHeaderView *headerView = [[DoctorListHeaderView alloc]initWithReuseIdentifier:@"header"];
    [headerView reloadDataWithModel:model];
    //编辑
     WS(weakSelf);
    headerView.selectedEditHeadView = ^(YaopinMoBanModel *model) {
        [JumpUtil pushMoBanVC:weakSelf model:model mArray:nil];
    };
    //删除
    headerView.selectedDeleteHeadView = ^(YaopinMoBanModel *model) {
        
        [MBProgressHUD showMessag:@"" toView:weakSelf.view];
        HospDoctorPrescriptTemplateDeleteCmd *cmd = [[HospDoctorPrescriptTemplateDeleteCmd alloc]init];
        cmd.equalId = model.equalId;
        [[HttpNetwork getInstance] request:cmd success:^(BaseRespond *respond) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            [NSGCDThread dispatchAfterInMailThread:^{
                [self netGetList:YES];
            } Delay:1000];
            
        } failed:^(BaseRespond *respond, NSString *error) {
            [MBProgressHUD showError:error toView:weakSelf.view];
        }];
    };
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
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
    HospDoctorPrescriptTemplateListCmd*cmd=[[HospDoctorPrescriptTemplateListCmd alloc] init];
    //[MBProgressHUD showMessag:@"" toView:weakSelf.view];
    [[HttpNetwork getInstance] request:cmd success:^(BaseRespond* rsCode) {
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        id list = [rsCode.data objectForKey:@"result"];
        NSArray* array = [YaopinMoBanModel arrayFromData:list];
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
