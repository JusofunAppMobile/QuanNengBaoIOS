//
//  OwnerFocuceVC.m
//  EnterpriseInquiry
//
//  Created by LEZ on 16/8/10.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "OwnerFocuceVC.h"
#import "OwnerFouceCell.h"
#import "CompanyDetailController.h"
#import "UITableView+NoData.h"


@interface OwnerFocuceVC ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView         *_tableView;
    NSMutableArray      *_dataSource;
    
    int                 _p;
}
@end

@implementation OwnerFocuceVC

-(void)layout
{

    _tableView = [[UITableView alloc] initWithFrame:KFrame(0, KNavigationBarHeight, KDeviceW, KDeviceH-KNavigationBarHeight)style:UITableViewStylePlain];
    _tableView.delegate         = self;
    _tableView.dataSource       = self;
    _tableView.backgroundColor  = [UIColor clearColor];
    _tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:_tableView];
    __weak typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _p = 1;
        [weakSelf getDataFromNet:NO];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getDataFromNet:NO];
    }];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavigationBarTitle:@"我的关注" ];
    [self setBackBtn:@"back"];
    
    USER.focuseUnread = @"0";
    
    _p = 1;
    _dataSource = [NSMutableArray arrayWithCapacity:0];
    [self getDataFromNet:YES];
    [self layout];
    
    [KNotificationCenter addObserver:self
                     selector:@selector(focuNumChangeAction:)
                         name:KFocuNumChange
                       object:nil];
}

-(void)focuNumChangeAction:(NSNotification*)noti
{
    
    _p = 1;
    [self getDataFromNet:NO];
}

-(void)getDataFromNet:(BOOL)loading
{
    if (loading) {
        [self showLoadDataAnimation];
    }
    NSString *userid = USER.userID;
    NSString *pageIndex = [NSString stringWithFormat:@"%d",_p];
    NSString *pageSize = @"10";
    NSDictionary *dict = @{
                           @"userid":userid,
                           @"PageIndex":pageIndex,
                           @"pagesize":pageSize,
                           };
    KWeakSelf
    [RequestManager getWithURLString:GetAttendInfo parameters:dict success:^(id responseObject) {
        [weakSelf hideLoadDataAnimation];

        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        
        if (_p == 1) {
            [_dataSource removeAllObjects];
        }
        if ([responseObject[@"result"] integerValue] == 0) {
            [_dataSource addObjectsFromArray:responseObject[@"mywatchlist"]];
            if ([responseObject[@"ismore"] boolValue]) {
                [_tableView.mj_footer resetNoMoreData];
            }else{
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [_tableView nd_reloadData];
            if (_dataSource.count > 0) {
                _tableView.mj_footer.hidden = NO;
            }else{
                _tableView.mj_footer.hidden = YES;
            }
            _p++;
        }else{
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];
        }
        
    } failure:^(NSError *error) {
        if (loading) {
            [weakSelf showNetFailViewWithFrame:_tableView.frame];
        }
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}

- (void)abnormalViewReload{
    [self getDataFromNet:YES];
}

#pragma mark -- tableview   delegate datasource  -methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellString = @"AccountCellString";
    OwnerFouceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell) {
        cell = [[OwnerFouceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_dataSource.count > 0) {
        cell.infoDict = _dataSource[indexPath.row];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CompanyDetailController *detail = [CompanyDetailController new];
    detail.companyId = _dataSource[indexPath.row][@"companyid"];
    detail.companyName = _dataSource[indexPath.row][@"companyname"];
    [self.navigationController pushViewController:detail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.000001;
}



@end
