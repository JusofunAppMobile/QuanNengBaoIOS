//
//  CompanySearchVC.m
//  EnterpriseInquiry
//
//  Created by LEZ on 16/8/10.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "CompanySearchVC.h"
#import "CompanySearchCell.h"


@interface CompanySearchVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    UISearchBar         *companySearchBar;
    UIView              *_navigation;
    
    UITableView         *_tableView;
    NSMutableArray      *_dataSource;
    
    int                 _pageIndex;
    NSString            *_tempSeachkey;
    
    //NSURLSessionDataTask*_session;
    //NSMutableArray      *_sessionArr;
    NSURLSessionDataTask *task;
}
@end

@implementation CompanySearchVC

-(void)drawSearchView
{
    _navigation = [[UIView alloc] initWithFrame:CGRectMake(0, 0,KDeviceW,44)];
    
    companySearchBar = [[UISearchBar alloc]initWithFrame:KFrame(0, (44-28)/2, KDeviceW -85, 28)];
    [[companySearchBar.subviews[0] subviews][0] removeFromSuperview];
    
    companySearchBar.backgroundImage = nil;
    companySearchBar.backgroundColor = [UIColor clearColor];
    companySearchBar.delegate = self;
    companySearchBar.placeholder  = KSearchPlaceholder;
    [companySearchBar setImage:[UIImage imageNamed:@"home_search"]
              forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    UITextField * searchField = [companySearchBar valueForKey:@"_searchField"];
    searchField.font = KFont(13);
    searchField.textColor = KHexRGB(0x666666);
    [searchField setValue:KFont(13) forKeyPath:@"_placeholderLabel.font"];

    companySearchBar.layer.borderColor = KRGB(206, 206, 206).CGColor;
    companySearchBar.layer.borderWidth = 1;
    companySearchBar.layer.cornerRadius = companySearchBar.height/2.0;
    companySearchBar.layer.masksToBounds = YES;

//    if(@available(iOS 11.0, *)) {
//        [[companySearchBar.heightAnchor constraintEqualToConstant:44] setActive:YES];
//    }
   [_navigation addSubview:companySearchBar];
    
    self.navigationItem.titleView = _navigation;
}

-(void)createTable
{
    
    _tableView = [[UITableView alloc] initWithFrame:KFrame(0, KNavigationBarHeight, KDeviceW, KDeviceH-KNavigationBarHeight)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (_tempSeachkey.length > 0) {
            _pageIndex = 1;
            
        }
        [weakSelf tempSearch];
        
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf tempSearch];
    }];
    //_tableView.mj_footer.automaticallyHidden = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
     [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
}

- (void)viewDidLoad {
    
    [self setBackBtn:@"back"];
    //self.automaticallyAdjustsScrollViewInsets = NO;
   
    [super viewDidLoad];
    
    
    _pageIndex = 1;
    _dataSource = [NSMutableArray arrayWithCapacity:0];
    
    [self drawSearchView];
    [self createTable];
    
    if (_tempCompany) {
        companySearchBar.text = _tempCompany;
//        [self getCompanyListWith:_tempCompany];
    }
    
    
}

-(void)tempSearch
{
    
    if (_tempSeachkey.length > 0) {
        [self getCompanyListWith:_tempSeachkey];
    }else{
        
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }
}

-(void)getCompanyListWith:(NSString*)searchkey
{
    _tempSeachkey = searchkey;
    NSString *pageindex = [NSString stringWithFormat:@"%d",_pageIndex];
    NSDictionary *dict = @{
                           @"type":@"0",
                           @"searchkey":searchkey,
                           @"pageIndex":pageindex,
                           @"pageSize":@"20",
                           };
    [task cancel];
    task = [RequestManager postWithURLString:SearchLightCompanyNews parameters:dict success:^(id responseObject) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        NSLog(@"%@",responseObject);
        if (_pageIndex == 1) {
            [_dataSource removeAllObjects];
        }
        if ([responseObject[@"result"] integerValue] == 0) {
            
            [_dataSource addObjectsFromArray:responseObject[@"companylist"]];
            if (_dataSource.count < [responseObject[@"totalcount"] integerValue]) {
                [_tableView.mj_footer resetNoMoreData];
            }else{
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [_tableView reloadData];
            _pageIndex ++;
            
        }else{
            
            
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];
        }
        
    } failure:^(NSError *error) {
        
        
        if(error.code == -999)//取消请求
        {
            return ;
        }
        
        [MBProgressHUD showHint:@"网络错误，请稍后重试！" toView:self.view];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark -- tableview   delegate datasource  -methods


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataSource.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellString = @"CompanySearchCellString";
    CompanySearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell) {
        cell = [[CompanySearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_dataSource.count > 0) {
        cell.infoDict = _dataSource[indexPath.row];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.000001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectCompanyWithInfo:)]) {
        [self.delegate selectCompanyWithInfo:_dataSource[indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [companySearchBar resignFirstResponder];
    [self getCompanyListWith:searchBar.text];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    [self searchBar:searchBar shouldChangeTextInRange:NSMakeRange(0, 0) replacementText:searchText];
}

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    if (searchBar.text.length == 0) {
        
        _tempSeachkey = @"";
//        [_session cancel];
        [_dataSource removeAllObjects];
        [_tableView reloadData];
        _tableView.hidden = YES;
        
    }else{
        
        _tableView.hidden = NO;
        _pageIndex = 1;
        [self getCompanyListWith:searchBar.text];
    }
    return YES;

}

//-searchbar

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    [companySearchBar resignFirstResponder];
}

-(void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{}

-(void)viewDidDisappear:(BOOL)animated
{
   [task cancel];
}

@end
