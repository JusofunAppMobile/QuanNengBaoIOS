//
//  NewHomeViewController.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/1/4.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "NewHomeViewController.h"
#import "AppDelegate.h"
#import "HomeHeaderView.h"
#import "HomeSectionHeader.h"
#import "NewCompanyCell.h"
#import "NewHotCompanyCell.h"
#import "NewCompanyRadarCell.h"
#import "HomeModel.h"
#import "NearController.h"
#import "GifRefreshHearder.h"
#import "QuestionView.h"
#import "LegalPersonChangeController.h"
#import "RecentChangeModel.h"
#import "HotCompanyListController.h"
#import "NewCompanyController.h"
#import "LoginController.h"

static NSString *HomeSetionHeaderID = @"HomeSectionHeader";
static NSString *NewCompanyID = @"NewCompanyCell";
static NSString *HotCompanyID = @"NewHotCompanyCell";
static NSString *CompanyRadarID = @"NewCompanyRadarCell";

@interface NewHomeViewController ()<UITableViewDelegate,UITableViewDataSource,HomeHeaderViewDelegate,QuestionViewDelegate,CompanyRadarDelegate,NewAddCompanyDelegate,SectionHeaderDelegate,NewHotCompanyCellDelegate>
@property (nonatomic ,strong) NSMutableArray *setionTitles;
@property (nonatomic ,assign) CGFloat lastOffset;
@property (nonatomic ,strong) NSDate *firstDate;
@property (nonatomic ,strong) NSMutableArray *radarArray;
@property (nonatomic ,strong) NSURLSessionDataTask * requsetTask;
@property (nonatomic ,strong) HomeModel *homeModel;
@property (nonatomic ,strong) QuestionView *questionView;

@end

@implementation NewHomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL isFirst = [KUserDefaults boolForKey:homeIsFirst];
    
    if (isFirst) {
        [KUserDefaults setBool:NO forKey:homeIsFirst];
        [KUserDefaults synchronize];
        [self loadInquiryView];
        [self loadData];
    }
    [self initView];

}

#pragma mark - initView
- (void)initView{
    
    CGFloat scrolly = - KNavigationBarHeight;//Masonry布局导致控制器直接跳到个人中心页面
    if(@available(iOS 11.0, *)){
        scrolly = 0;
    }

    
    self.tableview = ({
        UITableView *view = [[UITableView alloc]initWithFrame:CGRectMake(0, scrolly, KDeviceW, KDeviceH)];
        [self.view addSubview:view];
        view.tableHeaderView = self.headerView;
        view.delegate = self;
        view.dataSource = self;
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view.estimatedRowHeight = 118;
        view.rowHeight  = UITableViewAutomaticDimension;
        view.backgroundColor = [UIColor clearColor];
        view.showsVerticalScrollIndicator = NO;
        view;
    });

    [_tableview registerClass:[HomeSectionHeader class] forHeaderFooterViewReuseIdentifier:HomeSetionHeaderID];
    [_tableview registerClass:[NewCompanyCell class] forCellReuseIdentifier: NewCompanyID];
    [_tableview registerClass:[NewHotCompanyCell class] forCellReuseIdentifier:HotCompanyID];
    [_tableview registerClass:[NewCompanyRadarCell class] forCellReuseIdentifier:CompanyRadarID];
    
    //下拉刷新背景
    UIImageView *gifRefreshBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, scrolly, KDeviceW, self.headerView.height)];
    gifRefreshBg.image = KImageName(@"下拉底图");
    [self.view insertSubview:gifRefreshBg atIndex:0];
    
    //添加导航栏搜索
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.pageViewController.navigationBarView addSubview:self.naviSearchView];
    
    [self addRefreshView];
}

