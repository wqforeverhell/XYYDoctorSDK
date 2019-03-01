//
//  HZZhuSTableViewController.m
//  yaolianti
//
//  Created by qxg on 2018/10/29.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "HZZhuSTableViewController.h"
#import "DiagnoseListTableViewCell.h"
#import "HuanzheCmd.h"
#import "HuanzheStruce.h"
#import "NetPageStruct.h"
#import "MJRefresh.h"
#import "XYYDoctorSDK.h"
@interface HZZhuSTableViewController ()<DiagnoselistDelegate>
@property (nonatomic,strong)PageParams *pageParams;
@property (nonatomic, strong) NSMutableArray *selectedShop;//选中的商品数组
@end
@implementation HZZhuSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTitleWithString:@"主诉列表"];
    [self setupBack];
    self.tableView.backgroundColor = RGB(240, 240, 240);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self setupNextWithString:@"确定" withColor:RGB(2, 175, 102)];
    self.pageParams = [[PageParams alloc]init];
    self.selectedShop = [[NSMutableArray alloc] initWithCapacity:0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    WS(weakSelf);
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf netGetList:YES];
    }];
    [self.tableView.header beginRefreshing];
}
- (void)onNext{
    if (self.selectedShop.count <1) {
        
    }else{
        NSMutableArray *strArray = [NSMutableArray new];
        for (DiagnoselistModel*model in self.selectedShop) {
            [strArray addObject:model.suitName];
        }
        if (_block) {
            _block([strArray componentsJoinedByString:@";"]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.pageParams.result.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiagnoseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list" forIndexPath:indexPath];
    
    cell.delegate =  self;
    cell.indexPath = indexPath;
    DiagnoselistModel *model = self.pageParams.result[indexPath.row];
    [cell reloadDataWithModel:model type:2];
    
    return cell;
}
- (void)cell:(DiagnoseListTableViewCell *)cell selected:(BOOL)isSelected indexPath:(NSIndexPath *)indexPath
{
    DiagnoselistModel *model = self.pageParams.result[indexPath.row];
    model.isSelected = isSelected;
    cell.indexPath = indexPath;
    if (isSelected) {
        [self.selectedShop addObject:model];
    }else{
        [self.selectedShop removeObject:model];
    }
    [self.tableView reloadData];
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
    SymptomCmd *cmd = [[SymptomCmd alloc]init];
    [MBProgressHUD showMessag:@"" toView:self.view];
    WS(weakSelf);
    [[HttpNetwork getInstance] request:cmd success:^(BaseRespond* rsCode) {
        [weakSelf.tableView.header endRefreshing];
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        id list = [rsCode.data objectForKey:@"result"];
        NSArray* array = [DiagnoselistModel arrayFromData:list];
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
