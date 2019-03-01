//
//  HZKaiCFSearchYPController.m
//  yaolianti
//
//  Created by huangliwen on 2018/6/8.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "HZKaiCFSearchYPController.h"
#import "YaopingBigCell.h"
#import "YaopingSmallCell.h"
#import "ViewUtil.h"
#import "YaopinEditView.h"
#import "HuanzheCmd.h"
#import "MJRefresh.h"
#import "NetPageStruct.h"
#import "StringUtil.h"
#import "XYYDoctorSDK.h"
@interface HZKaiCFSearchYPController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)YaopinEditView *YpEditView;
@property(nonatomic,strong)UISearchBar *search;
@property(nonatomic,strong)UIButton *btnSearch;
@property(nonatomic,strong)PageParams *pageParams;
@property(nonatomic,strong)YaopinSearchListModel *model;
@property(nonatomic,nonnull,copy) NSString* key;
@property(nonatomic,strong)NSMutableArray *nameArray;
@property(nonatomic,strong)NSMutableArray *yaoPInArray;
@end
@implementation HZKaiCFSearchYPController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBack];
    [self.view setBackgroundColor:RGB(240, 240, 240)];
    [self setupTitleWithString:@"添加药品"];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake375(0, 0, 375, 50)];
    bgView.backgroundColor = RGB(255, 255, 255);
    bgView.layer.shadowOffset = CGSizeMake(0, 2);
    bgView.layer.shadowColor = RGB(202, 202, 202).CGColor;
    bgView.layer.shadowOpacity = 0.5f;
    [self.view addSubview:bgView];
    [bgView addSubview:self.search];
//    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake375(0, 50, 375, 617) style:UITableViewStylePlain];
//    [self.view addSubview:self.tableView];
    [self configTabelView];
    self.yaoPInArray = [[NSMutableArray alloc]initWithCapacity:0];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;;
    //注册cell
    NSString *BundlePath = [FileUtil getSDKResourcesPath];
    NSBundle *sampleBundle = [NSBundle bundleWithPath:BundlePath];
    UINib* nib = [UINib nibWithNibName:@"YaopingBigCell" bundle:sampleBundle];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"YaopingBigCell"];
    //注册cell
    UINib* snib = [UINib nibWithNibName:@"YaopingSmallCell" bundle:sampleBundle];
    [self.tableView registerNib:snib forCellReuseIdentifier:@"YaopingSmallCell"];
     self.pageParams = [[PageParams alloc]init];
    //[self netGetData];
    
//    WS(weakSelf);
//    [self.tableView addLegendHeaderWithRefreshingBlock:^{
//        [weakSelf netGetList:YES];
//    }];
//    [self.tableView addLegendFooterWithRefreshingBlock:^{
//        [weakSelf netGetList:NO];
//    }];
//   
//    [self.tableView.header beginRefreshing];
     [self netGetList:YES];
    _key = @"";
    self.nameArray = [[NSMutableArray alloc]initWithCapacity:0];
    
}
- (void)configTabelView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake375(0, 50, 375, 607)style:UITableViewStylePlain];
     self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGB(240, 240, 240);
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)needRegisterHideKeyboard{
    return NO;
}
#pragma mark 生命周期
-(void)dealloc{
    if (_YpEditView) {
        [self.YpEditView dismissView];
    }
}
#pragma mark ui界面绘制
-(UISearchBar*)search{
    if (!_search) {
        //导航栏搜索框
        _search = [[UISearchBar alloc] initWithFrame:CGRectMake375(14, 8, 345, 35)];
        _search.delegate = self;
        [_search setSearchBarStyle:UISearchBarStyleMinimal];
        _search.tintColor=HEISE_COLOR;
        _search.placeholder=@"请输入药品名称";
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
               searchField.backgroundColor = RGB(238, 238, 238);
                // 设置圆角
//                searchField.layer.borderColor=LINE_COLOR.CGColor;
//                searchField.layer.borderWidth=1;
                searchField.layer.cornerRadius = CGRectGetHeight(_search.frame)/2;
                searchField.layer.masksToBounds = YES;
                
                break;
            }
        }
    }
    return _search;
}
-(UIButton *)btnSearch{
    if (!_btnSearch) {
        _btnSearch=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-65, 5, 50, 33)];
