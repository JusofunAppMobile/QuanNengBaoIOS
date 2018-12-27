//
//  SearchResultController.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/15.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "SearchResultController.h"
#import "SearchCell.h"
#import "CompanyInfoModel.h"
#import "CompanyDetailController.h"
#import "MJRefresh.h"
#import "SearchTaxCodeCell.h"
#import "SearchCompanyCell.h"
#import "SearchJobCell.h"
#import "SearchTaxCodeModel.h"
#import "SearchJobModel.h"
#import "CommonWebViewController.h"
#import "FilterView.h"
#import "FilterCellModel.h"
#import "UITableView+NoData.h"

#define kCellID @"SearchCollectionCell"
#define kReusableHeaderView @"reusableHeaderView"
#define kReusableFooterView @"reusableFooterView"

#define SearchTaxID @"SearchTaxCodeCell"
#define SearchCompanyID @"SearchCompanyCell"
#define SearchJobID @"SearchJobCell"

@interface SearchResultController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,FilterViewDelegate>

{
    bool _openSection[10];
    
    BOOL isShowLoseFootView;//是否展示失信的footview
    
    SearchAllWebView *searchAllWebView;
}

@property (nonatomic, strong) UISearchBar  *companySearchBaBar;//搜索bar
@property (nonatomic, strong) UIView *searchView;//barView
@property (nonatomic, strong) UITableView *companySearchTableView;
@property (nonatomic, strong) UITableView *sortSearchTableView;
@property (nonatomic, assign) NSInteger currpage; //当前页
@property (nonatomic, strong) NSMutableArray *companyAllArr;

//@property (nonatomic, strong) ChooseView *chooseView;//筛选界面

@property (nonatomic, assign) CGFloat sortBarH;//排序条高
@property (nonatomic, assign) CGFloat tipsBarH;//搜索结果数条高

@property (nonatomic, strong) UILabel *tipsLab;//搜索到企业数
@property (nonatomic ,strong) FilterView *filterView;
@property (nonatomic ,strong) UIImage *shadowImage;

@end

@implementation SearchResultController
{
    
    
    UICollectionView *_SearchCollectionView;
    UIScrollView *_SearchScrollView;
    UIButton *_morebtn;
    NSInteger _iszhankai;
    UIView *viewbtn;
    UIButton *Hotsort;
    UIButton *capitalsort;
    UIButton *timesort;
    
    UIButton *hotalphabtn;
    UIButton *alphaBtn;//用于控制注册资金按钮点击状态是否可以点击
    UIButton *timeralphaBtn;//用于控制注册时间按钮点击状态是否可以点击
    
    
    NSString *City;//城市
    NSString *Province;//省份
    NSString *industry;//行业
    NSString *Registeredcapital;//注册资金
    NSString *Establishmentperiod;//行业
    
    
    UIButton *popBtn; //返回透明btn
    
    //    ChooseView *chooseView;//筛选界面
    
    NSString *SortHistory;// 排序记录
    
    NSMutableDictionary *chooseDic;//筛选的条件
    
    UIButton *defaultBtn;//默认排序按钮
    UIButton *moneyBtn;//注册资金
    UIButton *timeBtn;//注册时间
    
    SortType sortType;//排序
    
    LoseCreditType loseCreditType;//失信的type
    
    UIButton *clearBtn;
    
}

