//
//  HZMoBanTableViewController.m
//  yaolianti
//
//  Created by zl on 2018/7/9.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "HZMoBanTableViewController.h"
#import "HuanzheCmd.h"
#import "HuanzheStruce.h"
#import "NetPageStruct.h"
#import "MJRefresh.h"
#import "MobanTableViewCell.h"
#import "ViewUtil.h"
#import "UIView+hlwCate.h"
#import "JohnTopTitleView.h"
#import "DoctorMobanTableViewController.h"
#import "PTMobanTableViewController.h"
#import "SSSearchBar.h"
#import "XYYDoctorSDK.h"
@interface HZMoBanTableViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSDictionary* dataDict;
@property(nonatomic,strong)NSArray*  dataArr;
@property(nonatomic,strong)NSMutableArray*   isOpenArr;
@property(nonatomic,strong)NSArray* sectionNameArr;
@property (nonatomic,strong)PageParams *pageParams;
@property(nonatomic,strong)UISearchBar *search;
@property(nonatomic,strong)UIButton *btnSearch;
@property(nonatomic,nonnull,copy)NSString *key;
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) JohnTopTitleView *titleView;
@property (nonatomic,strong)SSSearchBar *searchBar;
@end

@implementation HZMoBanTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
     [self.view setBackgroundColor:RGB(245, 245, 245)];
    [self setupBack];
    [self initTabelView];
    //[self setupNextWithString:@"新增模板" withColor:RGB(2, 175, 102)];
    UIButton *informationCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [informationCardBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    informationCardBtn.tag =101;
    [informationCardBtn setImage:[UIImage XYY_imageInKit:@"moban_add"] forState:UIControlStateNormal];
    
    [informationCardBtn sizeToFit];
    UIBarButtonItem *informationCardItem = [[UIBarButtonItem alloc] initWithCustomView:informationCardBtn];
    
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButtonItem.width = 15;
    
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    settingBtn.tag = 100;
    [settingBtn setImage:[UIImage XYY_imageInKit:@"moban_edit"] forState:UIControlStateNormal];
    [settingBtn sizeToFit];
    UIBarButtonItem *settingBtnItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    self.navigationItem.rightBarButtonItems  = @[informationCardItem,fixedSpaceBarButtonItem,settingBtnItem];
   [self setupTitleWithString:@"选择模板"];

    self.pageParams = [[PageParams alloc]init];

    self.tableView.tableFooterView = [UIView new];
    self.tableView.sectionHeaderHeight = 5;
    //注册cell
    UINib* nib = [UINib nibWithNibName:@"MobanTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"mobanCell"];
    WS(weakSelf);
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf netGetLists:YES];
    }];
    [self.tableView.header beginRefreshing];
    
    self.isOpenArr=[[NSMutableArray alloc] init];
    _key =@"";
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, AutoX375(375), AutoY375(60))];
    _bgView.backgroundColor = RGB(255, 255, 255);
//    _bgView.layer.shadowOffset = CGSizeMake(0, 2);
//    _bgView.layer.shadowOpacity = 0.5;
    self.search.centerY = _bgView.centerY;
    //_bgView.layer.shadowColor = RGBA(202, 202, 202, 0.5).CGColor;
    [self.view addSubview:_bgView];
    SSSearchBar *searchBar = [[SSSearchBar alloc] initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, 50)];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入药品模板名称";
    [_bgView addSubview:searchBar];
    self.searchBar = searchBar;
    //[_bgView addSubview:self.search];
    
}
-(void)rightAction:(UIBarButtonItem*)sender{
    if (sender.tag ==100) {
        [JumpUtil pushDoctorList:self];
    }else{
     [JumpUtil pushMoBanVC:self model:nil mArray:nil];
    }
}
- (void)initTabelView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, AutoX375(375), AutoY375(667)-64-AutoY375(60)-10) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    //self.tableView.backgroundColor = [UIColor redColor];
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGB(245, 245, 245);
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    //[self.view addSubview:self.tableView];
    NSArray *titleArray = [NSArray arrayWithObjects:@"我的模板",@"平台模板", nil];
    self.titleView.title = titleArray;
    [self.titleView setupViewControllerWithFatherVC:self childVC:[self setChildVC]];
    [self.view addSubview:self.titleView];
    
}
- (JohnTopTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[JohnTopTitleView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60)];
    }
    return _titleView;
}
-(NSArray <UIViewController *>*)setChildVC{
    DoctorMobanTableViewController * vc1 = [[DoctorMobanTableViewController alloc]init];
     PTMobanTableViewController*vc2 = [[PTMobanTableViewController alloc]init];
    NSArray *childVC = [NSArray arrayWithObjects:vc1,vc2, nil];
    return childVC;
}

