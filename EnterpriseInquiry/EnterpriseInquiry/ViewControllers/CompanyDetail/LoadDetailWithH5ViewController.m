//
//  LoadDetailWithH5ViewController.m
//  EnterpriseInquiry
//
//  Created by clj on 15/11/16.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "LoadDetailWithH5ViewController.h"
#import "CompanyMap.h"
#import "BranchOrInvesmentCell.h"

#import <MJRefresh.h>
#import "ItemView.h"
#import "AnimalTableView.h"
//#import "RefreshHeader.h"


#define animationDuration 0.4
#define cellHeight 36
@interface LoadDetailWithH5ViewController ()<UIWebViewDelegate,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout,ItemViewDelegate>
{
    UILabel *titleLabel;
    UIImageView *titleImageView;
    ItemView *backItemView;
    UIView *ChoosBackView;
    UIView *tapView;
    CGFloat itemHeight;
    int selectNum;
    BOOL isSelect;
    CGFloat _collectionHeigh;
    NSDictionary *companyMapDic;//企业图谱的数据
    CompanyMap *_companyView; //企业图谱视图
    UIScrollView *_hasNoShareView;//企业图谱背景
    NSString *invesmentType ;//1对外投资，2 分支机构
    AnimalTableView *_animalTableView;
    NSInteger pageIndex;//对外投资和分支机构的分页
    BOOL isRefreshHeader;//是否是头部刷新
    BOOL isHasMoreData;//是否还有更多数据
    NSMutableArray *_investDataArray;//分支机构和对外投资数组
    UIView *_investmentView;//对外投资视图
    //AFHTTPRequestOperation *operation;
    UIButton *errorButton;//纠错按钮
    UIButton *rightBarButton;
    UIButton *titleButton;//点击下拉按钮
    NSString  *_firstUrl;
    NSString  *_nowUrl;
    BOOL isFirstJump;// 用来标记是不是第一次进入此页面（为了处理第一次加载页面时，用特定的加载页面动画，而在页面内切换时显示小黑圈加载动画 ）
    BOOL isWebviewCanBack;//记录webview 是不是可以返回第一层（改变titleName）
}
@end
@implementation LoadDetailWithH5ViewController
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:false];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationController.navigationBar.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive)    name:UIApplicationDidBecomeActiveNotification object:nil];
   [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
    
}

