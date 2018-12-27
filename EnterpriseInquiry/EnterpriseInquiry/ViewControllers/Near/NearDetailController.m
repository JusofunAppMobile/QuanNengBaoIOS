//
//  NearDetailController.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2018/1/2.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "NearDetailController.h"

@interface NearDetailController ()
{
    CGPoint locationPoint;
    ContentView *contentView;
    UIButton *backBtn;
    BlankSpaceView *blankSpaceView;
    
    
    NSDictionary *dataDic;
    
    CLLocationCoordinate2D companyLocation;
    
    NSString *cancelURL;
    
    NSURLSessionDataTask *dataTask;
    
    //最下面仅展示公司信息到资产营收的高度
    CGFloat downShowHight;
}

@end

@implementation NearDetailController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    downShowHight = 170;
    
    [self.view addSubview:[self setMapView]];
    
    
    [self loadData];
    [self setNavigationBarView];
    
}


-(void)loadData
{
    
    [MBProgressHUD showMessag:@"" toView:self.view]; //开启时“附近”地图界面，长时间显示缓冲效果
    

    NSString *url = [NSString stringWithFormat:@"%@?entid=%@&&mycoordinate=%f,%f&userid=%@&entname=%@&mapLat=%f&mapLng=%f",kGetEntBasicFacts,self.companyId,self.mycoordinate.latitude,self.mycoordinate.longitude,USER.userID,self.companyName,KNear.mapCenterLat,KNear.mapCenterLng];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    cancelURL = url;
    dataTask =[RequestManager postWithURLString:url parameters:nil success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"数据=%@",responseObject);
        if(blankSpaceView)
        {
            [blankSpaceView removeFromSuperview];
            blankSpaceView = nil;
        }
        if([[responseObject objectForKey:@"result"] intValue] == 0)
        {
            
            dataDic = [responseObject objectForKey:@"data"];
            MapPoint* annotation = [[MapPoint alloc]init];
            
            self.detailMapView.hidden = NO;
            companyLocation.latitude = [[dataDic objectForKey:@"map_Lat"] doubleValue];
            companyLocation.longitude = [[dataDic objectForKey:@"map_Lng"] doubleValue];
            annotation.coordinate = companyLocation;
            
            annotation.tag = self.companyId;
            annotation.title = [dataDic objectForKey:@"entname"];
            
            self.favoriteId = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"favoriteId"]];
            
            [self.detailMapView.dataMapView addAnnotation:annotation];
            
            [_detailMapView.dataMapView setCenterCoordinate:companyLocation animated:YES];
            [_detailMapView.dataMapView setMapCenterToScreenPt:CGPointMake(KDeviceW/2, (KDeviceH- downShowHight)/2)];
            
            if (_isHiddenView) {
                
            }else{
                [self setContentView];
            }
            
        }
        else
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self performSelector:@selector(showNothingView:) withObject:[responseObject objectForKey:@"msg"] afterDelay:0.3];
            
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self performSelector:@selector(showNothingView:) withObject:@"连接失败,请检查你的网络设置" afterDelay:0.3];
        
        
    }];
    
}

-(void)showNothingView:(NSString*)str
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.detailMapView.hidden = YES;
    if(blankSpaceView)
    {
        [blankSpaceView removeFromSuperview];
        blankSpaceView = nil;
    }
    
    
    // NSString * str = @"连接失败,请检查你的网络设置";
    if(str.length >0)
    {
        // str = @"连接失败,请检查你的网络设置";
        blankSpaceView = [[BlankSpaceView alloc] initWithFrame:KFrame(0, KNavigationBarHeight, KDeviceW, KDeviceH - 64 -KNavigationBarHeight) image:@"faild" text:str];
        [self.view addSubview:blankSpaceView ];
    }
    else
    {
        str = @"请求失败，请稍后重试！";
        blankSpaceView = [[BlankSpaceView alloc] initWithFrame:KFrame(0, KNavigationBarHeight, KDeviceW, KDeviceH - 64 -KNavigationBarHeight) image:@"find" text:str];
        [self.view addSubview:blankSpaceView ];
    }
    blankSpaceView.delegate = self;
    
    
}

-(void)blankSpaceViewTag
{
    [self loadData];
}

#pragma mark - 点击地址
-(void)goAdress
{
    [self scrollToDown];
}

-(void)goTop
{
    [self scrollToTop];
}


#pragma mark - 查看详情
-(void)checkDetail
{
    
    CompanyDetailController *detailController = [[CompanyDetailController alloc] init];
    
    detailController.companyName = [dataDic objectForKey:@"entname"];
    
    detailController.companyId = self.companyId;
    //detailController.favoriteId = self.favoriteId;
    //    detailController.collectChangeDelegate = self;
    [self.navigationController pushViewController:detailController animated:YES];

}