-(void)ClickSection:(UIButton*)sender
{
    NSString*  state=[self.isOpenArr objectAtIndex:sender.tag-100];
    if ([state isEqualToString:@"open"]) {
        state=@"close";
    }else
    {
        state=@"open";
    }
    self.isOpenArr[sender.tag-100]=state;
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:sender.tag-100];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}
- (void)Click:(UIButton*)sender {
    YaopinMoBanModel *model = self.pageParams.result[sender.tag-100];
    NSArray *array =  model.prescriptTemplateDetailRes;
    if (self.delegate) {
        [self.delegate  passValue:array];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ui界面绘制
-(UISearchBar*)search{
    if (!_search) {
        //导航栏搜索框
        _search = [[UISearchBar alloc] initWithFrame:CGRectMake(15, AutoY375(10), SCREEN_WIDTH-30, AutoY375(35))];
        _search.delegate = self;
//        _search.layer.cornerRadius = CGRectGetHeight(_search.frame)/2;
//        _search.layer.masksToBounds = YES;
        [_search setSearchBarStyle:UISearchBarStyleMinimal];
        _search.tintColor=HEISE_COLOR;
        
        _search.placeholder=@"请输入药品模板名称";
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
                
                searchField.backgroundColor = LINE_COLOR;
                
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.pageParams.result.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString*  state=[self.isOpenArr objectAtIndex:section];
    if ([state isEqualToString:@"open"]) {
        // NSString*  key=[self.dataDict.allKeys objectAtIndex:section];
        //   NSArray*  arr=[self.dataDict objectForKey:key];
        YaopinMoBanModel *model = self.pageParams.result[section];
        
        NSArray*  arr= model.prescriptTemplateDetailRes;;
        return arr.count;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"mobanCell";
    MobanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[MobanTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     YaopinMoBanModel *model = self.pageParams.result[indexPath.section];
    NSArray *array = model.prescriptTemplateDetailRes;
    YaopinSearchListModel *detailModel = [[YaopinSearchListModel alloc]initWithDictionary:array[indexPath.row]];
    [cell reloadDataWithModel:detailModel];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 107;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*  sectionBackView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    sectionBackView.backgroundColor=[UIColor whiteColor];
    //[ViewUtil setJianbianToView:sectionBackView colorType:JianBianGreen frame:sectionBackView.bounds];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 0.7)];
    lineView.backgroundColor = RGB(217, 217, 217);
    [sectionBackView addSubview:lineView];
    
    UILabel*  numLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, 50)];
    YaopinMoBanModel *model = self.pageParams.result[section];
    numLabel.font = FONT(15);
    
    numLabel.textColor = RGB(51, 51, 51);
    numLabel.text=[NSString stringWithFormat:@"%@",model.templateName];
    [sectionBackView addSubview:numLabel];
    UIImageView* stateImage=[[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-30, 20, 12, 12)];
    stateImage.userInteractionEnabled = YES;
    if ([[_isOpenArr objectAtIndex:section] isEqualToString:@"open"]) {
        [stateImage setImage:[UIImage imageNamed:@"sectionOpen"]];
    }
    else if ([[_isOpenArr objectAtIndex:section] isEqualToString:@"close"]) {
        [stateImage setImage:[UIImage imageNamed:@"sectionClose"]];
    }
    [sectionBackView addSubview:stateImage];
    UIButton*  button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-30, 0, 30, 50)];
    [button setBackgroundColor:[UIColor clearColor]];
    button.tag=100+section;
    [button addTarget:self action:@selector(ClickSection:) forControlEvents:UIControlEventTouchUpInside];
    [sectionBackView addSubview:button];
    
    UIButton* clickBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [clickBtn setFrame:CGRectMake(0, 0, SCREEN_WIDTH-60, 50)];
    clickBtn.tag=100+section;
    [clickBtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];

    [sectionBackView addSubview:clickBtn];

    return sectionBackView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
#pragma mark searchBar代理
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if ([_search isFirstResponder]) {
        [_search resignFirstResponder];
    }
    //搜索
    _key=_searchBar.text;
    [self netGetLists:YES];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //查找获取焦点
}

#pragma mark 点击事件
-(void)onSearch{
    //搜索
    _key = _searchBar.text;
    [self netGetLists:YES];
}
//网络数据
-(void)netGetLists:(BOOL) isRefresh   {
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
    MoBanCmd*cmd=[[MoBanCmd alloc] init];
    cmd.prescriptTemplateType = 0;
    cmd.searchKey = _key;
    cmd.storeId = [ConfigUtil stringWithKey:STOREID];
    WS(weakSelf);
     //[MBProgressHUD showMessag:@"" toView:weakSelf.view];
    [[HttpNetwork getInstance] request:cmd success:^(BaseRespond* rsCode) {
        [weakSelf.tableView.header endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        id list = [rsCode.data objectForKey:@"result"];
        NSArray* array = [YaopinMoBanModel arrayFromData:list];
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