-(void)becomeActive
{
    [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self setNavigationBarTitle:@"我的关注" ];
    [self setBackBtn:@"back"];
    _investDataArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = KHexRGB(0xf2f3f5) ;
    
    isFirstJump = YES;
    isWebviewCanBack = NO;
    rightBarButton= [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    rightBarButton.backgroundColor = [UIColor clearColor];
    
    errorButton= [[UIButton alloc] init];
    errorButton.frame = CGRectMake(12, (44 - 18)/2, 35, 18);
    errorButton.backgroundColor = [UIColor clearColor];
//    [errorButton setTitle:@"纠错" forState:UIControlStateNormal];
    [errorButton setImage:KImageName(@"纠错") forState:UIControlStateNormal];
    errorButton.titleLabel.font = KFont(16);
    [errorButton setTitleColor: KHexRGB(0xffffff) forState:UIControlStateNormal];
//    errorButton.layer.cornerRadius = 4;
//    
//    errorButton.clipsToBounds = YES;
//    errorButton.layer.borderColor =  KHexRGB(0xffa16a).CGColor;
//    errorButton.layer.borderWidth = 1;
    [errorButton addTarget:self action:@selector(hrefToError) forControlEvents:UIControlEventTouchUpInside];
    [rightBarButton addSubview:errorButton];
    
    [rightBarButton addTarget:self action:@selector(hrefToError) forControlEvents:UIControlEventTouchUpInside];
   
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
     [self setTitleView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 64, KDeviceW, 0.5);
    lineView.backgroundColor =  KHexRGB(0xd9d9d9);
    [self.view addSubview:lineView];
    int count = (int)(self.sqiareList.count%3 == 0?self.sqiareList.count/3:self.sqiareList.count/3+1);
    itemHeight = (35+0.5)* count;
    //加载webView
    [self createWebView];
    
    _collectionHeigh = _sqiareList.count%4 == 0? _sqiareList.count/4*cellHeight + 4 :(_sqiareList.count/4 + 1)*cellHeight + 4;
    selectNum = 0;
    isSelect = NO;
    [self setChooseView];
    //根据type值不同加载相对应类型的视图
    [self loadDifViewWith:self.squareModel];
}



-(void)back
{
    if ([_firstUrl isEqualToString:_nowUrl]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        if ([self.webView canGoBack]&&isWebviewCanBack) {
            [self.webView goBack];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}



#pragma mark - 纠错
-(void)hrefToError
{
    
    RecoveryErrorViewController *recoverError = [[RecoveryErrorViewController alloc] init];
    recoverError.squearList = _sqiareList;
    recoverError.companyId = self.companyId;
    recoverError.currentSquareModel = self.squareModel;
    recoverError.companyName = self.companyName;
    [self.navigationController pushViewController:recoverError animated:YES];
}

#pragma mark -对外投资-分支机构
-(void)getEntBranchOrInvesmentData
{
    if (_investmentView  == nil) {
        [self createTableView];
    }
    if (_investDataArray.count == 0) {
        if (isFirstJump) {
           // [self showLoadDataAnimation];
            isFirstJump = !isFirstJump;
        }else
        {
            [MBProgressHUD showMessag:@"" toView:self.view];
        }
    }
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:invesmentType forKey:@"type"];
    [paraDic setObject:self.companyId forKey:@"entid"];
    [paraDic setObject:self.companyName forKey:@"entname"];
    [paraDic setObject:@"20" forKey:@"pagesize"];
    [paraDic setObject:self.companyName forKey:@"entname"];
    [paraDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"pageIndex"];
    [paraDic setObject:USER.userID forKey:@"userid"];
     NSString* urlstr = [GetEntBranchOrInvesment stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [RequestManager getWithURLString:urlstr parameters:paraDic success:^(id responseObject) {
        [MBProgressHUD hideHudToView:self.view animated:YES];
        
        if([[responseObject objectForKey:@"result"] intValue] == 0)
        {
            
            BranchOrInvesmentModel *invesmentModel = [BranchOrInvesmentModel mj_objectWithKeyValues:responseObject];
            [_animalTableView.tableView.mj_header endRefreshing];
            [_animalTableView.tableView.mj_footer endRefreshing];
            if([invesmentModel.ismore isEqualToString:@"true"])
            {
                isHasMoreData = YES;
            }else
            {
                isHasMoreData = NO;
                [_animalTableView.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (isRefreshHeader || pageIndex == 1)
            {
                [_investDataArray removeAllObjects];
            }else
            {
                if(!isHasMoreData || invesmentModel.list.count <= 20){
                    [_animalTableView.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            [_investDataArray addObjectsFromArray:invesmentModel.list];
            //如果是头部刷新，在头部刷新里会再次将页码重置为1，头部刷新加载的也将会是第一页
            //在此将页码增加是因为在第一次头部刷新之后，再进行尾部刷新是加载的是第二页
            pageIndex ++ ;
            [_animalTableView.tableView reloadData];
        }
        else
        {
            [MBProgressHUD showError:[responseObject objectForKey:@"msg"] toView:self.view];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        //[MBProgressHUD showMessag:@"" toView:self.view];
        [MBProgressHUD showError:error.description toView:self.view];
    }];

}
#pragma mark - 对外投资和分支机构
-(void)createTableView
{
    _investmentView = [[UIView alloc] init];
    _investmentView.frame = CGRectMake(0, 65, KDeviceW, self.view.frame.size.height);
    _investmentView.backgroundColor = KHexRGB(0xf2f3f5) ;
    [self.view insertSubview:_investmentView belowSubview:ChoosBackView];
    _animalTableView = [[AnimalTableView alloc] init];
    _animalTableView.tableView.backgroundColor = [UIColor redColor];
    _animalTableView.dataArray = _investDataArray;
    _animalTableView.tableView.frame = CGRectMake(0, 0, KDeviceW, KDeviceH - 64);
    _animalTableView.view.backgroundColor =  KHexRGB(0xf2f3f5);
    [_investmentView addSubview:_animalTableView.view];
    _animalTableView.tableView.tableFooterView = [[UIView alloc] init];
    __weak typeof(self) weakSelf = self;
    __block LoadDetailWithH5ViewController *blockSelf = self;
    __block AnimalTableView *blockTableView = _animalTableView;
    [_animalTableView setNumberOfRowsInSectionCompletion:^NSInteger(NSInteger section) {
        return  blockTableView.dataArray.count;
    }];
    [_animalTableView setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        static NSString *Identity = @"InvestCell";
        BranchOrInvesmentCell *cell = [tableView dequeueReusableCellWithIdentifier:Identity];
        if (cell == nil) {
            cell = [[BranchOrInvesmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identity];
        }
        CompanyDetailModel *comModel = [CompanyDetailModel mj_objectWithKeyValues:[blockTableView.dataArray objectAtIndex:indexPath.row]] ;
        cell.companyState.hidden = YES;
        
        if([ blockSelf->invesmentType isEqual: @"1"]) //1对外投资，2 分支机构
        {
            CGFloat height = [cell heightForCellWithText:comModel];
            CGRect cellFrame = cell.frame;
            cellFrame.size.height = height;
            cell.frame = cellFrame;
            
        }
        else
        {
            cell.legalName.hidden = YES;
            cell.legalImageView.hidden = YES;
            
            [cell heightForCellWithText:comModel];
            CGRect cellFrame = cell.frame;
            cellFrame.size.height = 50;
            cell.frame = cellFrame;
        }
        

       
        return cell;
    }];
    [_animalTableView setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
        BranchOrInvesmentCell *cell = (BranchOrInvesmentCell *)[blockTableView tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }];
    [_animalTableView setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
      CompanyDetailModel *comModel = [CompanyDetailModel mj_objectWithKeyValues:[blockTableView.dataArray objectAtIndex:indexPath.row]] ;
        CompanyDetailController *comView = [[CompanyDetailController alloc] init];
        comView.companyId = comModel.companyid;
        comView.companyName = comModel.companyname;
        [weakSelf.navigationController pushViewController:comView animated:YES];
    }];
    [_animalTableView setViewForFootInSection:^UIView *(NSInteger section) {
        UIView *view = [[UIView alloc] init];
        return view;
    }];
    _animalTableView.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        isRefreshHeader = YES;
        pageIndex = 1;
        [weakSelf getEntBranchOrInvesmentData];
    }];
    _animalTableView.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        isRefreshHeader = NO;
        [weakSelf getEntBranchOrInvesmentData];
    }];
}
#pragma mark - 根据type值不同加载相对应类型的视图
-(void)loadDifViewWith:(ItemModel *)model
{
    if ([model.type integerValue] ==  2) {
        [self createCompanyMap];
    }else if([model.type integerValue] ==  3)
    {
        NSLog(@"对外投资");
        invesmentType = @"1";
        pageIndex = 1;
        [self getEntBranchOrInvesmentData];
    }
    else if([model.type integerValue] == 4){
        NSLog(@"分支机构");
        pageIndex = 1;
        invesmentType = @"2";
        [self getEntBranchOrInvesmentData];
    }else
    {
        [self loadWithUrl:[NSString stringWithFormat:@"%@",model.applinkurl]];
        NSLog(@"%@",[NSString stringWithFormat:@"%@",model.applinkurl]);
    }
}
//移除视图
-(void)removeOtherView
{
    if (_hasNoShareView != nil) {
        [_hasNoShareView removeFromSuperview];
    }
    if (_companyView) {
        [_companyView removeFromSuperview];
        _companyView = nil;
    }
    if (_investmentView != nil) {
        [_investmentView removeFromSuperview];
        _investmentView = nil;
    }
    if (_animalTableView.tableView != nil) {
        [_animalTableView.tableView removeFromSuperview];
        _animalTableView.tableView = nil;
    }
}
#pragma mark - 企业图谱
-(void)createCompanyMap
{
    if ([companyMapDic count]>0) {
        [self showNoViewOrOtherWith:companyMapDic];
    }else
    {
        
        [MBProgressHUD showMessag:@"" toView:self.view];

        NSString *url = [NSString stringWithFormat:@"%@?entid=%@&entname=%@&userid=%@",GetEntAtlasData,self.companyId,self.companyName,USER.userID];
        NSString *requestURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [MBProgressHUD showMessag:@"" toView:self.view];
        [RequestManager getWithURLString:requestURL parameters:nil success:^(id responseObject) {
             [MBProgressHUD hideHudToView:self.view animated:YES];
                       
            CompanyMapModel *compModel = [CompanyMapModel mj_objectWithKeyValues:responseObject];
            if([[responseObject objectForKey:@"result"] intValue] == 0)
            {
                companyMapDic = compModel.data;
                [self showNoViewOrOtherWith:companyMapDic];
            }
            else
            {
                [MBProgressHUD showError:[responseObject objectForKey:@"msg"] toView:self.view];
            }
            
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error.description);
            //[MBProgressHUD showMessag:@"" toView:self.view];
            [MBProgressHUD showError:error.description toView:self.view];
        }];

        
       
    }
}

#pragma mark - 判断该显示有企业投资的页面还是没有的页面
-(void)showNoViewOrOtherWith:(NSDictionary *)dataDic
{
    if (_hasNoShareView != nil) {
        [_hasNoShareView removeFromSuperview];
    }
    [self createCompanyMapWithNumDic:dataDic];
    return;
}
#pragma mark - 当企业图谱没有信息时
-(void)createComanpanyWithNoShareAndInvest
{
    if (_companyView) {
        [_companyView removeFromSuperview];
        _companyView = nil;
    }
    _hasNoShareView = [[UIScrollView alloc] init];
    _hasNoShareView.frame = CGRectMake(0, 1, KDeviceW, KDeviceH);
    _hasNoShareView.backgroundColor = KHexRGB(0x292b35);
    [self.view insertSubview:_hasNoShareView belowSubview:ChoosBackView];
    _hasNoShareView.delegate = self;
    _hasNoShareView.tag = 503;
    _hasNoShareView.showsVerticalScrollIndicator = NO;
    _hasNoShareView.contentSize = CGSizeMake(0, KDeviceH);
    UIView *nameView = [[UIView alloc] init];
    nameView.backgroundColor =  KHexRGB(0x292b35);
    nameView.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    [_hasNoShareView addSubview:nameView];
    UIView *accesView = [[UIView alloc] init];
    accesView.frame = CGRectMake(15, 10, 3, 24);
    accesView.backgroundColor = [UIColor redColor];
    [nameView addSubview:accesView];
    UILabel *namelabel = [[UILabel alloc] init];
    namelabel.frame = CGRectMake(18 + 10, 0,self.view.frame.size.width -28 , 44);
    namelabel.text = @"企业图谱";
    namelabel.textColor = [UIColor whiteColor];
    namelabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [nameView addSubview:namelabel];
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.frame = CGRectMake(0, CGRectGetMaxY(nameView.frame) + 5, self.view.frame.size.width, 20);
    contentLabel.text = @"    暂无数据，试试下拉更新";
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.textColor = [UIColor lightGrayColor];
    contentLabel.backgroundColor = [UIColor blackColor];
    contentLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [_hasNoShareView addSubview:contentLabel];
}

#pragma mark - 有企业图谱
-(void)createCompanyMapWithNumDic:(NSDictionary *)Dic
{
    if (_hasNoShareView) {
        [_hasNoShareView removeFromSuperview];
        _hasNoShareView = nil;
    }
    if (_companyView == nil) {
        _companyView = [[CompanyMap alloc] initWithFrame:KFrame(0, 65, KDeviceW, KDeviceH -64 ) andDicInfo:Dic];
        _companyView.delegate = self;
        [self.view insertSubview:_companyView belowSubview:ChoosBackView];
    }
}
-(void)zhanKaiCompanyMap
{
    CompanyMapController *view = [[CompanyMapController alloc]init];
    view.entid = self.companyId;
    view.companyDic = companyMapDic;
    view.companyName = self.companyName;
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark - 设置下拉选择
-(void)setChooseView
{
    UIView *backView = [[UIView alloc]initWithFrame:self.view.frame];
    backView.backgroundColor = KRGBA(153, 153, 153, 0.5);
    [self.view addSubview:backView];
    ChoosBackView = backView;
    backView.alpha = 0;
    
    //为了解决父子视图手势冲突的问题，所以用兄弟视图来解决这个问题
    //这是点击空白处关闭下拉视图的功能
    UIView *tapInstaneGView = [[UIView alloc] init];
    tapInstaneGView.frame = CGRectMake(0,0, backView.frame.size.width, self.view.frame.size.height);
    tapInstaneGView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(open)];
    [tapInstaneGView addGestureRecognizer:tapGest];
    tapView = tapInstaneGView;
    [backView addSubview:tapInstaneGView];
    
    ItemView *itemView = [[ItemView alloc] initWithframe:CGRectMake(0, -itemHeight, self.view.frame.size.width, itemHeight) andArray:self.sqiareList andThisModel:self.squareModel];
    itemView.delegate = self;
    backItemView = itemView;
    [backView addSubview:itemView];
}

#pragma mark - 九宫格的点击事件
-(void)pullItemButtonClick:(ItemButton *)itemButton
{
    isWebviewCanBack = NO;
    ItemModel *model = itemButton.squareModel;
    itemButton.selected = YES;
    self.titleLableName = model.menuname;
    self.squareModel = model;
    titleLabel.text = self.titleLableName;
    [self setTitleView];
    [titleLabel sizeToFit];
    [self open];
    //移除掉其他视图
    [self removeOtherView];
    //根据type值不同加载相对应类型的视图
    [self loadDifViewWith:model];
}
#pragma mark - 设置self.title
-(void)setTitleView
{
    int scale;
    if( KScreen35)
    {
        scale = 45;
    }
    else if (KScreen4)
    {
        scale = 50;
    }
    else if(KScreen47)
    {
        scale = 65;
    }
    else
    {
        scale = 70;
    }
    
    
    [self.navigationItem.titleView removeFromSuperview];
    self.navigationItem.titleView = nil;
    UIView *backView =  [[UIView alloc]initWithFrame:KFrame(KDeviceW /2 ,22,KDeviceW - 120, 44)];
    backView.hidden = YES;
    titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
    titleButton.frame = CGRectMake(0, 0, KDeviceW - 120, 44);
    titleLabel = [[UILabel alloc]initWithFrame:KFrame((scale )* KScaleWidth, 0, KDeviceW -120 , CGRectGetHeight(backView.frame))];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = KLargeFont;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor =[UIColor whiteColor] ;//RGB(23, 45, 234);
    [backView addSubview:titleLabel];
    titleImageView = [[UIImageView alloc]initWithFrame:KFrame(0, CGRectGetHeight(backView.frame)/2 - 6, 8,4)];
    titleImageView.image = KImageName(@"icon-Dropdown");
    CGRect leftViewbounds = self.navigationItem.leftBarButtonItem.customView.bounds;
    CGRect rightViewbounds = self.navigationItem.rightBarButtonItem.customView.bounds;
    CGRect frame;
    CGFloat maxWidth = leftViewbounds.size.width > rightViewbounds.size.width ? leftViewbounds.size.width : rightViewbounds.size.width;
    maxWidth += 30;//leftview 左右都有间隙，左边是5像素，右边是8像素，加2个像素的阀值 5 ＋ 8 ＋ 2
    frame = titleLabel.frame;
    frame.size.width = KDeviceW - maxWidth * 2;
    titleLabel.frame = frame;
    titleLabel.text = self.titleLableName;
    [titleLabel sizeToFit];
    frame = backView.frame;
    frame.size.width = KDeviceW - maxWidth * 2;
    frame.size.height = titleLabel.frame.size.height;
    backView.frame = frame;
    CGRect imageFrame = titleImageView.frame;
    imageFrame.origin.x =  CGRectGetMaxX(titleLabel.frame) + 10;
    imageFrame.origin.y = titleLabel.center.y - imageFrame.size.height/2;
    titleImageView.frame = imageFrame;
    [backView addSubview:titleButton];
    [backView addSubview:titleImageView];
    self.navigationItem.titleView = backView;
    backView.hidden = NO;
}

#pragma mark - 展开关闭选择栏
-(void)open
{
    __block CGRect frameItem = backItemView.frame;
    if(isSelect)
    {
        isSelect = NO;
        [UIView animateWithDuration:animationDuration * 1.5
                              delay:0
             usingSpringWithDamping:0.7
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             frameItem.origin.y = - itemHeight;
                             backItemView.frame = frameItem;
                             ChoosBackView.alpha = 0.0;
                             
                             titleImageView.transform = CGAffineTransformIdentity;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    else
    {
        isSelect = YES;
        [UIView animateWithDuration:animationDuration * 1.5
                              delay:0
             usingSpringWithDamping:0.7
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                            // frameItem.size.height = itemHeight;
                             frameItem.origin.y = 64;
                             backItemView.frame = frameItem;
                             ChoosBackView.alpha = 1.0;
                             titleImageView.transform = CGAffineTransformRotate(titleImageView.transform, M_PI);
                         } completion:^(BOOL finished) {
                         }];
    }
}

#pragma mark - 创建webview
-(UIWebView *)createWebView
{
    self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height );
    self.webView.enablePanGesture = NO;
    return self.webView;
}
#pragma mark - 加载webview url
-(void)loadWithUrl:(NSString *)strUrl
{
    _firstUrl = strUrl;
    NSString  *urlString = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL*url=[NSURL URLWithString:urlString];
    NSURLRequest*request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [self.webView loadRequest:request];
    
}

//切换下拉12宫格选项出发事件
-(BOOL)changItemClickWithTitle:(NSString *)title
{
    isWebviewCanBack = YES;
    titleLabel.text = title;
    [titleLabel sizeToFit];
    titleImageView.hidden = YES;
    errorButton.hidden = YES;
    titleButton.userInteractionEnabled = NO;
    errorButton.userInteractionEnabled = NO;
    rightBarButton.userInteractionEnabled = NO;
    return YES;
}
#pragma mark - webViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    NSString *URLStr =[self URLDecodedString: [[request URL] absoluteString]];
    if (URLStr.length >= Md5Encryption.length) {
        NSString *demoStr = [URLStr substringWithRange:NSMakeRange(0, Md5Encryption.length)];
        if ([demoStr isEqualToString:Md5Encryption]) {
            return NO;
        }
    }
    titleButton.userInteractionEnabled = YES;
    _nowUrl = URLStr;
    NSString *str = @"companyinfo://";
    NSString *idStr;
    NSString *nameStr;
    if ([URLStr rangeOfString:@"nbxx_detail"].location != NSNotFound)
    {
        [self changItemClickWithTitle:@"年报详情"];
    }else if([URLStr rangeOfString:@"qyzx_detail"].location != NSNotFound)
    {
        [self changItemClickWithTitle:@"资讯详情"];
    }else if([URLStr rangeOfString:@"QueryResult"].location != NSNotFound)
    {
        [self changItemClickWithTitle:@"失信详情"];
    }
    else if ([URLStr rangeOfString:HOSTURL].location == NSNotFound)
    {
        
    }
    else{
        if (isWebviewCanBack) {
            titleLabel.text = self.titleLableName;
            titleImageView.hidden = NO;
            errorButton.hidden = NO;
            titleButton.userInteractionEnabled = YES;
            errorButton.userInteractionEnabled = YES;
            rightBarButton.userInteractionEnabled = YES;
        }
    }
    if([URLStr rangeOfString:str].location != NSNotFound)
    {
        NSString *appendStr = [URLStr substringFromIndex:str.length];
        NSArray *strArray = [appendStr componentsSeparatedByString:@"&"];
        if(strArray.count >0)
        {
            NSString *str1 = [strArray objectAtIndex:0];
            if(str1.length >0)
            {
                NSString *str2 = @"id=";
                idStr = [str1 substringFromIndex:str2.length];
            }
        }
        if(strArray.count >1)
        {
            NSString *str1 = [strArray objectAtIndex:1];
            if(str1.length >0)
            {
                NSString *str2 = @"name=";
                nameStr = [str1 substringFromIndex:str2.length];
            }
        }
        CompanyDetailController *comView = [[CompanyDetailController alloc] init];
        comView.companyId = idStr;
        comView.companyName = nameStr;
        [self.navigationController pushViewController:comView animated:YES];
        return  NO;
    }
    else
    {
        if([URLStr rangeOfString:@"http://"].location != NSNotFound || [URLStr rangeOfString:@"https://"].location != NSNotFound || [URLStr rangeOfString:@"www"].location != NSNotFound)
        {
            return YES;
        }else
        {
            return  NO;
        }
    }
}
-(NSString *)URLDecodedString:(NSString*)stringURL
{
    return (__bridge NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)stringURL,CFSTR(""),kCFStringEncodingUTF8);
}


//手势滑动返回
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        if ([_firstUrl isEqualToString:_nowUrl]) {
            return YES;
        }else{
            return NO;
        }
    }else if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]&& [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]){
        return YES;
    }else{
        return  NO;
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError");
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter ] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
  //  [operation cancel];
//    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