- (void)addRefreshView{
    KWeakSelf
    _tableview.mj_header = [GifRefreshHearder headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
}

#pragma mark - 网络请求
- (void)loadData{
    [self loadRadarData];
    KWeakSelf
    _firstDate = [NSDate date];
    NSString *url = [NSString stringWithFormat:@"%@?userid=%@",GetIndexPageNew,USER.userID];
    _requsetTask = [RequestManager getWithURLString:url parameters:nil success:^(id responseObject) {
        [weakSelf endRefreshing];
        if ([responseObject[@"result"] integerValue] == 0) {
            NSLog(@"222%@",responseObject);
            
            weakSelf.homeModel = [HomeModel mj_objectWithKeyValues:responseObject];
            [weakSelf reloadTableView];
            
            NSHTTPURLResponse *response = (NSHTTPURLResponse*)_requsetTask.response;
            NSString *serverDate =response.allHeaderFields[@"Date"];
            NSDate *serverTime = [JAddField convertHeaderDateToNSDate:serverDate];
            NSDate *currentTime = [NSDate date];
            CGFloat timeoffset = currentTime.timeIntervalSince1970 -serverTime.timeIntervalSince1970;
            [KUserDefaults setValue:[NSString stringWithFormat:@"%f",timeoffset] forKey:CurrentTimeToServerOffset];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败" toView:self.view];
        [self endRefreshing];
        NSLog(@"error %@",error.description);
    }];
}

- (void)loadRadarData{
    KWeakSelf;
    NSMutableDictionary *paraDic  = [NSMutableDictionary dictionary];
    [paraDic setObject:USER.userID forKey:@"userId"];
    [RequestManager postWithURLString:KRandar parameters:paraDic success:^(id responseObject) {
        if ([responseObject[@"result"] integerValue ]==0) {
            
            NSArray *array = [responseObject objectForKey:@"list"];
            [weakSelf.radarArray removeAllObjects];
            weakSelf.radarArray = [NSMutableArray arrayWithCapacity:1];
            for(NSDictionary *dic in array)
            {
                //1.法人变更 2.股东变更 3.资本变更 4.公司名称 5.经营范围
                int type = [[dic objectForKey:@"type"] intValue];
                if(type == 1 || type == 2|| type == 3|| type == 4|| type == 5)
                {
                    [weakSelf.radarArray addObject:dic];
                }
            }
            [weakSelf.tableview reloadData];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}


#pragma mark -  加载问卷调查界面
-(void)loadInquiryView{
    
    KWeakSelf
    [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    NSString *isFirst = [KUserDefaults boolForKey:QuestionISFirst]?@"1":@"0";
    [parameter setObject:isFirst forKey:@"isFirst"];
    [RequestManager getWithURLString:GetQuestionnaires parameters:parameter success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //请求成功
        if ([responseObject[@"result"] integerValue] == 0) {
            QuestionModel *questionModel = [QuestionModel mj_objectWithKeyValues:responseObject[@"dataResult"]];
            if ([questionModel.isshow integerValue] == 0) {
                [weakSelf.questionView layoutQuestionViewsWithQuestionModel:questionModel andType:1] ;
                [weakSelf.questionView show];
                
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error %@",error.description);
    }];
}

#pragma mark - 更新tableview,动态设置section个数
- (void)reloadTableView{
    _setionTitles = [NSMutableArray arrayWithObjects:@"企业雷达",@"热门企业",@"新增企业", nil];
    [_setionTitles enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {//每个block块并发执行NSEnumerationConcurrent
        if (!_homeModel.hotlist.count&&[obj isEqualToString:@"热门企业"]) {
            [_setionTitles removeObject:obj];
        }
        if (!_homeModel.newaddlist.count&&[obj isEqualToString:@"新增企业"]) {
            [_setionTitles removeObject:obj];
        }
    }];
    
    [self.tableview reloadData];
}

#pragma mark - 下拉刷新
-(void)endRefreshing{
    
    NSDate *nowDate = [NSDate date];
    NSTimeInterval secondsBetweenDates= [nowDate timeIntervalSinceDate:_firstDate];
    CGFloat time = 1.6;
    if(secondsBetweenDates>time){
        [_tableview.mj_header endRefreshing];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((time-secondsBetweenDates) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tableview.mj_header endRefreshing];
        });
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_setionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *title = _setionTitles[section];
    if ([title isEqualToString:@"热门企业"]) {
        return _homeModel.hotlist.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *title = _setionTitles[indexPath.section];
    
    if ([title isEqualToString:@"企业雷达"]) {
        NewCompanyRadarCell *cell = [tableView dequeueReusableCellWithIdentifier:CompanyRadarID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.radarArray = _radarArray;
        return cell;
    }else if([title isEqualToString:@"热门企业"]){
        NewHotCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:HotCompanyID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.model = _homeModel.hotlist[indexPath.row];
        return cell;
    }else{
        NewCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:NewCompanyID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.addList = _homeModel.newaddlist;
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 37;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HomeSectionHeader *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HomeSetionHeaderID];
    sectionHeader.title = _setionTitles[section];
    sectionHeader.delegate = self;
    return sectionHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = _setionTitles[indexPath.section];
    
    if ([title isEqualToString:@"热门企业"]) {
        [MobClick event:@"Home15"];//首页－热门企业点击数
        [[BaiduMobStat defaultStat] logEvent:@"Home15" eventLabel:@"首页－热门企业点击数"];
        
        CompanyModel *model = [_homeModel.hotlist objectAtIndex:indexPath.row];
        CompanyDetailController *detailController = [[CompanyDetailController alloc] init];
        detailController.companyId = model.companyid;
        detailController.companyName  = model.companyname;
        [self.navigationController pushViewController:detailController animated:YES];
    }

}

#pragma mark - UIScrollDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat maxWidth = 370*KDeviceW/375.f;//搜索栏宽度
    CGFloat minWidth = _naviSearchView.width+20*2;//白框加20*2的左右阴影才等于图片大小
    CGFloat widthDelta = maxWidth - minWidth;
    
    CGRect orginBounds = self.headerView.searchBtnView.bounds;
    if (offsetY > 0) {
        //透明度
        CGFloat alpha = offsetY /(self.headerView.searchBtnView.maxY-20*(KDeviceW/375.f) - KNavigationBarHeight);//20*(KDeviceW/375.f)为图片底部yin
        alpha = MIN(alpha, 1);
        //宽度变化
        CGFloat scrollDistance = offsetY - _lastOffset;
        CGFloat currentWidth = maxWidth - widthDelta*alpha;
        if (scrollDistance > 0) {//向上滑动
            orginBounds.size.width = MAX(currentWidth, minWidth);
        }else{//向下滑动
            orginBounds.size.width = MIN(currentWidth,maxWidth);//搜索栏正常宽度
        }
        self.headerView.searchBtnView.bounds = orginBounds;
        
        [self setNaviBarWithAlpha:alpha];//设置导航栏透明度
        
    }else
    {
        [self.navigationController.navigationBar fs_setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)setNaviBarWithAlpha:(CGFloat)alpha{
    
    if (alpha ==  1) {
        self.naviSearchView.hidden = NO;
        self.headerView.searchBtnView.hidden = YES;
        
    }else{
        self.naviSearchView.hidden = YES;
        self.headerView.searchBtnView.hidden = NO;
    }
    [self.navigationController.navigationBar fs_setBackgroundColor:[KHexRGB(0x3c82fc) colorWithAlphaComponent:alpha]];//此处用图片颜色的时候，图片过大导致滚动卡顿，改为正常颜色
}

#pragma mark - 点击搜索框
//跳转搜索界面
- (void)goSearchvc{
    
    [MobClick event:@"Home01"];//首页－名称搜索框点击数,0
    [[BaiduMobStat defaultStat] logEvent:@"Home01" eventLabel:@"首页－名称搜索框点击数"];
    SearchController *SearchVc = [[SearchController alloc]init];
    SearchVc.searchType = BlurryType;
    [self.navigationController pushViewController:SearchVc animated:YES];
}

#pragma mark - 企业雷达点击
- (void)companyRadarClick:(NSDictionary *)dic{
    LegalPersonChangeController *vc = [[LegalPersonChangeController alloc]init];
    vc.changeModel = [RecentChangeModel mj_objectWithKeyValues:dic];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 新增企业点击

- (void)newAddCompanyClicked:(NewAddModel *)model{
    [MobClick event:@"home98"];//首页-新增企业列表点击
    [[BaiduMobStat defaultStat] logEvent:@"home98" eventLabel:@"首页-新增企业列表点击"];
    
    CompanyDetailController *detailController = [[CompanyDetailController alloc] init];
    detailController.companyId = model.companyid;
    detailController.companyName  = model.companyname;
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - 热门企业收藏关注
- (void)collectCompanyWithButton:(UIButton *)button model:(CompanyModel *)model{
    
    if (!USER.userID.length) {
        [self goToLogin];
        return;
    }
    
    NSString *type = button.selected?@"2":@"1";//1关注，2取关
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:type forKey:@"type"];
    [params setObject:model.companyid forKey:@"companyid"];
    [params setObject:USER.userID forKey:@"userid"];
    [params setObject:model.companyname forKey:@"entname"];
    
    [RequestManager getWithURLString:UpDateAttend parameters:params success:^(id responseObject) {
    
        if ([[responseObject objectForKey:@"result"] intValue] == 0) {
            
            if ([type isEqualToString:@"1"]) {
                button.selected = YES;
                [MBProgressHUD showSuccess:@"关注成功" toView:self.view];
            }else{
                button.selected = NO;
                [MBProgressHUD showSuccess:@"取消关注成功" toView:self.view];
            }
        }else{
            [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
        }
    
    } failure:^(NSError *error) {
        [MBProgressHUD hideHudToView:self.view animated:YES];
    }];
}

//检查登录
- (void)goToLogin{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.pageViewController goToLogin];
//    LoginController *view = [[LoginController alloc]init];
//    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark - section 更多
- (void)sectionHeaderMoreBtnClicked:(NSString *)title{
    
    if ([title isEqualToString:@"热门企业"]) {
        [MobClick event:@"home96"];//首页-热门企业更多点击
        [[BaiduMobStat defaultStat] logEvent:@"home96" eventLabel:@"首页-热门企业更多点击"];
        
        HotCompanyListController *hotCompanyList = [[HotCompanyListController alloc] init];
        [self.navigationController pushViewController:hotCompanyList animated:YES];
    }
    if ([title isEqualToString:@"新增企业"]) {
        [MobClick event:@"home97"];//首页-新增企业更多点击
        [[BaiduMobStat defaultStat] logEvent:@"home97" eventLabel:@"首页-新增企业更多点击"];
        
        NewCompanyController *hotCompanyList = [[NewCompanyController alloc] init];
        [self.navigationController pushViewController:hotCompanyList animated:YES];
    }
}

#pragma mark - 分类搜索
- (void)headerBtnClicked:(UIButton *)button{
    
    SearchController *searchVc= [[SearchController alloc]init];
    switch (button.tag) {
        case 100:{

            return;
            NSLog(@"附近公司");
            NearController *vc = [NearController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 101:
            
            [MobClick event:@"Home03"];//首页－股东高管点击数
            [[BaiduMobStat defaultStat] logEvent:@"Home03" eventLabel:@"首页－股东高管点击数"];
            NSLog(@"股东高管");
            searchVc.searchType = ShareholderType;
            [self.navigationController pushViewController:searchVc animated:YES];
            break;
        case 102:
            
            NSLog(@"主营产品");
            [MobClick event:@"Home02"];//首页－主营产品点击数
            [[BaiduMobStat defaultStat] logEvent:@"Home02" eventLabel:@"首页－主营产品点击数"];
            
            searchVc.searchType = OurmainType;
            [self.navigationController pushViewController:searchVc animated:YES];            break;
        case 103:
            
            NSLog(@"地址电话");
            [MobClick event:@"Home04"];//首页－地址电话点击数
            [[BaiduMobStat defaultStat] logEvent:@"Home04" eventLabel:@"首页－地址电话点击数"];
            
            searchVc.searchType = AddressType;
            [self.navigationController pushViewController:searchVc animated:YES];
            break;
        case 104:
            NSLog(@"失信查询");
            
            [MobClick event:@"Home06"];//首页－失信查询点击数
            [[BaiduMobStat defaultStat] logEvent:@"Home06" eventLabel:@"首页－失信查询点击数"];
            searchVc.searchType = CrackcreditType;
            [self.navigationController pushViewController:searchVc animated:YES];
            break;
        case 105:
    
            searchVc.searchType = TaxCodeType;
            [self.navigationController pushViewController:searchVc animated:YES];
            break;
        case 106:
            
            searchVc.searchType = JobType;
            [self.navigationController pushViewController:searchVc animated:YES];
            break;
        case 107:
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 问卷调查
-(void)joinWithQuestionModel:(QuestionModel *)questionModel
{
    [self.questionView close];
    
    CommonWebViewController *commonWeb = [[CommonWebViewController alloc] init];
    commonWeb.titleStr = questionModel.title;
    commonWeb.urlStr = questionModel.htmlurl;
    [self requestWithId:[NSString stringWithFormat:@"%@",questionModel.id]];
    [self.navigationController pushViewController:commonWeb animated:YES];
    
}

//上传用户调查参与的ID
-(void)requestWithId:(NSString *)idNumber{
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:idNumber forKey:@"id"];
    
    [RequestManager getWithURLString:GetParticipate parameters:parameter success:^(id responseObject) {
        //        NSString *msg = [NSString stringWithUTF8String:responseObject[@"msg"]];
        NSLog(@"~~~~~~~~~~~~%@",responseObject[@"msg"]);
    } failure:^(NSError *error) {
        NSLog(@"error %@",error.description);
    }];
}


#pragma mark - lazy load
- (HomeHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[HomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, KDeviceW, HomeHeadHeight)];
        _headerView.delegate = self;
        [_headerView.searchBtnView addTarget:self action:@selector(goSearchvc) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

- (QuestionView *)questionView{
    if (!_questionView) {
        _questionView  = [[QuestionView alloc] initWithFrame:CGRectMake(0, 0, KDeviceW, KDeviceH)];
        _questionView.delegate = self;
    }
    return _questionView;
}

//导航栏搜索框
- (SearchButton *)naviSearchView{
    if (!_naviSearchView) {
        _naviSearchView = [[SearchButton alloc] initWithFrame:CGRectMake(50, 20+7,  KDeviceW -100, 30) andPlaceText:KSearchPlaceholder ] ;
        _naviSearchView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        _naviSearchView.layer.cornerRadius = 15;
        _naviSearchView.hidden = YES;
        [_naviSearchView addTarget:self action:@selector(goSearchvc) forControlEvents:UIControlEventTouchUpInside];
    }
    return _naviSearchView;
}

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!app.isHelepWillShow&&!app.isUserWillShow) {
        if (_tableview.contentOffset.y>0) {//复位导航栏样式
            CGFloat alpha = _tableview.contentOffset.y /(self.headerView.searchBtnView.maxY - KNavigationBarHeight);
            alpha = MIN(alpha, 1);
            [self setNaviBarWithAlpha:alpha];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!app.isHelepWillShow&&!app.isUserWillShow) {
        self.naviSearchView.hidden = YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

