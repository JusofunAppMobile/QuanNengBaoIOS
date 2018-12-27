//
//  NearMapController.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2017/12/21.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "NearMapController.h"

@interface NearMapController ()
{
    //定位到自己的位置的btn
    UIButton* loaction;
   
    BMKUserLocation *userLoc;// 记录用户位置
    int loadNum ;
    
    BOOL isTalbeViewShow;
    
    
    CRGradientLabel *countLabel;
    
    NSURLSessionDataTask *requestTask;
    
    UIView *companyBackView;//tableview的背景
    
    
    UILabel *totalLabel;//tableview显示数量的label
    
    
    float mapzoom;//标记地图变化前的放大级别
    
    CLLocationCoordinate2D mapCenter;//原来地图的中心点
    
    BlankSpaceView *blankSpaceView;
    
    BOOL pushList;
    
}

@end

@implementation NearMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    pushList = YES;
    
    [self setMapView];
    [self setCompanyListView];
    
    MBProgressHUD* hud = [MBProgressHUD showMessag:@"请求地图数据" toView:self.view];
    hud.userInteractionEnabled = NO;
    
}
#pragma mark - 请求地图信息
-(void)loadMapData
{
    if(requestTask)
    {
        [requestTask cancel];
    }
    countLabel.hidden = YES;
    _nearMapView.isFiveType = NO;
    KBolckSelf;
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:self.view];
    hud.userInteractionEnabled = NO;
    NSString *str = [NSString stringWithFormat:@"%@?maptype=%d&province=%@&city=%@&maxLat=%f&minLat=%f&maxLng=%f&minLng=%f&usernameid=%@&currentlatlng=%f,%f",kGetMapList,KNear.maptype,KNear.province,KNear.city,KNear.mapMinPoint.latitude,KNear.mapMaxPoint.latitude,KNear.mapMaxPoint.longitude,KNear.mapMinPoint.longitude,USER.userID, KNear.mapCenterLat, KNear.mapCenterLng];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   requestTask = [RequestManager getWithURLString:str parameters:nil success:^(id responseObject) {
        [MBProgressHUD hideHudToView:blockSelf.view animated:YES];
        NSLog(@"地图数据=%@",responseObject);
        NSString *countStr;
        if([[responseObject objectForKey:@"result"]intValue] == 0)
        {
            blockSelf.mapArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"data"]];
            //移除之前的大头针
            NSArray* array = [NSArray arrayWithArray:_nearMapView.dataMapView.annotations];
            [_nearMapView removePointWithDataArray:array];
            
            if(KNear.maptype == 4)
            {
                if(blockSelf.mapArray.count != 0)
                {
                    _nearMapView.isFiveType = YES;
                    //加上现在的大头针
                    [_nearMapView setPointWithDictary:blockSelf.mapArray];
                }
                
                NSInteger total = 0;
                for (NSDictionary *dic in blockSelf.mapArray) {
                    total = total + [dic[@"total"] integerValue];
                }
                
                countStr = [NSString stringWithFormat:@"附近共有%@家,目前显示%@家",responseObject[@"total"],responseObject[@"alreadyShowNum"]];
            }else
            {
                if (blockSelf.mapArray.count != 0){
                    [_nearMapView setPointWithDataArray:blockSelf.mapArray andMapType:KNear.maptype];
                }
                
                if (KNear.maptype == 1)
                {
                    countStr = [NSString stringWithFormat:@"全国共有%@家企业",responseObject[@"total"]];
                }else
                {
                    if (blockSelf.mapArray.count != 0)
                    {
                        NSDictionary *dic = blockSelf.mapArray[0];
                        if(KNear.maptype == 2)
                        {
                            countStr = [NSString stringWithFormat:@"%@共有%@家企业",dic[@"area"],responseObject[@"total"]];
                        }else
                        {
                            countStr = [NSString stringWithFormat:@"%@共有%@家企业",KNear.city,responseObject[@"total"]];
                        }
                    }else
                    {
                        countStr = @" 没有搜索到相关企业";
                    }
                }
            }
            countLabel.hidden = NO;
            countLabel.text = countStr;
           
        }
        else
        {
            [MBProgressHUD showError:[responseObject objectForKey:@"msg"] toView:blockSelf.view];
            //加载失败,也移除之前的大头针
            NSArray* array = [NSArray arrayWithArray:_nearMapView.dataMapView.annotations];
            
            [_nearMapView removePointWithDataArray:array];
        }
        
    } failure:^(NSError *error) {
        //加载失败,也移除之前的大头针
        NSArray* array = [NSArray arrayWithArray:_nearMapView.dataMapView.annotations];
        [_nearMapView removePointWithDataArray:array];
        
        if(error.code == -999)//取消请求
        {
            return ;
        }
        [MBProgressHUD showError:@"请求失败" toView:blockSelf.view];
    }];
     
     
}

