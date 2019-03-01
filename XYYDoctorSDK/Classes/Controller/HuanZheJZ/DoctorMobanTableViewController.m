//
//  DoctorMobanTableViewController.m
//  yaolianti
//
//  Created by qxg on 2018/10/17.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "DoctorMobanTableViewController.h"
#import "HuanzheCmd.h"
#import "HuanzheStruce.h"
#import "NetPageStruct.h"
#import "MJRefresh.h"
#import "MobanTableViewCell.h"
#import "ViewUtil.h"
#import "UIView+hlwCate.h"
#import "XYYDoctorSDK.h"
@interface DoctorMobanTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSDictionary* dataDict;
@property(nonatomic,strong)NSArray*  dataArr;
@property(nonatomic,strong)NSMutableArray*   isOpenArr;
@property(nonatomic,strong)NSArray* sectionNameArr;
@property (nonatomic,strong)PageParams *pageParams;
@end

@implementation DoctorMobanTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = RGB(245, 245, 245);
    self.tableView.backgroundColor = RGB(245, 245, 245);
    [self.tableView.header beginRefreshing];
    self.pageParams = [[PageParams alloc]init];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.sectionHeaderHeight = 5;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //注册cell
    UINib* nib = [UINib nibWithNibName:@"MobanTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"mobanCell"];
    self.isOpenArr=[[NSMutableArray alloc] init];
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
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)viewWillAppear:(BOOL)animated{
//    [self.tableView addLegendHeaderWithRefreshingBlock:^{
//        [weakSelf netGetList:YES];
//    }];
//}
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
    NSArray *array =  model.hospDoctorPrescriptTemplateDetail;
 
    //发送通知  array是携带的数组
    [[NSNotificationCenter defaultCenter] postNotificationName:@"moban" object:array];
    [self.navigationController popViewControllerAnimated:YES];
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
        
        NSArray*  arr= model.hospDoctorPrescriptTemplateDetail;;
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
    NSArray *array = model.hospDoctorPrescriptTemplateDetail;
    YaopinSearchListModel *detailModel = [[YaopinSearchListModel alloc]initWithDictionary:array[indexPath.row]];
    WS(weakSelf);
    cell.block = ^(YaopinSearchListModel *model) {
        [JumpUtil pushDetail:weakSelf dict:model];
    };
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
    YaopinMoBanModel *model = self.pageParams.result[indexPath.section];
    NSArray *array = model.hospDoctorPrescriptTemplateDetail;
    YaopinSearchListModel *detailModel = [[YaopinSearchListModel alloc]initWithDictionary:array[indexPath.row]];
    [JumpUtil pushDetail:self dict:detailModel];
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
    numLabel.font = FONT(16);
    
    numLabel.textColor = RGB(51, 51, 51);
    numLabel.text=[NSString stringWithFormat:@"%@",model.templateName];
    [sectionBackView addSubview:numLabel];
    UIImageView* stateImage=[[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-30, 20, 12, 7)];
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
    [MBProgressHUD showMessag:@"" toView:weakSelf.view];
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
