//
//  DiagnoseListViewController.m
//  yaolianti
//
//  Created by qxg on 2018/9/14.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "DiagnoseListViewController.h"
#import "NetPageStruct.h"
#import "HuanzheStruce.h"
#import "HuanzheCmd.h"
#import "DiagnoseListTableViewCell.h"
#import "MJRefresh.h"
#import "XYYDoctorSDK.h"
@interface DiagnoseListViewController ()<UITableViewDelegate,UISearchBarDelegate,UITableViewDataSource,DiagnoselistDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)PageParams *pageParams;
@property (nonatomic, strong) NSMutableArray *selectedShop;//选中的商品数组
@property(nonatomic,strong)UISearchBar *search;
@property (nonnull,nonatomic,copy)NSString *key;
@end
@implementation DiagnoseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBack];
    self.tableView.backgroundColor = RGB(240, 240, 240);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self setupNextWithString:@"确定" withColor:RGB(2, 175, 102)];
    self.pageParams = [[PageParams alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.search];
    WS(weakSelf);
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf netGetList:YES];
    }];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf netGetList:NO];
    }];
    [self.tableView.header beginRefreshing];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_search removeFromSuperview];
}
- (void)onNext{
    if (self.selectedShop.count <1) {
        
    }else{
        NSMutableArray *strArray = [NSMutableArray new];
        for (DiagnoselistModel*model in self.selectedShop) {
            [strArray addObject:model.sysptomName];
        }
        if (_block) {
            _block([strArray componentsJoinedByString:@";"]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pageParams.result.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiagnoseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list"];
    if (cell == nil){
        cell = [[DiagnoseListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"list"];
        cell.delegate = self;
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    DiagnoselistModel *model = self.pageParams.result[indexPath.row];
    [cell reloadDataWithModel:model type:1];
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
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//   DiagnoselistModel *model = self.pageParams.result[indexPath.row];
//    NSIndexPath *indexPat = [self.tableView indexPathForSelectedRow];
//    DiagnoseListTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPat];
//    [self cell:cell selected:model.isSelected indexPath:indexPath];
//
//}
#pragma mark ui界面绘制
-(UISearchBar*)search{
    if (!_search) {
        //导航栏搜索框
        _search = [[UISearchBar alloc] initWithFrame:CGRectMake(50, 5, SCREEN_WIDTH-125, 33)];
        _search.delegate = self;
        [_search setSearchBarStyle:UISearchBarStyleMinimal];
        _search.tintColor=HEISE_COLOR;
        _search.placeholder=@"请输入诊断关键字";
        // ** 自定义searchBar的样式 **
        UITextField* searchField = nil;
        // 注意searchBar的textField处于孙图层中
        for (UIView* subview  in [_search.subviews firstObject].subviews) {
            NSLog(@"%@", subview.class);
            // 打印出两个结果:
            if ([subview isKindOfClass:[UITextField class]]) {
                
                searchField = (UITextField*)subview;
                // leftView就是放大镜
                searchField.leftView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hzcf_search_icon"]];
                // 删除searchBar输入框的背景
                [searchField setBackground:nil];
                [searchField setBorderStyle:UITextBorderStyleNone];
                
                //searchField.backgroundColor = LINE_COLOR;
                
                // 设置圆角
                searchField.layer.borderColor=LINE_COLOR.CGColor;
                searchField.layer.borderWidth=1;
                searchField.layer.cornerRadius = 16.5;
                searchField.layer.masksToBounds = YES;
                
                break;
            }
        }
    }
    return _search;
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
    DiagnoseListCmd *cmd = [[DiagnoseListCmd alloc]init];
    [MBProgressHUD showMessag:@"" toView:self.view];
    cmd.searchKey = _key;
    cmd.pageNum = self.pageParams.page;
    cmd.pageSize = 15;
    WS(weakSelf);
    [[HttpNetwork getInstance] request:cmd success:^(BaseRespond* rsCode) {
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        id list = [rsCode.data objectForKey:@"result"];
        NSArray* array = [DiagnoselistModel arrayFromData:list];
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
            [weakSelf.pageParams.result addObjectsFromArray:array];
            [weakSelf.tableView.footer setTitle:@"" forState:MJRefreshFooterStateNoMoreData];
        }else if(weakSelf.pageParams.result.count==0){
            [weakSelf.tableView.footer setTitle:@"暂无数据..." forState:MJRefreshFooterStateNoMoreData];
           // [weakSelf.tableView.footer noticeNoMoreData];
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
#pragma mark searchBar代理
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if ([_search isFirstResponder]) {
        [_search resignFirstResponder];
    }
    //搜索
    _key=_search.text;
    [self netGetList:YES];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //查找获取焦点
    _key = searchText;
    [self netGetList:YES];
}

- (NSMutableArray *)selectedShop {
    if (!_selectedShop) {
        _selectedShop = [[NSMutableArray alloc] init];
    }
    return _selectedShop;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
