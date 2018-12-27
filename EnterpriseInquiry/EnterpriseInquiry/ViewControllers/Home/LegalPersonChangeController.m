//
//  LegalPersonChangeController.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/11/1.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "LegalPersonChangeController.h"
#import "RecentChangeModel.h"
#import "ChangeDetailModel.h"
#import "ChangeTextCell.h"
#import "UITableView+NoData.h"

static NSString *ChangeID = @"ChangeTextCell";


@interface LegalPersonChangeController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableview;

@property (nonatomic ,strong) NSDictionary *keys;

@property (nonatomic ,strong) NSMutableArray *datalist;

@property (nonatomic ,assign) NSInteger page;

@property (nonatomic ,assign) BOOL moreData;


@end

@implementation LegalPersonChangeController

- (void)viewDidLoad {//1.法人变更 2.股东变更 3.资本变更 4.公司名称 5.经营范围
    [super viewDidLoad];
    [self setNavigationBarTitle:_changeModel.title ];
    [self setBackBtn:@"back"];
    
    [self initView];
    [self addRefreshView];

}

#pragma mark - loadData
- (void)loadData:(BOOL)loading{
    if (loading) {
        [self showLoadDataAnimation];
    }
    NSString *str = [NSString stringWithFormat:@"%@?pageSize=20&pageIndex=%d&type=%@",KRandarDetail,(int)_page,_changeModel.type];
    KWeakSelf
    [RequestManager postWithURLString:str parameters:nil success:^(id responseObject) {
        [weakSelf hideLoadDataAnimation];
        if ([responseObject[@"result"] intValue] == 0) {
            if (weakSelf.page == 1) {
                [weakSelf.datalist removeAllObjects];
            }
            
            NSArray *models = [ChangeDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"dataResult"]];
            [weakSelf.datalist addObjectsFromArray:models];
            [weakSelf.tableview nd_reloadData];
            
            weakSelf.moreData = [weakSelf.datalist count] < [responseObject[@"totalCount"] intValue];
            weakSelf.page++;
        }else{
            [MBProgressHUD showError:responseObject[@"msg"] toView:nil];
        }
        [weakSelf endRefresh];
    } failure:^(NSError *error) {
        if (loading) {
            [weakSelf showNetFailViewWithFrame:weakSelf.tableview.frame];
        }
        [weakSelf endRefresh];
    }];
    
}

//网络失败重新加载
- (void)abnormalViewReload{
    [self loadData:YES];
}


#pragma mark - initView
- (void)initView{
    self.tableview = ({
        UITableView *view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
           // make.edges.mas_equalTo(self.view);
            make.left.mas_equalTo(self.view);
            make.width.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view).offset(KNavigationBarHeight);
            make.bottom.mas_equalTo(self.view);
        }];
        view.rowHeight = UITableViewAutomaticDimension;
        view.estimatedRowHeight = 100;
        view.delegate = self;
        view.dataSource = self;
//        [view registerClass:[LegalPersonCell class] forCellReuseIdentifier:LegalID];
//        [view registerClass:[ShareHolderCell class] forCellReuseIdentifier:ShareHolderID];
        [view registerClass:[ChangeTextCell class] forCellReuseIdentifier:ChangeID];
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

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datalist.count;
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
    
    ChangeTextCell *cell = [tableView dequeueReusableCellWithIdentifier:ChangeID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = [self.datalist objectAtIndex:indexPath.section];
    return cell;
//    if ([_changeModel.type intValue] == 2) {//股东
//        ShareHolderCell *cell = [tableView dequeueReusableCellWithIdentifier:ShareHolderID forIndexPath:indexPath];
//        cell.model = [self.datalist objectAtIndex:indexPath.row];
//        return cell;
//    }else{
//        LegalPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:LegalID forIndexPath:indexPath];
//        cell.model = [self.datalist objectAtIndex:indexPath.row];
//        return cell;
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ChangeDetailModel * model =  [self.datalist objectAtIndex:indexPath.section];
    CompanyDetailController *detailController = [[CompanyDetailController alloc] init];
    detailController.companyId = @"";
    detailController.companyName  = model.ename;
    [self.navigationController pushViewController:detailController animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}


#pragma mark - lifecycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
}

#pragma mark - lazy load

- (NSMutableArray *)datalist{
    if (!_datalist) {
        _datalist = [NSMutableArray array];
    }
    return _datalist;
}


@end
