//
//  HotCompanyListController.m
//  EnterpriseInquiry
//
//  Created by clj on 16/8/12.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "HotCompanyListController.h"
#import "HotCompanyCell.h"
#import "CompanyDetailController.h"
#import "NewHotCompanyCell.h"
#import "UITableView+NoData.h"

static NSString *HotCompanyID = @"NewHotCompanyCell";


@interface HotCompanyListController()

@end

@implementation HotCompanyListController
{
    NSMutableArray *dataArray;
    NSInteger pageIndex;//当前页数
    NSInteger pageSize;//每页的数量
}

-(void)viewWillAppear:(BOOL)animated
{

    [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationBarTitle:@"热门企业" ];
    [self setBackBtn:@"back"];
    //初始化
    pageIndex = 1;
    pageSize = 20;
    dataArray = [[NSMutableArray alloc] init];
    
    [self.view addSubview:[self createTableView]];
    __weak typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageIndex = 1;
        [weakSelf loadData:NO];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadData:NO];
    }];
    [self loadData:YES];
}

#pragma mark - 加载数据
-(void)loadData:(BOOL)loading
{
    if (loading) {
        [self showLoadDataAnimation];
    }
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:[NSString stringWithFormat:@"%ld",(long)pageSize] forKey:@"pageSize"];
    [parameter setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"pageIndex"];
    [parameter setObject:@"1" forKey:@"type"];//1. 热门企业 2 新增企业
    
    KWeakSelf
    [RequestManager getWithURLString:GetSDHotCompanyList parameters:parameter success:^(id responseObject) {
        [weakSelf hideLoadDataAnimation];
        
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        //请求成功
        if ([responseObject[@"result"] integerValue] == 0) {
            NSArray *tempArray = [CompanyModel mj_objectArrayWithKeyValuesArray:responseObject[@"businesslist"]];
            
            if (pageIndex == 1) {
                dataArray = [NSMutableArray arrayWithArray:tempArray];
            }else{
                [dataArray addObjectsFromArray:tempArray];
            }
            
            if (tempArray.count < 20) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                _tableView.mj_footer.state = MJRefreshStateIdle;
            }
            
            [_tableView nd_reloadData];
            pageIndex ++;
        }else
        {
            [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
        }
        
    } failure:^(NSError *error) {
        if (loading) {
            [weakSelf showNetFailViewWithFrame:weakSelf.tableView.frame];
        }
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        
    }];
}

- (void)abnormalViewReload{
    [self loadData:YES];
}

#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return  1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

//iOS11需要实现以下方法，header的高度设置才会有效
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

//防止plain样式下 header悬浮
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 10;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"HotCompanyListCell";
    NewHotCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil) {
        cell = [[NewHotCompanyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.collectBtn.hidden = YES;
        cell.lineView.hidden = YES;
    }
    CompanyModel *companyModel =[dataArray objectAtIndex:indexPath.section];
    cell.model = companyModel;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [MobClick event:@"Hotlist20"];//热门企业列表－企业条目点击数
    
    CompanyModel *companyModel =[dataArray objectAtIndex:indexPath.section];
    
    CompanyDetailController *companyDetail = [[CompanyDetailController alloc] init];
    companyDetail.companyId = companyModel.companyid;
    companyDetail.companyName = companyModel.companyname;
    [self.navigationController pushViewController:companyDetail animated:YES];
}

-(UITableView *)createTableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNavigationBarHeight, KDeviceW, KDeviceH-KNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
    }
    return  _tableView;
}

@end