- (void)viewWillAppear:(BOOL)animated{
    _shadowImage = self.navigationController.navigationBar.shadowImage;
    [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];//隐藏导航栏分割线,写在上一句后，上一句方法里改变了shadowimage

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [self.navigationController.navigationBar setShadowImage:_shadowImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBtn:@"back"];    
    //初始化
    _iszhankai = -1;
    _currpage = 1;
    chooseDic = [NSMutableDictionary dictionaryWithCapacity:1];

    loseCreditType = 1;
    isShowLoseFootView = NO;
    
    [self.searchView addSubview:self.companySearchBaBar];
    self.navigationItem.titleView = self.searchView;
    
    //绘制筛选按钮
    if (self.searchType!=TaxCodeType&&self.searchType!=JobType) {
        [self drawFilterBtn];//绘制筛选按钮
        [KeyWindow addSubview:self.filterView];//添加筛选列表
    }
//    else{
//        self.companySearchBaBar.frame = KFrame(0, 0, KDeviceW-85, 35);
//    }
    
    //是否显示排序
    if (self.searchType != TaxCodeType&&self.searchType!=JobType) {
        [self drawSortView];
    }
    //搜索结果数
    if (self.searchType != CrackcreditType) {
        [self drawTipsView];
    }
    
    [self.view addSubview:self.companySearchTableView];
    self.companySearchTableView.mj_footer.hidden = YES;
    
    //给tableview添加手势隐藏键盘
    [self hidekeyboard];
    [self setupRefresh];
    
    [self loadData:YES];
    
}

//弹出筛选页面
- (void)ScreenClick{
    
    [MobClick event:@"Search47"];//搜索结果页－筛选按钮点击数
    [[BaiduMobStat defaultStat] logEvent:@"Search47" eventLabel:@"搜索结果页－筛选按钮点击数"];
    [self.filterView showChooseView];
}