//        [ViewUtil setJianbianToView:_btnSearch colorType:JianBianGreen frame:_btnSearch.bounds];
        [_btnSearch setTitle:@"搜索" forState:0];
        _btnSearch.titleLabel.font = FONT(16);
         [_btnSearch setTitleColor:HEISE_COLOR forState:UIControlStateNormal];
        _btnSearch.layer.cornerRadius=_btnSearch.bounds.size.height/2;
        _btnSearch.layer.masksToBounds=YES;
        [_btnSearch addTarget:self action:@selector(onSearch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSearch;
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}
//组头
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return [UIView new];
    }
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:0];
    for (NSDictionary *dic in self.nameArray) {
        NSString *name = dic[@"functionName"];
        [arr addObject:name];
    }
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UIView *viewbg=[[UIView alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-24, 40)];
    [view addSubview:viewbg];
    [ViewUtil setJianbianToView:viewbg colorType:JianBianGreen frame:viewbg.bounds];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(12, 0, 200, 40)];
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:16];
    label.text=[NSString stringWithFormat:@"%@",arr[section]];
    [viewbg addSubview:label];
    return view;
}
//组尾
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 10;
//}
//-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
//    return view;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSArray *array=[_dataArray objectAtIndex:section];
        return self.pageParams.result.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section==0) {
        static NSString *CellIdentifier = @"YaopingBigCell";
        YaopingBigCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            cell = [[YaopingBigCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        YaopinSearchListModel *model = self.pageParams.result[indexPath.row];
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
        WS(weakSelf);
//        [cell setOnYpBigAddBlock:^{
//            [weakSelf.YpEditView setHidden:NO];
//        }];
        [cell reloadDataWithModel:model];
        [cell setOnYpBigAddBlock:^(YaopinSearchListModel *model) {
            weakSelf.model = model;
            [weakSelf.YpEditView setHidden:NO];
            weakSelf.YpEditView.model = weakSelf.model;
        }];
    cell.detailblock = ^(YaopinSearchListModel *model) {
        [JumpUtil pushDetail:weakSelf dict:model];
    };
        return cell;
 //  }
//    YaopinSearchListModel *model = self.yaoPInArray[indexPath.row];
//    static NSString *CellIdentifier = @"YaopingSmallCell";
//    YaopingSmallCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil){
//        cell = [[YaopingSmallCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//    }
//    [cell reloadDataWithModel:model];
//    WS(weakSelf);
//    [cell setOnYpSmallAddBlock:^(YaopinSearchListModel *model) {
//        self.model = model;
//
//        [weakSelf.YpEditView setHidden:NO];
//        weakSelf.YpEditView.model = self.model;
//    }];
  //   return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!indexPath.section) {
        YaopinSearchListModel *model = self.pageParams.result[indexPath.row];
        CGFloat h=[StringUtil calculateRowHeight:model.commonName fontSize:16 w:SCREEN_WIDTH-38];
        return h+87;
    }else{
        return 58;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    YaopingBigCell * cell = (YaopingBigCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
     YaopinSearchListModel *model = self.pageParams.result[indexPath.row];
    [JumpUtil pushDetail:self dict:model];
}
#pragma mark UI界面
-(YaopinEditView*)YpEditView{
    if (!_YpEditView) {
        _YpEditView=[JumpUtil loadFromXib:@"YaopinEditView" withCls:[YaopinEditView class]];
        self.model.number = 1;
       
        WS(weakSelf);
        [_YpEditView setONYpEditOKBlock:^(int num, NSString *singleDosage,NSString*unitName, NSString *yypc, NSString *fyff, NSString *day,NSString*ypbz) {
            weakSelf.model.number = num;
            weakSelf.model.singleDosage = singleDosage;
            weakSelf.model.unitName = unitName;
            weakSelf.model.useFunction = fyff;
            weakSelf.model.directions = yypc;
            weakSelf.model.directionsTime = [day integerValue];
            weakSelf.model.remark = ypbz;
            [weakSelf.delegate changeText:weakSelf.model];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
        [_YpEditView showView];
    }
    return _YpEditView;
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
}

#pragma mark 点击事件
-(void)onSearch{
    //搜索
    _key = _search.text;
    [self netGetList:YES];
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
    GetYaoPinDetailListCmd*cmd=[[GetYaoPinDetailListCmd alloc] init];
    if ([[ConfigUtil stringWithKey:YXLOGINACCOUNT] isEqualToString:@"qzf011"]) {
        cmd.storeId = @"20";
    }else{
        if ([[ConfigUtil stringWithKey:RELATIONTYPE] isEqualToString:@"0"]) {
         cmd.storeId = [ConfigUtil stringWithKey:STOREID];
        }else{
        }
    }
    cmd.searchKey = _key;
    cmd.pageNum = self.pageParams.page;
    cmd.pageSize = self.pageParams.num;
    WS(weakSelf);
    [[HttpNetwork getInstance] request:cmd success:^(BaseRespond* rsCode) {
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
        id list = [rsCode.data objectForKey:@"result"];
//        NSArray * unionList = [rsCode.data objectForKey:@"result"][@"unionList"];
//        [self.nameArray addObjectsFromArray:unionList];
        NSArray* array = [YaopinSearchListModel arrayFromData:list];
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
            //[weakSelf.tableView.footer noticeNoMoreData];
        }
        [NSGCDThread dispatchAsyncInMailThread:^(){
            [weakSelf.tableView reloadData];
        }];
    } failed:^(BaseRespond* respond, NSString* error) {
        [weakSelf.tableView.header endRefreshing];
        // 访问失败或者取消访问
        //[weakSelf.pageParams.result removeAllObjects];
        if (weakSelf.pageParams.result.count==0) {
//            [weakSelf.tableView.footer setTitle:error forState:MJRefreshFooterStateNoMoreData];
//            [weakSelf.tableView.footer noticeNoMoreData];
        }
        [MBProgressHUD showError:error toView:weakSelf.view];
        [NSGCDThread dispatchAsyncInMailThread:^(){
            [weakSelf.tableView reloadData];
        }];
    }];
    
}
@end
