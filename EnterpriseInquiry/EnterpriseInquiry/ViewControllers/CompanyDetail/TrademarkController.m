//
//  TrademarkController.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/9/6.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "TrademarkController.h"
#import "TrademarkCell.h"
#import "TrademarkModel.h"

static NSString *cellID = @"TrademarkCell";

@interface TrademarkController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableview;

@property (nonatomic ,strong) NSMutableArray *datalist;//TrademarkModel数组

@property (nonatomic ,assign) BOOL loadFinish;//是否加载完数据

@property (nonatomic ,assign) NSInteger page;

//@property (nonatomic ,strong) NSArray *responseList;//json数组

@end

@implementation TrademarkController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self addRefreshView];
    
    //[self loadData];
}

#pragma mark - initView

- (void)initView{
    
    self.tableview = ({
        UITableView *view = [UITableView new];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            // make.edges.mas_equalTo(self.view);
            make.left.mas_equalTo(self.view);
            make.width.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view).offset(KNavigationBarHeight);
            make.bottom.mas_equalTo(self.view);
        }];
        view.dataSource = self;
        view.delegate = self;
        view.tableFooterView = [UIView new];
        view;
    });
    [_tableview registerClass:[TrademarkCell class] forCellReuseIdentifier:cellID];
}

//上下拉刷新
- (void)addRefreshView{
    _page =1;
    
    KWeakSelf
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf loadData:NO];
    }];
    [_tableview.mj_header beginRefreshing];
    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.loadFinish) {
            [weakSelf endRefresh];
        }else{
            
            [weakSelf loadData:NO];
        }
    }];
}

- (void)endRefresh{
    [_tableview.mj_header endRefreshing];
    if (_loadFinish) {
        [_tableview.mj_footer endRefreshingWithNoMoreData];
    }else{
        [_tableview.mj_footer endRefreshing];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_datalist count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TrademarkCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell loadCell:_datalist[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TrademarkModel *detail = self.datalist[indexPath.section];
    
    CommonWebViewController *commomwevView = [[CommonWebViewController alloc] init];
    commomwevView.titleStr = detail.name;
    commomwevView.urlStr = detail.url;
    commomwevView.dataDic = detail.mj_keyValues;
    [self.navigationController pushViewController:commomwevView animated:YES];
    
    
}

#pragma mark 请求数据
- (void)loadData:(BOOL)loading{
    
    if (loading) {
        [self showLoadDataAnimation];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"20" forKey:@"pageSize"];
    [params setObject:@(_page) forKey:@"pageIndex"];
    [params setObject:_companyName forKey:@"entName"];
    [params setObject:@"" forKey:@"nameConcat"];

    KWeakSelf
    [RequestManager requestWithURLString:KTrademarkList parameters:params type:HttpRequestTypeGet success:^(id responseObject) {
        [weakSelf hideLoadDataAnimation];
        if ([responseObject[@"result"] intValue] == 0) {
            if (_page == 1) {//刷新
                [weakSelf.datalist removeAllObjects];
            }
            
            [weakSelf.datalist addObjectsFromArray:[TrademarkModel mj_objectArrayWithKeyValuesArray:responseObject[@"dataResult"]]];
            [weakSelf.tableview reloadData];
            
            weakSelf.loadFinish = [_datalist count]<20?YES:NO;
            weakSelf.page++;

        }else{
            
            [MBProgressHUD showError:responseObject[@"msg"] toView:weakSelf.view];
        }
        
        [weakSelf endRefresh];
    } failure:^(NSError *error) {
        [weakSelf endRefresh];
        if (loading) {
            [weakSelf showNetFailViewWithFrame:weakSelf.tableview.frame];
        }
        
    }];
}

- (void)abnormalViewReload{
    [self loadData:YES];
}


#pragma mark lazy load
- (NSMutableArray *)datalist{
    if (!_datalist) {
        _datalist = [NSMutableArray array];
    }
    return _datalist;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
