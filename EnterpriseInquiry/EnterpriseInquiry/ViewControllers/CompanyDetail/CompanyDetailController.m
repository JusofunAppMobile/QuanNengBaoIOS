//
//  CompanyDetailController.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 16/8/10.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "CompanyDetailController.h"
#import "SearchResultController.h"
#import "RiskContainerController.h"
#import "AssetsContainerController.h"

@interface CompanyDetailController()
{
    UITableView *backTableView;
    CompanyDetailModel * detailModel;
    NSMutableArray  *itemList;//菜单列表
    DetailView *detailView;
    UIButton *focuButton;
    
    UIButton *errorBtn;
    
    UIButton *shareBarButton;
    
    NSMutableArray *riskItemList;//风险信息
    
    NSMutableArray *manageItemList;//经营状况
    
    NSMutableArray *assetItemList;//无形资产
    
    NSTimer *refreshTimer;
    
    int refreshNum;
    NSMutableArray *taskArray;
    
}
@end

@implementation CompanyDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.automaticallyAdjustsScrollViewInsets = NO;
    taskArray = [NSMutableArray arrayWithCapacity:1];
    self.view.backgroundColor = KRGB(253, 155, 48);
    self.view.backgroundColor = [UIColor colorWithPatternImage: [Tools scaleImage:KImageName(@"companyBack") size:self.view.size]];
    [self drawView];
    [self setBackBtn:@"whiteBack"];
    [self setRightBarBtn];
    [self loadCompanyInfo];
}




#pragma mark - 请求企业信息
-(void)loadCompanyInfo
{
    
    if(!self.companyId)
    {
        self.companyId = @"";
    }
    if(!self.companyName)
    {
        self.companyName = @"";
    }
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.companyId forKey:@"companyid"];
    [paraDic setObject:self.companyName forKey:@"companyname"];
    [paraDic setObject:USER.userID forKey:@"userid"];
    [paraDic setObject:self.companyName forKey:@"entname"];
    NSString* urlstr = [GetCompanyDetail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    KWeakSelf
    [self showLoadDataAnimation];
   NSURLSessionDataTask*task = [RequestManager getWithURLString:urlstr parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
       [weakSelf hideLoadDataAnimation];

        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        
        NSArray *tmpArray = [responseObject objectForKey:@"subclassMenu"];
        NSMutableArray *saveArray = [NSMutableArray arrayWithCapacity:1];
        
        for(NSDictionary *dic in tmpArray)
        {
            int type = [[dic objectForKey:@"type"] intValue];
            for(NSString *detailType in KCompanyDetailGridType)
            {
                if(type == [detailType intValue])
                {
                    [saveArray addObject:dic];
                    break;
                }
            }
        }
        [tmpDic setObject:saveArray forKey:@"subclassMenu"];
        
        
        detailModel = [CompanyDetailModel mj_objectWithKeyValues:tmpDic];
        
        
        if([detailModel.result intValue] == 0)
        {
            [weakSelf reloadOhterHeadWithtype:HeaderRiskType hud:NO];
            [weakSelf reloadOhterHeadWithtype:HeaderManageType hud:NO];
            [weakSelf reloadOhterHeadWithtype:HeaderMoneyType hud:NO];
            if([detailModel.hasCompanyData intValue] == 1)//没有数据
            {
                SearchResultController *SearchVc = [[SearchResultController alloc]init];
                SearchVc.btnTitile = self.companyName;
                SearchVc.searchType = BlurryType;
                SearchVc.isFromNoData = YES;
                //SearchVc.delegate = self;
                [self.navigationController pushViewController:SearchVc animated:YES];
            }
            else//正常
            {
                [self hideLoadDataAnimation];
                focuButton.hidden = NO;
                shareBarButton.hidden = NO;
                itemList = [NSMutableArray arrayWithArray:detailModel.subclassMenu];
                //[infoView reloadInfoView:detailModel];
                // [self reloadCompanyView];
                detailView.detailModel = detailModel;
                if([detailModel.isattention isEqualToString:@"false"]||[detailModel.isattention isEqualToString:@"-"] ||[detailModel.isattention isEqualToString:@""] )
                {
                    [self setFoucsBtn:NO];
                }
                else
                {
                    [self setFoucsBtn:YES];
                }
                
            }
            
        }
        else
        {
            [self hideLoadDataAnimation];
            focuButton.hidden = YES;
            shareBarButton.hidden = YES;
            
            [self setBackBtn:@"back"];
            [self showNetFailViewWithFrame:self.view.bounds];
        }
        
    } failure:^(NSError *error) {
        focuButton.hidden = YES;
        shareBarButton.hidden = YES;
        [self showNetFailViewWithFrame:self.view.bounds];
        [self setBackBtn:@"back"];
    }];
    [taskArray addObject:task];
}