#pragma mark - 收藏企业
-(void)collectCompany:(BOOL)isCollect
{
    /*
    if(isCollect)
    {
        [MBProgressHUD showMessag:@"" toView:self.view];
        NSString *urlStr = [NSString stringWithFormat:@"%@?userid=%@&entid=%@&operatetype=add",kMyCollect,[KUserDefaults objectForKey:@"userid"],self.companyId];
        cancelURL = urlStr;
        dataTask = [[RequestManager sharedManger]requestWithMethod:KHttpGET url:urlStr params:nil success:^(id response) {
            NSLog(@"%@",response);
            
            if([[response objectForKey:@"result"] intValue] == 0)
            {
                
                self.favoriteId = [NSString stringWithFormat:@"%@",[response objectForKey:@"favoriteid"]];
                [MBProgressHUD showSuccess:@"收藏成功" toView:self.view];
                [contentView changeCollect:YES];
                
            }
            else
            {
                [MBProgressHUD showError:[response objectForKey:@"msg"] toView:self.view];
            }
        } failure:^(NSError *error) {
            
            [MBProgressHUD showError:@"请求失败" toView:self.view];
        }];
        
    }
    else
    {
        [MBProgressHUD showMessag:@"" toView:self.view];
        NSString *url = [NSString stringWithFormat:@"%@?userid=%@&favoriteid=%@&entid=%@&operatetype=delete",kMyCollect,[KUserDefaults objectForKey:@"userid"],self.favoriteId,self.companyId];
        NSString *requestURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",requestURL);
        cancelURL = requestURL;
        dataTask = [[RequestManager sharedManger]requestWithMethod:KHttpGET url:requestURL params:nil success:^(id response) {
            [MBProgressHUD hideHUD:self.view animated:YES];
            cancelURL = @"";
            if([[response objectForKey:@"result"] intValue] == 0)
            {
                [self setRightNavigationBarBtnWithTitle:nil withImageName:@"collection"];
                
                [MBProgressHUD showSuccess:@"取消成功" toView:self.view];
                
                [contentView changeCollect:NO];
            }
            else
            {
                [MBProgressHUD showError:[response objectForKey:@"msg"] toView:self.view];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"请求失败" toView:self.view];
            cancelURL = @"";
        }];
        
    }
    
     */
    
}


-(void)collectChang:(BOOL)isChange
{
    [contentView changeCollect:isChange];
}

#pragma mark - 拖动