#pragma mark - 请求信息
- (void)loadData:(BOOL)loading {

    NSString *urlStr;
    NSMutableDictionary *paraDic  = [NSMutableDictionary dictionaryWithDictionary:chooseDic];
    isShowLoseFootView = NO;
    [searchAllWebView removeFromSuperview];
    
    HttpRequestType requestType;
    if(self.searchType == CrackcreditType)
    {
        urlStr = BlackListSearch;
        [paraDic setObject:[NSString stringWithFormat:@"%d",(int)loseCreditType] forKey:@"type"];
        requestType = HttpRequestTypePost;
    }else if (self.searchType == TaxCodeType){
        
        urlStr = KGetSearByRegCode;
        requestType = HttpRequestTypeGet;

    }else if (self.searchType == JobType){
        urlStr = KGetCompInJobPage;
        requestType = HttpRequestTypeGet;
        [paraDic setObject:self.btnTitile forKey:@"entName"];

    }else{
        urlStr = GetSear;
        [paraDic setObject:[NSString stringWithFormat:@"%d",(int)self.searchType] forKey:@"type"];
        [paraDic setObject:[NSString stringWithFormat:@"%d",(int)sortType] forKey:@"sequence"];
        requestType = HttpRequestTypeGet;
        
        if(sortType == HotSortType)
        {
            [MobClick event:@"Search54"];//默认排序
            [[BaiduMobStat defaultStat] logEvent:@"Search54" eventLabel:@"搜索结果页－默认排序点击数"];
            
        }
        else if (sortType == MoneyUpSortType||sortType == MoneyDownSortType)
        {
            [MobClick event:@"Search55"];//注资排序
            [[BaiduMobStat defaultStat] logEvent:@"Search55" eventLabel:@"搜索结果页－注资排序点击数"];
            
        }
        else
        {
            [MobClick event:@"Search56"];//时间排序
            [[BaiduMobStat defaultStat] logEvent:@"Search56" eventLabel:@"搜索结果页－时间排序点击数"];
            
        }
        
        if(self.searchType == BlurryType)
        {
            [MobClick event:@"Search29"];//企业总搜索次数
            [[BaiduMobStat defaultStat] logEvent:@"Search29" eventLabel:@"企业总搜索次数"];
        }
        
    }
    
    [paraDic setObject:self.btnTitile forKey:@"searchkey"];
    [paraDic setObject:@"20" forKey:@"pageSize"];
    [paraDic setObject:@(_currpage) forKey:@"pageIndex"];
    
    if (loading) {
        [self showLoadDataAnimation];
    }else{
        [MBProgressHUD showMessag:@"" toView:self.view];
    }
    KWeakSelf
    [RequestManager requestWithURLString:urlStr parameters:paraDic type:requestType success:^(id responseObject) {
        [weakSelf hideLoadDataAnimation];
        [weakSelf endRefresh];
        [MBProgressHUD hideHudToView:weakSelf.view animated:YES];

        NSArray * tmpArray;
        
        if([[responseObject objectForKey:@"result"] intValue] == 0)
        {
            if ( weakSelf.currpage == 1) {
                [ weakSelf.companyAllArr removeAllObjects];
//                [self.companySearchTableView setContentOffset:CGPointMake(0,0) animated:YES];
            }
            
            if(self.searchType == CrackcreditType)
            {
                SearchLoseCreitARRModel *loseCreitArrModel = [SearchLoseCreitARRModel mj_objectWithKeyValues:responseObject];
                tmpArray = [NSArray arrayWithArray:loseCreitArrModel.dishonestylist];
            }else if (self.searchType == TaxCodeType){
                
                tmpArray = [SearchTaxCodeModel mj_objectArrayWithKeyValuesArray:responseObject[@"dataResult"]];

            }else if (self.searchType == JobType){
                tmpArray = [SearchJobModel mj_objectArrayWithKeyValuesArray:responseObject[@"dataResult"]];
            }else{
                NSArray *array = [NSArray arrayWithArray:responseObject[@"businesslist"]];
                tmpArray = [CompanyInfoModel mj_objectArrayWithKeyValuesArray:array];
            }
            
            [weakSelf.companyAllArr addObjectsFromArray:tmpArray];
            if(weakSelf.companyAllArr.count == 0 && weakSelf.currpage == 1)
            {
                if( weakSelf.searchType == BlurryType)
                {
                    [MobClick event:@"Search30"];//企业搜索无结果次数
                    [[BaiduMobStat defaultStat] logEvent:@"Search30" eventLabel:@"企业搜索无结果次数"];
                    
                }else if( weakSelf.searchType == CrackcreditType)//只有失信查询才弹出提示框
                {
                    [MBProgressHUD showError:@"没有相关数据" toView:self.view];
                }
            }
            
            if(self.searchType == CrackcreditType)
            {
                BOOL ismore = [[responseObject objectForKey:@"ismore"] boolValue];
                if(!ismore)
                {
                    [weakSelf.companySearchTableView.mj_footer endRefreshingWithNoMoreData];
                    isShowLoseFootView = YES;
                    
                }
            }else if (self.searchType == TaxCodeType||self.searchType == JobType){
                
                [self setTipsLabWithText:responseObject[@"totalCount"]];//设置搜索结果数
                
                NSInteger totalCount = [responseObject[@"totalCount"] integerValue];
                
                //共搜索到123个招聘
                if(totalCount == weakSelf.companyAllArr.count){
                    [weakSelf.companySearchTableView.mj_footer endRefreshingWithNoMoreData];
                }
                
            }else{
                
                [self setTipsLabWithText:responseObject[@"count"]];//设置搜索结果数
                NSInteger totalCount = [[responseObject objectForKey:@"count"] integerValue];
               
                if(weakSelf.companyAllArr.count == totalCount){
                    [weakSelf.companySearchTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }

            weakSelf.currpage ++;
        }
        else
        {
            NSString *result = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"result"]];
            if(result.length>0){
                
                [MBProgressHUD showError:[responseObject objectForKey:@"msg"] toView:self.view];
            }else{
                if (loading) {
                    [weakSelf showNetFailViewWithFrame:weakSelf.companySearchTableView.frame];
                }
            }
        }
        [ weakSelf.companySearchTableView nd_reloadData];
        
    } failure:^(NSError *error) {
        [weakSelf endRefresh];
        [MBProgressHUD hideHudToView:weakSelf.view animated:YES];
        if (loading) {
            [weakSelf showNetFailViewWithFrame:weakSelf.companySearchTableView.frame];
        }
    }];
    
}

- (void)abnormalViewReload{
    
    [self loadData:YES];
}

