//
//  NewCompanyController.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/9/5.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "NewCompanyController.h"
#import "NewAddListCell.h"
#import "CompanyDetailController.h"
#import "NewAddModel.h"

static NSString *cellId = @"NewAddListCell";

@interface NewCompanyController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableview;

@property (nonatomic ,strong) NSMutableArray *datalist;

@property (nonatomic ,assign) BOOL loadFinish;//是否加载完数据

@property (nonatomic ,assign) NSInteger page;

@end

@implementation NewCompanyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"新增企业" ];
    [self setBackBtn:@"back"];

    [self initView];
    [self addRefreshView];
    
    [self loadData:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
}

#pragma mark - initView

- (void)initView{
    self.tableview = ({
        UITableView *view = [UITableView new];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
        }];
        view.rowHeight = UITableViewAutomaticDimension;
        view.estimatedRowHeight = 122;
        view.delegate = self;
        view.dataSource = self;
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view;
    });
    
    [_tableview registerClass:[NewAddListCell class] forCellReuseIdentifier:cellId];
}

//上下拉刷新
- (void)addRefreshView{
    _page =1;
    
    KWeakSelf
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf loadData:NO];
    }];
    
    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (_loadFinish) {
            [weakSelf endRefresh];
        }else{
            weakSelf.page++;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewAddListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _datalist[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [MobClick event:@"home98"];//列表点击
    [[BaiduMobStat defaultStat] logEvent:@"home98" eventLabel:@"首页-新增企业列表点击"];

    NewAddModel *model = _datalist[indexPath.row];
    CompanyDetailController *detailController = [[CompanyDetailController alloc] init];
    detailController.companyId = model.companyid;
    detailController.companyName  = model.companyname;
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark 请求数据
- (void)loadData:(BOOL)loading{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"20" forKey:@"pageSize"];
    [params setObject:@(_page) forKey:@"pageIndex"];
    [params setObject:@"2" forKey:@"type"];////1. 热门企业 2 新增企业

    KWeakSelf;
    if (loading) {
        [self showLoadDataAnimation];
    }
    [RequestManager requestWithURLString:GetSDHotCompanyList parameters:params type:HttpRequestTypeGet success:^(id responseObject) {
        [weakSelf hideLoadDataAnimation];
        if ([responseObject[@"result"] integerValue] == 0) {
            if (_page == 1) {
                [weakSelf.datalist removeAllObjects];
            }
            [weakSelf.datalist addObjectsFromArray:[NewAddModel mj_objectArrayWithKeyValuesArray:responseObject[@"businesslist"]]];
            [weakSelf.tableview reloadData];
            weakSelf.loadFinish = [_datalist count]<20?YES:NO;
        }else{
            
            [MBProgressHUD showError:responseObject[@"msg"] toView:nil];
        }
        [weakSelf endRefresh];

    } failure:^(NSError *error) {
        [weakSelf endRefresh];
        if (loading) {
            [weakSelf showNetFailViewWithFrame:weakSelf.tableview.frame];
        }
    }];
}

#pragma mark lazy load
- (NSMutableArray *)datalist{
    if (!_datalist) {
        _datalist = [NSMutableArray array];
    }
    return _datalist;
}

@end