-(void)panGestureRecognizer:(UIPanGestureRecognizer*)pan
{
    if(pan.state == UIGestureRecognizerStateBegan)
    {
        locationPoint = [pan locationInView:contentView];
    }
    else if (pan.state == UIGestureRecognizerStateChanged)
    {
        CGPoint touchLocation = [pan locationInView:contentView];
        
        
        CGRect frame = contentView.frame;
        
        
        //NSLog(@"%f",touchLocation.y -locationPoint.y)
        
        frame.origin.y = frame.origin.y + touchLocation.y -locationPoint.y ;
        if(frame.origin.y < KDeviceH - CGRectGetHeight(contentView.frame) )
        {
            frame.origin.y = KDeviceH - CGRectGetHeight(contentView.frame);
            
        }
        
        if(frame.origin.y > KDeviceH - downShowHight)
        {
            frame.origin.y = KDeviceH - downShowHight;
            
        }
//        if(frame.origin.y > KDeviceH - downShowHight  )
//        {
//            CGFloat hight = frame.origin.y - (KDeviceH - downShowHight);
//
//            // NSLog(@"%f",hight);
//
//            [contentView changeInfoBackView:NO];
//
//        }
//        else//防止一下子滑很大
//        {
//            [contentView changeInfoBackView:YES];
//        }
        
        if(frame.origin.y<=64)
        {
            [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            [contentView changeInfoBackView:YES];
        }
        else
        {
            [backBtn setImage:[UIImage imageNamed:@"地图返回键"] forState:UIControlStateNormal];
             
            [contentView changeInfoBackView:NO];
            
        }
        
        if(frame.origin.y >200)
        {
            
            [_detailMapView.dataMapView setMapCenterToScreenPt:CGPointMake(KDeviceW /2, frame.origin.y/2)];
        }
        
        contentView.frame = frame;
        
        CGFloat offset_Y = contentView.frame.origin.y;
        CGFloat alpha = ( changeHight  - offset_Y  + 20)/changeHight;
        
        self.navigationBarView.backgroundColor = [self.navigationBarColor colorWithAlphaComponent:alpha];
        self.navigationBarTitleLabel.alpha = alpha;
        
    }
    else if (pan.state == UIGestureRecognizerStateEnded)
    {
        __block CGRect frame = contentView.frame;
        
        if(frame.origin.y<64+changeHight*2&&frame.origin.y>=20)
        {
            
            [self scrollToTop];
            
        }
        else if (frame.origin.y > KDeviceH - downShowHight - downShowHight && frame.origin.y <=KDeviceH - downShowHight)
        {
            [self scrollToDown];
        }
        
    }
    else
    {
        
    }
}

//滚到底
-(void)scrollToDown
{
    KWeakSelf
    __block CGRect frame = contentView.frame;
    [UIView animateWithDuration:0.2 animations:^{
        [contentView changeInfoBackView:NO];
        frame.origin.y = KDeviceH - downShowHight;
        contentView.frame = frame;
        CGFloat alpha = 0;
        weakSelf.navigationBarView.backgroundColor = [weakSelf.navigationBarColor colorWithAlphaComponent:alpha];
        
        [backBtn setImage:[UIImage imageNamed:@"地图返回键"] forState:UIControlStateNormal];
        
    } completion:^(BOOL finished) {
        
    }];
    
}
//滚到头
-(void)scrollToTop
{
    KWeakSelf
    __block CGRect frame = contentView.frame;
    
    [UIView animateWithDuration:0.2 animations:^{
        [contentView changeInfoBackView:YES];
        frame.origin.y = KShowAllY;
        contentView.frame = frame;
       // CGFloat offset_Y = contentView.frame.origin.y;
       // CGFloat alpha = ( changeHight - offset_Y + 20 )/changeHight;
        weakSelf.navigationBarView.backgroundColor = [weakSelf.navigationBarColor colorWithAlphaComponent:1];
        weakSelf.navigationBarTitleLabel.alpha = 1;
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)updateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_detailMapView.locService stopUserLocationService];
    [_detailMapView.dataMapView setCenterCoordinate:companyLocation animated:YES];
    [_detailMapView.dataMapView setMapCenterToScreenPt:CGPointMake(KDeviceW/2, (KDeviceH- downShowHight)/2)];
    
    
}


#pragma mark - 创建navigaitonBar
-(void)setNavigationBarView
{
    CGFloat hight = 64 ;
    if(KIsIphoneX)
    {
        hight = 88;
    }
    
    //添加背景view
    CGRect backView_frame = CGRectMake(0, 0, KDeviceW, hight);
    UIView *backView = [[UIView alloc] initWithFrame:backView_frame];
    UIColor *backColor = [UIColor whiteColor];
    backView.backgroundColor = [backColor colorWithAlphaComponent:0.0];
    [self.view addSubview:backView];
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, KStatusBarHeight, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"地图返回键"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, KStatusBarHeight, KDeviceW -100, 44)];
    titleLabel.text = @"企业概况";
    titleLabel.textColor = KRGB(66, 66, 66);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = KFont(16);
    titleLabel.alpha = 0;
    [backView addSubview:titleLabel];
    self.navigationBarTitleLabel = titleLabel;
    
    
    self.navigationBarView = backView;
    self.navigationBarColor = backColor;
}

#pragma mark - 创建地图
-(UIView *)setMapView
{
    _detailMapView = [[NearMapView alloc]initWithFrame:CGRectMake(0,0, KDeviceW,  KDeviceH )];
    _detailMapView.isMapIntroduction = YES;
    _detailMapView.mapTapDelegate = self;
    [_detailMapView.dataMapView setMapCenterToScreenPt:CGPointMake(KDeviceW/2, downShowHight/2)];
    return _detailMapView;
}



-(void)setContentView
{
    contentView = [[ContentView alloc]initWithFrame:CGRectMake(0, KDeviceH/2, KDeviceW, KDeviceH/2) withCompanyDic:dataDic];
    contentView.delegate = self;
    downShowHight = contentView.detailBtnHight;
    
//    CGRect frame = contentView.frame;
//    frame.origin.y = KDeviceH - downShowHight;
//    contentView.frame = frame;
  
    [self.view insertSubview:contentView belowSubview:self.navigationBarView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizer:)];
    [contentView addGestureRecognizer:pan];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [_detailMapView dataMapViewWillAppear];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [_detailMapView dataMapViewWillDisappear];
    [dataTask cancel];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    
}


-(void)backView
{
    [self.navigationController popViewControllerAnimated:YES];
}






@end