#pragma mark searchBar Delegate

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(searchBackWithClear:)])
    {
        if(searchBar.text.length == 0)
        {
            return NO;
        }
        
        [self.delegate searchBackWithClear:NO];
        
        
        [self popViewControllerWithType:PopNormal];
        
    }
    
    return NO;
}

-(void)clearBtnClick
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(searchBackWithClear:)])
    {
        [self.delegate searchBackWithClear:YES];
        [self popViewControllerWithType:PopNormal];
    }
}


-(void)hidekeyboard{
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [_companySearchTableView addGestureRecognizer:tapGestureRecognizer];
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.companySearchBaBar resignFirstResponder];
}



#pragma mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.companyAllArr count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(self.searchType == CrackcreditType)
    {
        return 84;
    }else if (self.searchType == TaxCodeType){

        return 100;
    }else if (self.searchType == JobType){
        SearchJobModel *jobModel = [self.companyAllArr objectAtIndex:indexPath.row];

        if (jobModel.companyName.length>0) {
            return 180;//+10top
        }else{
            return 180-30;//
        }
    }else{
        CompanyInfoModel *companyModel = [self.companyAllArr objectAtIndex:indexPath.row];
            if( companyModel.related.length > 0)
            {
                return 212;//10像素top
            }else
            {
                return 212-30;
            }

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.searchType == CrackcreditType)
    {
        static NSString* cellID = @"cell";
        LoseCreditCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[LoseCreditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.LoseCreditModel = _companyAllArr[indexPath.row];
        return cell;
        
    }else if (self.searchType == TaxCodeType){
        SearchTaxCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchTaxID];
        if (!cell) {
            cell = [[SearchTaxCodeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchTaxID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = _companyAllArr[indexPath.row];
        return cell;
    }
    else if (self.searchType == JobType){
        SearchJobCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchJobID];
        if (!cell) {
            cell = [[SearchJobCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchJobID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = _companyAllArr[indexPath.row];
        return cell;
    }
    else
    {
        SearchCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchCompanyID];
        if (!cell) {
            cell = [[SearchCompanyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchCompanyID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(self.companyAllArr.count >0){
            CompanyInfoModel *companyModel = [self.companyAllArr objectAtIndex:indexPath.row];
            cell.companyInfoModel  = companyModel;
        }
        return cell;
        
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(self.searchType == CrackcreditType && isShowLoseFootView &&_companyAllArr.count >0)
    {
        return 60;
    }
    else
    {
        return 0.001f;
        
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(self.searchType == CrackcreditType && isShowLoseFootView&&_companyAllArr.count >0)
    {
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, KDeviceH - 60, KDeviceW, 60)];
        bottomView.backgroundColor = [UIColor clearColor];
        
        NSString * title = @"数据来源：全国法院信息公示系统，仅供参考 ";
        
        CGFloat width = [Tools getWidthWithString:title fontSize:13 maxHeight:KDeviceW];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(KDeviceW/2-width/2 + 10, 20, width, 20)];
        textLabel.textColor = KHexRGB(0x97999E);
        textLabel.font = [UIFont fontWithName:FontName size:13];
        textLabel.text = @"数据来源：全国法院信息公示系统，仅供参考 ";
        [bottomView addSubview:textLabel];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(textLabel.x - 15 - 5, 22, 15, 15)];
        imageView.image = [UIImage imageNamed:@"Bell"];
        [bottomView addSubview:imageView];
        
        
        
        return bottomView;
    }
    
    return nil;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.1f;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.searchType == CrackcreditType)
    {
        [MobClick event:@"Search28"];//失信查询页－有结果－结果点击数
        [[BaiduMobStat defaultStat] logEvent:@"Search28" eventLabel:@"失信查询页－有结果－结果点击数"];
        
        LoseCreditModel *creditModel = _companyAllArr[indexPath.row];
        CommonWebViewController *commonWeb = [[CommonWebViewController alloc] init];
        commonWeb.titleStr = @"失信详情";
        commonWeb.urlStr = creditModel.url;
        [self.navigationController pushViewController:commonWeb animated:YES];
    }else if (self.searchType == JobType){
     
        SearchJobModel *model = self.companyAllArr[indexPath.row];
        
        CommonWebViewController *commomwevView = [[CommonWebViewController alloc] init];
        commomwevView.titleStr = @"招聘详情";
        commomwevView.urlStr = model.url;
        commomwevView.dataDic = model.mj_keyValues;
        [self.navigationController pushViewController:commomwevView animated:YES];
    }else
    {
        [MobClick event:@"Search46"];//搜索结果页－搜索结果点击数
        [[BaiduMobStat defaultStat] logEvent:@"Search46" eventLabel:@"搜索结果页－搜索结果点击数"];
        
        CompanyDetailController *CompanyDetatilVc =[[CompanyDetailController alloc]init];
        CompanyInfoModel *companyModel = [self.companyAllArr objectAtIndex:indexPath.row];
        CompanyDetatilVc.companyId = companyModel.companyid;
        CompanyDetatilVc.companyName = companyModel.companyname;
        [self.navigationController pushViewController:CompanyDetatilVc animated:YES];
        
    }
}


#pragma mark - 绘制排序部分
-(void)drawSortView
{
    _sortBarH = self.searchType== CrackcreditType?36:51;

    UIView *sortBackView = [[UIView alloc]initWithFrame:CGRectMake(0, KNavigationBarHeight, KDeviceW, _sortBarH)];
    sortBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sortBackView];
    
    if(self.searchType == CrackcreditType)
    {
        NSArray *titleArray = @[@"全部",@"失信人",@"失信企业"];
        for(int i = 0;i<titleArray.count;i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = KFrame(KDeviceW/3*i, 0, KDeviceW/3, 35);
            [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
            button.titleLabel.font = KFont(14);
            [button setTitleColor:KRGB(102,102,102) forState:UIControlStateNormal];
            [button setTitleColor:KHexRGB(0x1d6fe7) forState:UIControlStateSelected];
            [button addTarget:self action:@selector(loseCreditBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            if(i==0)
            {
                button.selected = YES;
            }
            button.tag = LoseCreditBtnTag + i + 1;
            [sortBackView addSubview:button];
        }
        
    }
    else
    {
        sortType = HotSortType;

        CGFloat y = (_sortBarH-35)/2;
        
        //默认排序
        defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        defaultBtn.frame = KFrame(0, y, KDeviceW/3, 35);
        [defaultBtn setTitle:@"默认排序" forState:UIControlStateNormal];
        defaultBtn.titleLabel.font = KFont(16);
        [defaultBtn setTitleColor:KHexRGB(0x666666) forState:UIControlStateNormal];
        [defaultBtn setTitleColor:KHexRGB(0x1d6fe7) forState:UIControlStateSelected];
        [defaultBtn addTarget:self action:@selector(sortBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        defaultBtn.selected = YES;
        [sortBackView addSubview:defaultBtn];
        
        
        //注册资金
        moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moneyBtn.frame = KFrame(KDeviceW/3, y, KDeviceW/3, 35);
        [moneyBtn setTitle:@"注册资金" forState:UIControlStateNormal];
        moneyBtn.titleLabel.font = KFont(14);
        [moneyBtn setTitleColor:KHexRGB(0x666666) forState:UIControlStateNormal];
        [moneyBtn setTitleColor:KHexRGB(0x1d6fe7) forState:UIControlStateSelected];
        [moneyBtn setImage:KImageName(@"botom") forState:UIControlStateNormal];
        [moneyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -defaultBtn.imageView.image.size.width-10, 0, defaultBtn.imageView.image.size.width+10)];
        [moneyBtn setImageEdgeInsets:UIEdgeInsetsMake(0, defaultBtn.titleLabel.bounds.size.width+10 , 0, - defaultBtn.titleLabel.bounds.size.width-10 )];
        moneyBtn.tag = MoneyNormalState;
        [moneyBtn addTarget:self action:@selector(sortBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [sortBackView addSubview:moneyBtn];
        
        
        //注册时间
        timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        timeBtn.frame = KFrame(KDeviceW/3*2, y, KDeviceW/3, 35);
        [timeBtn setTitle:@"注册时间" forState:UIControlStateNormal];
        timeBtn.titleLabel.font = KFont(14);
        [timeBtn setTitleColor:KHexRGB(0x666666) forState:UIControlStateNormal];
        [timeBtn setTitleColor:KHexRGB(0x1d6fe7) forState:UIControlStateSelected];
        
        [timeBtn setImage:KImageName(@"botom") forState:UIControlStateNormal];
        [timeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -defaultBtn.imageView.image.size.width-10, 0, defaultBtn.imageView.image.size.width+10)];
        [timeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, defaultBtn.titleLabel.bounds.size.width+10 , 0, - defaultBtn.titleLabel.bounds.size.width-10 )];
        timeBtn.tag =  TimeNormalState;
        [timeBtn addTarget:self action:@selector(sortBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [sortBackView addSubview:timeBtn];
        
    }
    
}

#pragma mark - 绘制筛选按钮

- (void)drawFilterBtn{
    UIButton *buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonRight setTitle:@"筛选" forState:UIControlStateNormal];
    buttonRight.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    buttonRight.titleLabel.textAlignment = NSTextAlignmentRight;
    buttonRight.frame = CGRectMake(10, 0, 35, 22);
    [buttonRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    buttonRight.titleLabel.font = KFont(14);
    [buttonRight addTarget:self action:@selector(ScreenClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - 绘制匹配企业数提示
- (void)drawTipsView{
    _tipsBarH = 30;
    UIView *tipsBg = [[UIView alloc]initWithFrame:CGRectMake(0, KNavigationBarHeight+_sortBarH, KDeviceW, _tipsBarH)];
    tipsBg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipsBg];
    
    _tipsLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, KDeviceW-15*2, _tipsBarH)];
    _tipsLab.textColor = KHexRGB(0x999999);
    _tipsLab.font = KFont(12);
    [tipsBg addSubview:_tipsLab];
}

#pragma mark - 排序按钮点击
-(void)sortBtnClick:(UIButton*)button
{
    
    defaultBtn.selected = NO;
    moneyBtn.selected = NO;
    timeBtn.selected = NO;
    
    button.selected = YES;
    
    [moneyBtn setImage:KImageName(@"botom") forState:UIControlStateNormal];
    [timeBtn setImage:KImageName(@"botom") forState:UIControlStateNormal];
    
  
    defaultBtn.titleLabel.font = defaultBtn.selected?KFont(16):KFont(14);
    moneyBtn.titleLabel.font = moneyBtn.selected?KFont(16):KFont(14);
    timeBtn.titleLabel.font = timeBtn.selected?KFont(16):KFont(14);

    
    if(button == defaultBtn)
    {
        sortType = HotSortType;
      
    }
    else if(button == moneyBtn)
    {
        
        timeBtn.tag = TimeNormalState;
        if(button.tag == MoneyNormalState)//从普通状态进入向下状态
        {
            [button setImage:KImageName(@"botom") forState:UIControlStateNormal];
            sortType = MoneyDownSortType;
            button.tag = MoneyDownState;
        }
        else if (button.tag == MoneyDownState)//从向下状态进入向上状态
        {
            [button setImage:KImageName(@"top") forState:UIControlStateNormal];
            sortType = MoneyUpSortType;
            button.tag = MoneyUpState;
        }
        else//从向上状态进入向下状态
        {
            [button setImage:KImageName(@"botom") forState:UIControlStateNormal];
            sortType = MoneyDownSortType;
            button.tag = MoneyDownState;
        }
        
    }
    else if (button == timeBtn)
    {
        moneyBtn.tag = MoneyNormalState;
        if(button.tag == TimeNormalState)//从普通状态进入向下状态
        {
            [button setImage:KImageName(@"botom") forState:UIControlStateNormal];
            sortType = TimeDownSortType;
            button.tag = TimeDownState;
        }
        else if (button.tag == TimeDownState)//从向下状态进入向上状态
        {
            [button setImage:KImageName(@"top") forState:UIControlStateNormal];
            sortType = TimeUpSortType;
            button.tag = TimeUpState;
        }
        else//从向上状态进入向下状态
        {
            [button setImage:KImageName(@"botom") forState:UIControlStateNormal];
            sortType = TimeDownSortType;
            button.tag = TimeDownState;
        }
        
        
    }
    
    self.currpage = 1;
    [self loadData:NO];
    
}

#pragma mark - 失信排序按钮点击
-(void)loseCreditBtnClick:(UIButton *)button
{
    for(int i = 0;i<3;i++)
    {
        UIButton *button = [self.view viewWithTag:LoseCreditBtnTag + 1 + i];
        button.selected = NO;
    }
    button.selected = YES;
    loseCreditType = button.tag - LoseCreditBtnTag;
    
    self.currpage = 1;
    [self loadData:NO];
}
#pragma mark - 筛选选择
- (void)didSelectFilterView:(NSArray *)selectArray{
    NSMutableDictionary *selectDic = [NSMutableDictionary dictionaryWithCapacity:1];
    for(FilterCellModel *model  in selectArray){
        if([model.type isEqualToString:@"1" ])//是城市时传名字
        {
            [selectDic setObject:model.name forKey:model.key];
        }else{
            [selectDic setObject:model.value forKey:model.key];
        }
    }
    chooseDic = [NSMutableDictionary dictionaryWithDictionary:selectDic];
    self.currpage = 1;
    [self.companyAllArr removeAllObjects];
    [self loadData:NO];
    
}


-(void)endRefresh{
    [self.companySearchTableView.mj_header endRefreshing];
    [self.companySearchTableView.mj_footer endRefreshing];
    
}
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    
    __weak typeof(self) weakSelf = self;
    
    if (SortHistory.length == 0) {
        SortHistory  = @"2";
    }
    self.companySearchTableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currpage  = 1;
        [weakSelf loadData:NO];
    }];
    // 1.下拉刷新(进入刷新状态就会调用self的footerRereshing)
    self.companySearchTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadData:NO];
    }];
    // [self.CompanySearchTableView.mj_footer endRefreshingWithNoMoreData];
    // self.companySearchTableView.mj_footer.automaticallyHidden = YES;
}



//设置返回按钮
-(void)setleftNavBtn{
    
    UIBarButtonItem *barleft =  [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    barleft.tintColor = KHexRGB(0x666666);
    self.navigationItem.leftBarButtonItem = barleft;
}

-(void)back{
    
    [self.filterView removeFromSuperview];
    self.filterView = nil;
    
    if(self.popType)
    {
        [self popViewControllerWithType:self.popType];
        return;
    }
    
    NSArray * ctrlArray = self.navigationController.viewControllers;
    
    if(self.isFromNoData)
    {
        [self.navigationController popToViewController:[ctrlArray objectAtIndex: ctrlArray.count>3?ctrlArray.count - 3:0] animated:YES];
    }
    else
    {
        
        [self.navigationController popToViewController:[ctrlArray objectAtIndex:0] animated:YES];
    }
}

-(void)popViewControllerWithType:(PopType)type
{
    NSArray * ctrlArray = self.navigationController.viewControllers;
    if(type == PopThird)
    {
        [self.navigationController popToViewController:[ctrlArray objectAtIndex: ctrlArray.count>3?ctrlArray.count - 3:0] animated:YES];
    }
    else if(type == PopTop)
    {
        
        [self.navigationController popToViewController:[ctrlArray objectAtIndex:0] animated:YES];
    }
    else if(type == PopNormal)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
//搜索结果数
- (void)setTipsLabWithText:(NSString *)totalCount{
    
    if (self.searchType != CrackcreditType) {
        NSString *tips = @"";
        NSRange range;
        if (self.searchType == TaxCodeType) {
            tips = [NSString stringWithFormat:@"搜索到%@家公司",totalCount];
            range = NSMakeRange(3, [totalCount length]);
        }else if(self.searchType == JobType){
            tips = [NSString stringWithFormat:@"共搜索到%@个招聘",totalCount];
            range = NSMakeRange(4, [totalCount length]);
        }else{
            tips = [NSString stringWithFormat:@"共匹配到%@家企业",totalCount];
            range = NSMakeRange(4, [totalCount length]);
        }
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:tips];
        [str addAttribute:NSForegroundColorAttributeName value:KHexRGB(0xfc7b2b) range:range];
        _tipsLab.attributedText = str;
    }
}

#pragma mark - lazy load

-(UIView *)searchView{
    if (_searchView == nil) {
        _searchView = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, KDeviceW - 20, 44)];
        _searchView.backgroundColor = [UIColor clearColor];
    }
    return _searchView;
}

-(UISearchBar *)companySearchBaBar{
    
    if (_companySearchBaBar == nil) {
        
        _companySearchBaBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, (44-28)/2, _searchView.frame.size.width - 105,  28)];
        [[_companySearchBaBar.subviews[0] subviews][0] removeFromSuperview];
        _companySearchBaBar.searchBarStyle         = UISearchBarStyleProminent;
        _companySearchBaBar.layer.masksToBounds    = YES;
        //    companySearchBar.layer.cornerRadius     = 15;
        _companySearchBaBar.backgroundImage        = nil;
        _companySearchBaBar.backgroundColor        = [UIColor clearColor];
        _companySearchBaBar.delegate               = self;
        _companySearchBaBar.placeholder            = @"请输入关键字";
        
        UITextField *searchTextField = [_companySearchBaBar valueForKey:@"_searchField"];
        
        searchTextField.font = KFont(14);
      
        
        [searchTextField setValue:KFont(14) forKeyPath:@"_placeholderLabel.font"];
        //searchTextField.clearButtonMode = UITextFieldViewModeNever;
        
        clearBtn = [searchTextField valueForKey:@"_clearButton"];
        [clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        _companySearchBaBar.backgroundImage = nil;
        _companySearchBaBar.backgroundColor = [UIColor clearColor];
        _companySearchBaBar.delegate = self;
        _companySearchBaBar.text = _btnTitile;
        _companySearchBaBar.layer.cornerRadius = 14.f;
        _companySearchBaBar.layer.masksToBounds = YES;
        _companySearchBaBar.layer.borderColor = KHexRGB(0xc8c8c8).CGColor;
        _companySearchBaBar.layer.borderWidth = 1.f;
        
        [_companySearchBaBar setImage:[UIImage imageNamed:@"home_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
    }
    return _companySearchBaBar;
}


-(UITableView *)companySearchTableView{
    
    if (_companySearchTableView == nil) {
        _companySearchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KNavigationBarHeight+_sortBarH+_tipsBarH, KDeviceW, KDeviceH-(KNavigationBarHeight+_sortBarH+_tipsBarH)) style:UITableViewStyleGrouped ];
        _companySearchTableView.backgroundColor = [UIColor clearColor];
        _companySearchTableView.delegate = self;
        _companySearchTableView.dataSource = self;
        _companySearchTableView.placeholderText = @"搜索无结果";
        _companySearchTableView.separatorStyle =self.searchType == CrackcreditType? :UITableViewCellSeparatorStyleNone;
    }
    return _companySearchTableView;
}

- (FilterView *)filterView{
    if (!_filterView) {
        _filterView = [[FilterView alloc]initWithFrame:KFrame(0, 0, KDeviceW, KDeviceH) isSX:self.searchType == CrackcreditType];
        _filterView.delegate = self;
    }
    return _filterView;
}

-(NSMutableArray *)companyAllArr{
    if (_companyAllArr == nil) {
        _companyAllArr = [[NSMutableArray alloc]init];
    }
    return _companyAllArr;
}

- (void)dealloc{
    [_filterView removeFromSuperview];
    _filterView = nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