#pragma mark - 请求风险信息/经营状态/无形资产
-(void)reloadOhterHeadWithtype:(Headerype)type hud:(BOOL)isHud
{
    NSString *urlStr = @"";
    
    if(type == HeaderRiskType)//风险信息
    {
        urlStr = KRiskMessage;
    }
    else if (type == HeaderManageType)//经营状况
    {
        urlStr = KBusinessInfo;
    }
    else ////无形资产
    {
        urlStr = KIntangible;
    }
    
    if(isHud)
    {
        [MBProgressHUD showMessag:@"" toView:self.view];
    }
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.companyId forKey:@"companyid"];
    [paraDic setObject:self.companyName forKey:@"companyname"];
    [paraDic setObject:USER.userID forKey:@"userid"];
    [paraDic setObject:self.companyName forKey:@"entname"];
    NSString* url = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask*task = [RequestManager getWithURLString:url parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [MBProgressHUD hideHudToView:self.view animated:YES];
        if([[responseObject objectForKey:@"result"] intValue] == 0)
        {
            NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:responseObject];
            
            NSArray *tmpArray = [responseObject objectForKey:@"subclassMenu"];
            NSMutableArray *saveArray = [NSMutableArray arrayWithCapacity:1];
            
            for(NSDictionary *dic in tmpArray)
            {
                int type = [[dic objectForKey:@"type"] intValue];
                for(NSString *detailType in KCompanyDetailGridType)
                {
                    if(type == [detailType intValue])
                    {
                        [saveArray addObject:dic];
                        break;
                    }
                }
            }
            [tmpDic setObject:saveArray forKey:@"subclassMenu"];
            
            
            if(type == HeaderRiskType)//风险信息
            {
                riskItemList = [NSMutableArray arrayWithArray: [tmpDic objectForKey:@"subclassMenu"]];
            }
            else if (type == HeaderManageType)//经营状况
            {
                manageItemList = [NSMutableArray arrayWithArray:[tmpDic objectForKey:@"subclassMenu"]];
            }
            else ////无形资产
            {
                assetItemList = [NSMutableArray arrayWithArray:[tmpDic objectForKey:@"subclassMenu"]];
            }
            
            [detailView reloadViewWithType:type gridArray:[tmpDic objectForKey:@"subclassMenu"] animate:isHud];
        }
        else
        {
            [MBProgressHUD showError:detailModel.msg toView:self.view];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        [MBProgressHUD showError:@"请求失败,请稍后重试" toView:self.view];
    }];
    
    
    [taskArray addObject:task];
}


-(void)headerClick:(Headerype)type
{
    [self reloadOhterHeadWithtype:type hud:YES];
}

