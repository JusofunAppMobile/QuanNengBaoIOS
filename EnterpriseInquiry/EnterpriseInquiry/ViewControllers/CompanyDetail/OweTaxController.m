//
//  OweTaxController.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/11/9.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "OweTaxController.h"
#import "OweTaxCell.h"
#import "OweTaxModel.h"
#import "CommonWebViewController.h"
#import "UITableView+NoData.h"

static NSString *CellID = @"OweTaxCell";

@interface OweTaxController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableview;

@property (nonatomic ,assign)  int page;

@property (nonatomic ,strong) NSMutableArray *datalist;

@property (nonatomic ,strong) NSArray *reponselist;

@property (nonatomic ,assign) BOOL moreData;

@end

@implementation OweTaxController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self addRefreshView];
}

#pragma mark - initView
- (void)initView{

    self.tableview = ({
        UITableView *view = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
           // make.edges.mas_equalTo(self.view);
            make.left.mas_equalTo(self.view);
            make.width.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view).offset(KNavigationBarHeight);
            make.bottom.mas_equalTo(self.view);
        }];
        view.rowHeight = UITableViewAutomaticDimension;
        view.estimatedRowHeight = 134;
        view.delegate = self;
        view.dataSource = self;
       // view.estimatedRowHeight = 0;
        view.estimatedSectionHeaderHeight = 0;
        view.estimatedSectionFooterHeight = 0;
        [view registerClass:[OweTaxCell class] forCellReuseIdentifier:CellID];
        view;
    });
    
}

//上下拉刷新
- (void)addRefreshView{
    KWeakSelf
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf loadData:NO];
    }];
    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadData:NO];
    }];
    [_tableview.mj_header beginRefreshing];
}

- (void)endRefresh{
    [_tableview.mj_header endRefreshing];
    if (_moreData) {
        [_tableview.mj_footer endRefreshing];
    }else{
        [_tableview.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - loadData
- (void)loadData:(BOOL)loading{
    if (loading) {
        [self showLoadDataAnimation];
    }
    _taxCode = @"";
    NSString *str = [NSString stringWithFormat:@"%@?pageSize=20&pageIndex=%d&entName=%@&taxCode=%@",KGetEntOwingTaxList,_page,_entName,_taxCode];
    
    KWeakSelf
    [RequestManager postWithURLString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(id responseObject) {
        [weakSelf hideLoadDataAnimation];
        if ([responseObject[@"result"] intValue] == 0) {
            if (weakSelf.page == 1) {
                [weakSelf.datalist removeAllObjects];
            }
            weakSelf.reponselist = responseObject[@"dataResult"];
            NSArray *models = [OweTaxModel mj_objectArrayWithKeyValuesArray:weakSelf.reponselist];
            [weakSelf.datalist addObjectsFromArray:models];
            weakSelf.moreData = [weakSelf.datalist count] < [responseObject[@"totalCount"] intValue];
            weakSelf.page++;
            [weakSelf.tableview nd_reloadData];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"] toView:nil];
        }

        [weakSelf endRefresh];
    } failure:^(NSError *error) {
        [weakSelf endRefresh];
        if (loading) {
            [weakSelf showNetFailViewWithFrame:self.tableview.frame];
        }
        
    }];
}

- (void)abnormalViewReload{
    [self loadData:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _datalist.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OweTaxCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:self.datalist[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *detail = self.reponselist[indexPath.section];

    CommonWebViewController *commomwevView = [[CommonWebViewController alloc] init];
    commomwevView.titleStr = @"欠税信息";
    commomwevView.urlStr = [detail objectForKey:@"url"];
    commomwevView.dataDic = detail;
    [self.navigationController pushViewController:commomwevView animated:YES];

}

#pragma mark - layz load

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