#pragma mark - 请求列表信息
-(void)loadListData
{
     KBolckSelf;
    if(blankSpaceView)
    {
        [blankSpaceView removeFromSuperview];
        blankSpaceView = nil;
    }
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:self.view];
    hud.userInteractionEnabled = NO;
   
    NSString *str = [NSString stringWithFormat:@"%@?maptype=4&currentlatlng=%f,%f&pageindex=%d&mycoordinate=%f,%f&province=%@&city=%@",kGetMapPointList,KNear.chooseLat,KNear.chooseLng,loadNum,userLoc.location.coordinate.latitude,userLoc.location.coordinate.longitude,KNear.province,KNear.city];
    
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    requestTask = [RequestManager getWithURLString:str parameters:nil success:^(id responseObject) {
        [MBProgressHUD hideHudToView:blockSelf.view animated:YES];
        [blockSelf.dataTableView.mj_header endRefreshing];
        [blockSelf.dataTableView.mj_footer endRefreshing];
        NSLog(@"列表数据=%@",responseObject);
       
        if([[responseObject objectForKey:@"result"] intValue] == 0)
        {
            NSArray *tmpArray = [NearCompanyModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
            if(loadNum == 1)
            {
                if(tmpArray.count == 0)
                {
                    [blockSelf.companyArray removeAllObjects];
                    [blockSelf performSelector:@selector(showNothingView:) withObject:nil afterDelay:0.3];
                }
                else
                {
                    if (tmpArray.count <20)
                    {
                        [blockSelf.dataTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    [blockSelf.companyArray removeAllObjects];
                    blockSelf.companyArray = [NSMutableArray arrayWithArray:tmpArray];
                    
                }
            }
            else
            {
                NSArray *array = [responseObject objectForKey:@"data"];
                if(array.count == 0)
                {
                    [MBProgressHUD showHint:@"没有更多企业了" toView:blockSelf.view];
                    [blockSelf.dataTableView.mj_footer endRefreshingWithNoMoreData];
                }
                else
                {
                    if (tmpArray.count <20)
                    {
                        [blockSelf.dataTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    [blockSelf.companyArray addObjectsFromArray:[NearCompanyModel mj_objectArrayWithKeyValuesArray: array]];
                
                }
                
            }
            
            totalLabel.text = [NSString stringWithFormat:@"%@家企业",[responseObject objectForKey:@"total"]];
            [blockSelf.dataTableView reloadData];
            
            loadNum ++;
        }
        else
        {
            [blockSelf.companyArray removeAllObjects];
            [blockSelf.dataTableView reloadData];
            [blockSelf performSelector:@selector(showNothingView:) withObject:[responseObject objectForKey:@"msg"] afterDelay:0.3];
            
        }
        
        
    } failure:^(NSError *error) {
        [blockSelf.dataTableView.mj_header endRefreshing];
        [blockSelf.dataTableView.mj_footer endRefreshing];
        [MBProgressHUD hideHudToView:blockSelf.view animated:YES];
        
        if(error.code == -999)//取消请求
        {
            return ;
        }
        
        if(blockSelf.companyArray.count == 0)
        {
            [blockSelf performSelector:@selector(showNothingView:) withObject:@"连接失败,请检查你的网络设置" afterDelay:0.3];
        }
        else
        {
            [MBProgressHUD showHint:@"连接失败,请检查你的网络设置" toView:self.view];
        }
        
        
    }];

}
#pragma mark - 创建没数据页面
-(void)showNothingView:(NSString*)str
{
    if(blankSpaceView)
    {
        [blankSpaceView removeFromSuperview];
        blankSpaceView = nil;
    }
    
    
    // NSString * str = @"连接失败,请检查你的网络设置";
    if(str.length >0)
    {
        // str = @"连接失败,请检查你的网络设置";
        blankSpaceView = [[BlankSpaceView alloc] initWithFrame:KFrame(0, 60, KDeviceW, CGRectGetHeight(companyBackView.frame)-60) image:@"faild" text:str];
        blankSpaceView.delegate = self;
        //[companyBackView insertSubview:blankSpaceView belowSubview:dropView];
        [companyBackView addSubview:blankSpaceView];
    }
    
}
-(void)blankSpaceViewTag
{
    [self loadListData];
}
#pragma mark - 地图变化
-(void)mapViewChange:(CLLocationCoordinate2D) center
{
    if(isTalbeViewShow)//假如列表展示的话地图变化不请求数据
    {
        return;
    }
    
    KNear.isMapChange = YES;
    int maptype = KNear.maptype;
    KNear.mapCenterLat = center.latitude;
    KNear.mapCenterLng = center.longitude;
   
    if ([@(center.latitude) intValue] == 0) {
        
        [MBProgressHUD showError:@"定位失败" toView:self.view];
        return;
    }
    
    /**
     *将投影后的直角地理坐标转换为经纬度坐标
     *@param mapPoint 投影后的直角地理坐标
     *@return 转换后的经纬度坐标
     */
    BMKMapPoint pt =_nearMapView.dataMapView.visibleMapRect.origin;
    KNear.mapMinPoint = BMKCoordinateForMapPoint(pt);
    BMKMapPoint ptmax = (BMKMapPoint){pt.x+_nearMapView.dataMapView.visibleMapRect.size.width,pt.y+_nearMapView.dataMapView.visibleMapRect.size.height};
     KNear.mapMaxPoint = BMKCoordinateForMapPoint(ptmax);
    
    
    if ((int)_nearMapView.dataMapView.zoomLevel >= 3&&(int)_nearMapView.dataMapView.zoomLevel <= 7.8&&maptype!=1)
    {
        
        maptype = 1;
    }
    else if((int)_nearMapView.dataMapView.zoomLevel > 7.8&&(int)_nearMapView.dataMapView.zoomLevel <= 10.5&&maptype!=2)
    {
        maptype = 2;
    }
    else if((int)_nearMapView.dataMapView.zoomLevel >10.5&&(int)_nearMapView.dataMapView.zoomLevel <= 13&&maptype!=3)
    {
        maptype = 3;
    }
    
    else if ((int)_nearMapView.dataMapView.zoomLevel > 13&&(int)_nearMapView.dataMapView.zoomLevel <= 20)
    {
        
        maptype = 4;
    }
    
    KNear.maptype = maptype;
    [self getMapType:center];
}


#pragma mark -
-(void)getMapType :(CLLocationCoordinate2D) center
{
    if (!_Rsearch) {
        _Rsearch = [[BMKGeoCodeSearch alloc] init];
        _Rsearch.delegate = self;
    }
    BMKReverseGeoCodeOption *rever = [[BMKReverseGeoCodeOption alloc]init];
    rever.reverseGeoPoint = center;
    [_Rsearch reverseGeoCode:rever];
    
}

- (void)updateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //获取用户位置信息
    userLoc = userLocation;
    
    KNear.userLat = userLocation.location.coordinate.latitude;
    KNear.userLng = userLocation.location.coordinate.longitude;
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(getLocation:) object:userLocation];
    [self performSelector:@selector(getLocation:) withObject:userLocation afterDelay:0.5];
}

-(void)getLocation:(BMKUserLocation *)userLocation
{
    [self mapViewChange:userLocation.location.coordinate];
}

#pragma mark 获取到物理地址信息
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (result.addressDetail.province&&![result.addressDetail.province isEqualToString:@""]) {
        KNear.province = [result.addressDetail.province substringToIndex:2];
        KNear.city = result.addressDetail.city;
        KNear.district = result.addressDetail.district;
    }
   
    [_nearMapView.locService stopUserLocationService];
    mapzoom = _nearMapView.dataMapView.zoomLevel;
    mapCenter = _nearMapView.dataMapView.centerCoordinate;

    [MBProgressHUD hideHudToView:self.view animated:YES];
    [self loadMapData];
    if(pushList && self.getLocationBlock)
    {
        [MBProgressHUD hideHudToView:self.view animated:YES];
        self.getLocationBlock();
        pushList = NO;
        _nearMapView.hidden = NO;
    }
    
}


#pragma mark - 点击气泡
-(void)mapBubbleViewTapWithTag:(NSString *)tag andMapPoint:(BMKAnnotationView *)annotationView
{
    if (KNear.maptype<=3)
    {
        CGFloat big = 21;
        if (KNear.maptype == 1)
        {
            big = 9.0;
        }else if(KNear.maptype == 2)
        {
            big = 13;
        }else if (KNear.maptype == 3)
        {
            big= 15;
        }
        //地图放大倍数
        [_nearMapView.dataMapView setZoomLevel:big];
    }
    else if(KNear.maptype == 4)
    {
        if (![tag isEqualToString:@"0"] && ![tag isEqualToString:@"2"] && ![tag isEqualToString:@"1"])
        {
            KNear.chooseLat =  annotationView.annotation.coordinate.latitude;
            KNear.chooseLng =  annotationView.annotation.coordinate.longitude;
            loadNum = 1;
            
           [self setCompanyListStatus:YES];
            
            [self loadListData];
        }
    }
}

#pragma mark - 有多家企业时的气泡被点击
-(void)mapBubbleViewToSearchHowManeyWithMapPoint:(BMKAnnotationView *)point
{
    
    KNear.chooseLat =  point.annotation.coordinate.latitude;
    KNear.chooseLng =  point.annotation.coordinate.longitude;
    loadNum = 1;
    
    [self setCompanyListStatus:YES];
    
    [self loadListData];
}

#pragma mark - 四级时点击大头针方法
-(void)mapViewDidSelectAnnotationView:(BMKAnnotationView *)view
{
    KNear.chooseLat =  view.annotation.coordinate.latitude;
    KNear.chooseLng =  view.annotation.coordinate.longitude;

    loadNum = 1;
    
    [self setCompanyListStatus:YES];
    
    [self loadListData];
}


#pragma mark -tableView  delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.companyArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identity = @"mapList";
    NearCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:Identity];
    if (!cell) {
        cell = [[NearCompanyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identity];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.companyModel = [self.companyArray objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NearCompanyModel *model = [self.companyArray objectAtIndex:indexPath.row];
    
    NearDetailController*indo = [[NearDetailController alloc]init];
    // indo.companyModel = model;
    indo.companyName = model.name;
    indo.companyId = model.companyId;
    indo.mycoordinate = userLoc.location.coordinate;
    [self.navigationController pushViewController:indo animated:YES];
}

#pragma mark - 公司列表是否显示
-(void)setCompanyListStatus:(BOOL)isShowOrHide
{
   
    if(isShowOrHide)
    {
        isTalbeViewShow = YES;
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    
        [UIView animateWithDuration:0.4 animations:^{
            
            CGRect countLabelFrame = countLabel.frame;
            countLabelFrame.origin.y = - countLabel.height;
            countLabel.frame = countLabelFrame;
            
          //  toolView.frame = KFrame(0, -KChooseViewHight, KDeviceW, KChooseViewHight);
           // dropView.frame = CGRectMake(0, -44, KDeviceW, 44);
            self.nearMapView.frame = CGRectMake(0,0, KDeviceW, (KDeviceH)*0.41) ;
            self.nearMapView.dataMapView.frame = KFrame(0, 0, CGRectGetWidth(self.nearMapView.frame), CGRectGetHeight(self.nearMapView.frame));
            companyBackView.frame = KFrame(0, CGRectGetMaxY(self.nearMapView.frame), KDeviceW, KDeviceH *0.59);
            loaction.frame=CGRectMake(10,  CGRectGetMaxY(self.nearMapView.frame) - 70, 40, 40);
            
            
            
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = KNear.chooseLat;
            coordinate.longitude = KNear.chooseLng;
            
            if(_nearMapView.dataMapView.zoomLevel == 20)
            {
                [_nearMapView.dataMapView setCenterCoordinate:coordinate animated:YES];
            }
            else
            {
                _nearMapView.dataMapView.centerCoordinate = coordinate;
                _nearMapView.dataMapView.zoomLevel = 20;
            }
            
            
            
            
        } completion:^(BOOL finished) {
            
            
            
        }];
        
        
    }
    else
    {

        if(requestTask)
        {
            [requestTask cancel];
        }
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    
        
        [UIView animateWithDuration:0.4 animations:^{
            CGRect countLabelFrame = countLabel.frame;
            countLabelFrame.origin.y = KNavigationBarHeight + 20;
            countLabel.frame = countLabelFrame;
            //toolView.frame = KFrame(0, BUTTON_HEIGHT, KDeviceW, BUTTON_HEIGHT);
            //dropView.frame = CGRectMake(0, 0, KDeviceW, 44);
            self.nearMapView.frame = CGRectMake(0,KNavigationBarHeight, KDeviceW, KDeviceH - KNavigationBarHeight);
            self.nearMapView.dataMapView.frame = KFrame(0, 0, CGRectGetWidth(self.nearMapView.frame), CGRectGetHeight(self.nearMapView.frame));
            companyBackView.frame = KFrame(0, CGRectGetMaxY(self.nearMapView.frame), KDeviceW, KDeviceH *0.59);
            loaction.frame=CGRectMake(10, KDeviceH  - 44 -30, 40, 40);
            
            
            _nearMapView.dataMapView.centerCoordinate = mapCenter;
            
            _nearMapView.dataMapView.zoomLevel = mapzoom;
            
            
            [_nearMapView reductionAnnotationViewImage];
            
            [_nearMapView.dataMapView setCenterCoordinate:mapCenter animated:YES];
            
        } completion:^(BOOL finished) {
            
            isTalbeViewShow = NO;
            [self.companyArray removeAllObjects];
            [self.dataTableView reloadData];
            
        }];
        
    }
}


#pragma mark 定位到自己位置
-(void)locationAction
{
    KNear.maptype = 4;
    CLLocationCoordinate2D lc2d = CLLocationCoordinate2DMake(userLoc.location.coordinate.latitude,userLoc.location.coordinate.longitude);
    BMKCoordinateSpan  span ;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    BMKCoordinateRegion viewRegion ;
    viewRegion.center = lc2d;
    viewRegion.span = span;
    BMKCoordinateRegion adjustedRegion = [_nearMapView.dataMapView regionThatFits:viewRegion];
    [_nearMapView.dataMapView setRegion:adjustedRegion animated:YES];
}

//点击地图空白处
-(void)mapViewonClickedMapBlank
{
    [self setCompanyListStatus:NO];
}
#pragma mark - 创建地图
-(void )setMapView
{
    _nearMapView = [[NearMapView alloc]initWithFrame:CGRectMake(0,KNavigationBarHeight, KDeviceW, KDeviceH - KNavigationBarHeight)];
    _nearMapView.mapTapDelegate = self;
    _nearMapView.isNearMap = YES;
    _nearMapView.hidden = YES;
    [self.view addSubview:_nearMapView];
   // [MBProgressHUD showMessag:@"" toView:self.view];
    
    loaction = [UIButton buttonWithType:UIButtonTypeCustom];
    loaction.backgroundColor = [UIColor clearColor];
    loaction.hidden = NO;
    loaction.frame=CGRectMake(10, KDeviceH  - 44 -30, 40, 40);
    [loaction setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [loaction addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:loaction];
    [self.view addSubview:loaction];
    
    countLabel = [[CRGradientLabel alloc] initWithFrame:CGRectMake(30, KNavigationBarHeight + 20 , KDeviceW - 60, 30)];
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.backgroundColor = [UIColor clearColor];
    countLabel.font = KFont(13);
    countLabel.hidden = YES;
    countLabel.alpha = 0.8;
    countLabel.textColor = [UIColor blackColor];
    countLabel.layer.cornerRadius = 15;
    countLabel.clipsToBounds = YES;
    countLabel.gradientColors = @[KRGB(248, 112, 68), KRGB(253, 182, 66)];
    [self.view addSubview:countLabel];
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status||
        kCLAuthorizationStatusRestricted == status) {
        UIAlertView *defaultAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                   message:@"请开启定位:设置 > 隐私 > 定位服务 > 企信宝"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
        [defaultAlertView show];
        return;
    }
}

-(void)setCompanyListView
{
    UIView *view = [[UIView alloc]initWithFrame:KFrame(0, CGRectGetMaxY(self.nearMapView.frame), KDeviceW, KDeviceH *0.59)];
    companyBackView = view;
    view.backgroundColor = [UIColor whiteColor];;
    [self.view addSubview:view];
    
    UIView *labelBackView = [[UIView alloc]initWithFrame:KFrame(0, 0, KDeviceW, 30)];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)KRGB(248, 112, 68).CGColor, (__bridge id)KRGB(253, 182, 66).CGColor];
    gradientLayer.locations = @[@0.3, @0.7, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = KFrame(0, 0, labelBackView.width, labelBackView.height);
    [labelBackView.layer addSublayer:gradientLayer];
    [view addSubview:labelBackView];
    
    //多少家企业距离
    totalLabel = [[UILabel alloc]initWithFrame:KFrame(15, 0, KDeviceW-70, 30)];
    totalLabel.backgroundColor = [UIColor clearColor];
    totalLabel.font = KFont(12);
    totalLabel.textColor = [UIColor whiteColor];
    totalLabel.textAlignment = NSTextAlignmentLeft;
    totalLabel.text = @"0家企业  距离:0KM";
    [view addSubview:totalLabel];
    
    UIButton *dropBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dropBtn.frame = KFrame(KDeviceW - 60, 0, 30, CGRectGetHeight(totalLabel.frame));
    [dropBtn setImage:[UIImage imageNamed:@"白色下拉小三角"] forState:UIControlStateNormal];
    [dropBtn addTarget:self action:@selector(mapViewonClickedMapBlank) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:dropBtn];
    
    _dataTableView = [[UITableView alloc]initWithFrame:KFrame(0, CGRectGetMaxY(totalLabel.frame), KDeviceW, CGRectGetHeight(view.frame) - CGRectGetHeight(totalLabel.frame))  style:UITableViewStylePlain];
    _dataTableView.delegate = self;
    _dataTableView.dataSource = self;
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dataTableView.tableFooterView = [[UIView alloc] init];
    _dataTableView.estimatedRowHeight = 0;
    _dataTableView.estimatedSectionHeaderHeight = 0;
    _dataTableView.estimatedSectionFooterHeight = 0;
    _dataTableView.backgroundColor = [UIColor whiteColor];
    [view addSubview:_dataTableView];
    
    KBolckSelf;
    _dataTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        loadNum = 1;
        [blockSelf loadListData];
    }];
//    _dataTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf loadListData];
//    }];
    
    
}


//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [_nearMapView dataMapViewWillAppear];
//}
//
//
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [_nearMapView dataMapViewWillDisappear];
//}



- (void)dealloc
{
    [_nearMapView removeFromSuperview];
    _nearMapView = nil;
}





@end