#pragma mark - 关注公司
-(void)focuCompany:(UIButton*)sender
{
    [MobClick event:@"Detail57"];//企业详情页－关注按钮点击数
    [[BaiduMobStat defaultStat] logEvent:@"Detail57" eventLabel:@"企业详情页－关注按钮点击数"];

    NSString * type = @"1";
    KBolckSelf;
    if(sender.tag == 45678)//关注这家企业
    {
        
        if(USER.userID.length>0)
        {
            type = @"1";
        }
        else
        {
            
            LoginController *view = [[LoginController alloc]init];
            view.loginSuccessBlock = ^{
                [blockSelf focuCompany:focuButton];
            };
            [self.navigationController pushViewController:view animated:YES];
            
            return;
        }
    }
    else //取消关注企业
    {
        if (USER.userID.length>0) {
            type = @"2";
        }else
        {
            LoginController *view = [[LoginController alloc]init];
            view.loginSuccessBlock = ^{
                [blockSelf focuCompany:focuButton];
            };
            [self.navigationController pushViewController:view animated:YES];
            
            
            return;
        }
        
    }
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:detailModel.companyid forKey:@"companyid"];
    [paraDic setObject:type forKey:@"type"];
    [paraDic setObject:USER.userID forKey:@"userid"];
    [paraDic setObject:self.companyName forKey:@"entname"];
    [MBProgressHUD showMessag:@"" toView:self.view];
    NSString* urlstr = [UpDateAttend stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask*task = [RequestManager getWithURLString:urlstr parameters:paraDic success:^(id responseObject) {
        
        [MBProgressHUD hideHudToView:self.view animated:YES];
        if([[responseObject objectForKey:@"result"] intValue] == 0)
        {
            if(sender.tag == 45678)
            {
                [MBProgressHUD showSuccess:@"关注成功" toView:self.view];
            }
            else
            {
                [MBProgressHUD showSuccess:@"取消关注成功" toView:self.view];
            }
            
            
            if(sender.tag == 45678)
            {
                [self setFoucsBtn:YES];
                //关注成功
                [[NSNotificationCenter defaultCenter]postNotificationName:KFocuNumChange object:@"1"];
            }
            else
            {
                [self setFoucsBtn:NO];
                //取消关注
                [[NSNotificationCenter defaultCenter]postNotificationName:KFocuNumChange object:@"0"];
            }
            
            detailModel.attentioncount = [responseObject objectForKey:@"attentioncount"];
            detailView.detailModel = detailModel;
            
        }
        else
        {
            [MBProgressHUD showError:[responseObject objectForKey:@"msg"] toView:self.view];
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败" toView:self.view];
        
    }];
     [taskArray addObject:task];
}

-(void)abnormalViewReload
{
    [self setBackBtn:@"whiteBack"];
    [self loadCompanyInfo];
}

#pragma mark- 纠错
-(void)errorCorrection
{
    
    RecoveryErrorViewController *recoveryErrorView = [[RecoveryErrorViewController alloc] init];
    recoveryErrorView.squearList =  itemList;
    recoveryErrorView.companyId = detailModel.companyid;
    recoveryErrorView.companyName = self.companyName;
    [self.navigationController pushViewController:recoveryErrorView animated:YES];
}

#pragma mark - 分享
-(void)share
{
    [MobClick event:@"Detail58"];//企业详情页－分享按钮点击数
    [[BaiduMobStat defaultStat] logEvent:@"Detail58" eventLabel:@"企业详情页－分享按钮点击数"];

    ShareView *view = [[ShareView alloc]init];
    view.descStr = [NSString stringWithFormat:@"查询公司：%@",detailModel.companyname];
    view.detailUrlStr = detailModel.shareurl;
    [[UIApplication sharedApplication ].keyWindow addSubview:view];
}


#pragma mark - 更新企业信息
-(void)updataCompanyInfo
{
    [MobClick event:@"Detail59"];//企业详情页－刷新按钮点击数
    [[BaiduMobStat defaultStat] logEvent:@"Detail59" eventLabel:@"企业详情页－刷新按钮点击数"];

    [MBProgressHUD showMessag:@"" toView:self.view];
    NSString *str = [NSString stringWithFormat:@"%@?entid=%@&userId=%@&entname=%@",RefreshEntInfo,detailModel.companyid,USER.userID,self.companyName];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [detailView beginRefreshAnimation];

    KWeakSelf
//    refreshNum = 1;
//    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(stopRefreshAnimation) userInfo:nil repeats:YES];
   NSURLSessionDataTask*task =  [RequestManager getWithURLString:str parameters:nil success:^(id responseObject) {
        [MBProgressHUD hideHudToView:self.view animated:YES];
        if([[responseObject objectForKey:@"result"]intValue] == 0)
        {
//            [MBProgressHUD showHint:@"已通知相关人员更新" toView:self.view];
//            detailModel.isupdate = @"2";
//            detailModel.updatestate = @"更新：今天";
//            detailView.detailModel = detailModel;
//            if(refreshNum < 5)
//            {
//                [detailView beginRefreshAnimation];
//            }
//            else
//            {
//                [detailView stopRefreshAnimation];
//                [refreshTimer invalidate];
//                refreshTimer = nil;
//            }
            [weakSelf performSelector:@selector(checkUpdateStatus) withObject:nil afterDelay:20];
        }
        else
        {
            [MBProgressHUD showError:[responseObject objectForKey:@"msg"] toView:self.view];
            [detailView stopRefreshAnimation];//停止动画
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败" toView:self.view];
        [detailView stopRefreshAnimation];
    }];
    
     [taskArray addObject:task];
}

//开启定时器轮询检查更新状态
- (void)startTimerRequest{
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(checkUpdateStatus) userInfo:nil repeats:YES];
    [refreshTimer fire];
}

//检测更新状态
- (void)checkUpdateStatus{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (USER.userID) {
        [params setObject:USER.userID forKey:@"userId"];
    }
    [params setObject:self.companyName forKey:@"entName"];
    [params setObject:detailModel.companyid forKey:@"entId"];
    KWeakSelf
    NSURLSessionDataTask*task = [RequestManager getWithURLString:GetRefreshEntInfo parameters:params success:^(id responseObject) {
        if([responseObject[@"result"]intValue] == 0){
            
            detailModel.currentstate = responseObject[@"currentstate"];
            if ([detailModel.currentstate intValue] == 1) {//更新完成
                detailModel.updatestate = responseObject[@"updatestate"];
                detailView.detailModel = detailModel;//此处会导致动画和timer的停止，刷新tableview导致cell重建，动画为nil
                [weakSelf stopTimerRequest];
            }
        }
    } failure:^(NSError *error) {
    }];
    [taskArray addObject:task];
}

- (void)stopTimerRequest{
    [refreshTimer invalidate];
    refreshTimer = nil;
    [detailView stopRefreshAnimation];
}

#pragma mark - 九宫格点击
-(void)gridButtonClick:(ItemModel *)model cellSection:(int)section
{

    if(section == 2) //企业背景
    {
        BackgroundController *vc = [[BackgroundController alloc] init];
        vc.companyName = detailModel.companyname;
        vc.saveTitleStr = model.menuname;
        vc.itemModel = model;
        vc.companyId = detailModel.companyid;
        vc.itemArray = itemList;
        [MobClick event:model.umeng];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (section == 3)//风险信息
    {
        
        RiskContainerController *vc = [RiskContainerController new];
        vc.saveTitleStr = model.menuname;
        vc.itemArray = riskItemList;
        vc.itemModel = model;
        vc.companyId = detailModel.companyid;
        vc.companyName = detailModel.companyname;
        [MobClick event:model.umeng];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (section == 4)//经营状况
    {
        OperatingController *vc1 = [[OperatingController alloc] init];
        vc1.companyName = detailModel.companyname;
        vc1.saveTitleStr = model.menuname;
        vc1.itemModel = model;
        vc1.companyId = detailModel.companyid;
        vc1.itemArray = manageItemList;
        [MobClick event:model.umeng];
        [self.navigationController pushViewController:vc1 animated:YES];

    }
    else if (section == 5)//无形资产
    {
        AssetsContainerController *vc = [AssetsContainerController new];
        vc.saveTitleStr = model.menuname;
        vc.companyId = detailModel.companyid;
        vc.companyName = detailModel.companyname;
        vc.itemModel = model;
        vc.itemArray = assetItemList;
        
        [MobClick event:model.umeng];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - 查看报告
-(void)checkReport
{
    if(USER.userID.length>0)
    {
        [self loginSuccessCheckReport];
    }
    else
    {
        KBolckSelf;
      
        LoginController *view = [[LoginController alloc]init];
        view.loginSuccessBlock = ^{
            [blockSelf loginSuccessCheckReport];
        };
        
        [self.navigationController pushViewController:view animated:YES];
        
        //登录
        return;
    }
}

-(void)loginSuccessCheckReport
{
    [MBProgressHUD showMessag:@"" toView:self.view];
    NSString *str = [NSString stringWithFormat:@"%@?entId=%@&userId=%@&entname=%@",KGetReportLink,detailModel.companyid,USER.userID,self.companyName];
    
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    KBolckSelf;
    NSURLSessionDataTask*task = [RequestManager getWithURLString:str parameters:nil success:^(id responseObject) {
        [MBProgressHUD hideHudToView:self.view animated:YES];
        NSLog(@"查看企业报告=%@",responseObject);
        if([[responseObject objectForKey:@"result"]intValue] == 0)
        {
            ReportController *vc = [[ReportController alloc]init];
            vc.url = [NSString stringWithFormat:@"%@&version=%@&apptype=1",[[responseObject objectForKey:@"data"] objectForKey:@"reportUrl"],[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]] ;
            vc.vipType = [[responseObject objectForKey:@"data"] objectForKey:@"vipType"];
            vc.companyId = detailModel.companyid;
            vc.companyName = self.companyName;
            [blockSelf.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [MBProgressHUD showError:[responseObject objectForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败" toView:self.view];
    }];
     [taskArray addObject:task];
   
}

#pragma mark - 点击地理位置
-(void)companyAdress
{
    [MobClick event:@"Detail60"];//企业详情页－地址点击数
    [[BaiduMobStat defaultStat] logEvent:@"Detail60" eventLabel:@"企业详情页－地址点击数"];

    MapViewController *view = [[MapViewController alloc]init];
    view.companyDetailModel = detailModel;
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark - 拨打电话
-(void)callCompany:(NSString *)phoneStr
{
//    [MobClick event:@"Detail61"];//企业详情页－电话点击数
//    [[BaiduMobStat defaultStat] logEvent:@"Detail61" eventLabel:@"企业详情页－电话点击数"];
//
//    MyAlertView *alertView = [[MyAlertView alloc] initWithTitle:@"提示" icon:nil message:[NSString stringWithFormat:@"确定拨打电话：%@ ？",phoneStr] delegate:self buttonTitles:@"呼叫",@"取消", nil];
//    [alertView show];
    
    
    [MobClick event:@"Businessdetails02"]; //企业详情-联系电话点击数
    [[BaiduMobStat defaultStat] logEvent:@"Businessdetails02" eventLabel:@"企业详情-联系电话点击数"];
    
    NSLog(@"呼叫");
    NSString *string =[[self->detailModel.companyphonelist objectAtIndex:0] objectForKey:@"number"];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",string];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}
#pragma mark - 刷新
-(void)refreshCompany
{
    
    if([detailModel.currentstate integerValue] == 1)//已是最新
    {
        [MBProgressHUD showHint:@"已是最新信息" toView:self.view];
    }else//可以进行更新
    {
        [self updataCompanyInfo];
    }
    
}

#pragma mark - 网址
-(void)CompanyUrl:(NSString *)urlStr
{
    CommonWebViewController *view = [[CommonWebViewController alloc]init];
    view.titleStr = @"";
    
    NSRange range = [urlStr rangeOfString:@"http"];
    if(range.location != NSNotFound)//存在
    {
        view.urlStr = urlStr;
    }
    else
    {
        view.urlStr = [NSString stringWithFormat:@"http://%@",urlStr];//添加https
    }
    
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark - 拨打电话代理
-(void)alertView:(MyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        NSLog(@"取消");
    }else
    {
        [MobClick event:@"Businessdetails02"]; //企业详情-联系电话点击数
        [[BaiduMobStat defaultStat] logEvent:@"Businessdetails02" eventLabel:@"企业详情-联系电话点击数"];

        NSLog(@"呼叫");
        NSString *string =[[self->detailModel.companyphonelist objectAtIndex:0] objectForKey:@"number"];
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",string];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    
}

//设置关注按钮的标题文字
-(void)setFoucsBtn:(BOOL)isFouc
{
    
    if(!isFouc)
    {
        [focuButton setImage:KImageName(@"详情收藏") forState:UIControlStateNormal];
        focuButton.tag = 45678;
    }
    else
    {
        [focuButton setImage:KImageName(@"详情收藏_h") forState:UIControlStateNormal];
        focuButton.tag = 45677;
    }
}


-(void)drawView
{
    detailView = [[DetailView alloc]initWithFrame:KFrame(0, KNavigationBarHeight, KDeviceW, KDeviceH-KNavigationBarHeight)];
    detailView.delegate = self;
    [self.view addSubview:detailView];
}

//创建navigaiton上的东西
-(void)setRightBarBtn
{
    
    NSMutableArray *buttonArray = [[NSMutableArray alloc ] init];
    
//    shareBarButton = [self addRightItemWithImage: withImageRectRect:CGRectMake(0, 0, 20, 17) action:@selector(share)];
    
    focuButton = [self addRightItemWithImage:@"详情收藏" withImageRectRect:CGRectMake(0, 0, 17, 17) action:@selector(focuCompany:)];
    
    errorBtn = [self addRightItemWithImage:@"详情" withImageRectRect:CGRectMake(0, 0, 20, 17) action:@selector(errorCorrection)];
    
    
    if (@available(iOS 11.0,*) ){
        
    }else{
        UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                          target:nil action:nil];
        negativeSpace.width = -15;
        [buttonArray addObject:negativeSpace];
    }
    
//    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareBarButton];
    UIBarButtonItem *focuItem = [[UIBarButtonItem alloc] initWithCustomView:focuButton];
    UIBarButtonItem *errorItem = [[UIBarButtonItem alloc] initWithCustomView:errorBtn];
    
    [buttonArray addObject:errorItem];
    [buttonArray addObject:focuItem];
//    [buttonArray addObject:shareItem];
    
    self.navigationItem.rightBarButtonItems = buttonArray;
}

//ios11下改变item间距
- (void)viewDidLayoutSubviews{
    
    if (@available(iOS 11.0,*)) {
        UINavigationItem * item=self.navigationItem;
        NSArray * array=item.rightBarButtonItems;
        if (array&&array.count!=0){
            UIBarButtonItem * buttonItem=array[0];
            UIView * view =[[[buttonItem.customView superview] superview] superview];
            NSArray * arrayConstraint=view.constraints;
            for (NSLayoutConstraint * constant in arrayConstraint) {
                if (constant.constant==-16) {//-16表示右侧
                    constant.constant = 0;
                }
            }
        }
    }
    
}


//创建导航栏右边按钮的button
- (UIButton *)addRightItemWithImage:(NSString *)imageName withImageRectRect:(CGRect)imageRect action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:imageName];
    //[button setTitle:imageName forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar fs_setBackgroundColor:[UIColor clearColor]];
}

-(void)back
{
    for(NSURLSessionDataTask *task in taskArray)
    {
        if(task)
        {
            [task cancel];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopTimerRequest];//停止检查更新状态
}


- (BOOL)shouldAutorotate
{
    return YES;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return  UIInterfaceOrientationPortrait ;
}



@end
