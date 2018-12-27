//
//  MyReportsController.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/10/13.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "MyReportsController.h"
#import "ReportCell.h"
#import "ReportModel.h"
#import "CustomAlert.h"
#import "Verification.h"
#import "ReportController.h"
#import "UITableView+NoData.h"

static NSString *cellId = @"ReportCell";

@interface MyReportsController ()<UITableViewDelegate,UITableViewDataSource,ReportCellDelegate>

@property (nonatomic ,strong) UITableView *tableview;

@property (nonatomic ,assign) NSInteger page;

@property (nonatomic ,strong) NSMutableArray *datalist;

@property (nonatomic ,assign) BOOL moreData;

@end

@implementation MyReportsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"我的报告" ];
    [self setBackBtn:@"back"];
    
    [self initView];
    [self addRefreshView];
    
    // Do any additional setup after loading the view.
}


#pragma mark - initView
- (void)initView{

    self.tableview = ({
        UITableView *view = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.edges.mas_equalTo(self.view);
            make.left.mas_equalTo(self.view);
            make.width.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view).offset(KNavigationBarHeight);
            make.bottom.mas_equalTo(self.view);
        }];
        view.delegate = self;
        view.dataSource = self;
        [view registerClass:[ReportCell class] forCellReuseIdentifier:cellId];
        view.estimatedRowHeight = 0;
        view.estimatedSectionHeaderHeight = 0;
        view.estimatedSectionFooterHeight = 0;
        view;
    });
}

- (void)addRefreshView{
    KWeakSelf
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf loadData:NO];
    }];
    _tableview.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
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


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _datalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReportCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.model = _datalist[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ReportModel *model = _datalist[indexPath.section];
    
    ReportController *vc = [[ReportController alloc]init];
    vc.url = [NSString stringWithFormat:@"%@&version=%@&apptype=1",model.reportUrl,[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]] ; ;
    vc.vipType = USER.vipType;
    vc.companyId = model.entId;
    vc.companyName = model.entName;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 发送报告按钮
- (void)sendReportAction:(ReportModel *)model{
    KWeakSelf
    CustomAlert *alert = [[CustomAlert alloc]initWithTitle:@"发送至" style:AlertStyleTextField placeholder:@"请输入报告接收邮箱" callBack:^(NSString *text) {
        [weakSelf sendReportWithModel:model email:text];
    }];
    [alert showInView:self.view];
}

#pragma mark - 网络请求
- (void)loadData:(BOOL)loading{
    
    if (loading) {
        [self showLoadDataAnimation];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"20" forKey:@"pageSize"];
    [params setObject:@(_page) forKey:@"pageIndex"];
    [params setObject:USER.userID forKey:@"userId"];
    KWeakSelf
    [RequestManager getWithURLString:KGetReportList parameters:params success:^(id responseObject) {
        [weakSelf hideLoadDataAnimation];
        if ([responseObject[@"result"] intValue] == 0) {
            NSArray *models = [ReportModel mj_objectArrayWithKeyValuesArray:
                               responseObject[@"dataResult"]];
            if (weakSelf.page == 1) {
                [weakSelf.datalist removeAllObjects];
            }
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

- (void)abnormalViewReload{
    [self loadData:YES];
}

//发送报告
- (void)sendReportWithModel:(ReportModel*)model email:(NSString *)mail{
    
    if (![Verification validateEmail:mail]) {
        [MBProgressHUD showError:@"请输入正确的邮箱！" toView:nil];
        return;
    }
 
    NSString *str = [NSString stringWithFormat:@"%@?entId=%@&userId=%@&entName=%@&email=%@",KSendReport,model.entId,USER.userID,model.entName,mail];
    
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [MBProgressHUD showMessag:@"" toView:nil];
    [RequestManager postWithURLString:str parameters:nil success:^(id responseObject) {
        [MBProgressHUD hideHudToView:nil animated:YES];
        if ([responseObject[@"result"] intValue] == 0) {
            [MBProgressHUD showSuccess:@"发送成功" toView:nil];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHudToView:nil animated:YES];
    }];
}

#pragma mark - lazy load
- (NSMutableArray *)datalist{
    if (!_datalist) {
        _datalist = [NSMutableArray array];
    }
    return _datalist;
}

#pragma mark - lift cycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
}





@end
