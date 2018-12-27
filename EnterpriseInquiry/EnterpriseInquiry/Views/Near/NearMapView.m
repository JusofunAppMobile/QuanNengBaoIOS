//
//  NearMapView.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2017/12/22.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "NearMapView.h"

@interface NearMapView ()
{
    NSMutableArray *pointArray;//
    
    NSString *selectImageName;
    
    PintAnnotiationView *selectAnnotation;
}

@end

@implementation NearMapView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        _dataMapView = [[BMKMapView alloc]initWithFrame:KFrame(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        _dataMapView.delegate = self;
        _dataMapView.zoomLevel=18;
        _dataMapView.minZoomLevel=5;
        [self addSubview:_dataMapView];
        _dataMapView.showsUserLocation = YES;
        _dataMapView.userTrackingMode = BMKUserTrackingModeFollow;
        pointArray = [NSMutableArray arrayWithCapacity:1];
        
        
        
        BMKLocationViewDisplayParam *DisplayParam = [[BMKLocationViewDisplayParam alloc]init];
        DisplayParam.locationViewOffsetX=1;
        DisplayParam.locationViewOffsetY=1;
        DisplayParam.isAccuracyCircleShow = NO;
        NSString *imageName = @"icon_center_point";
        DisplayParam.locationViewImgName = imageName;
        [_dataMapView updateLocationViewWithParam:DisplayParam];
        
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        _locService.distanceFilter = 100;
        //启动LocationService
        [_locService startUserLocationService];
        
        
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame withIsLocation:(BOOL)isLocation
{
    self = [super initWithFrame:frame];
    if(self)
    {
       
        //修改地图背景色，此界面关闭，在需要界面打开
        NSString* path = [[NSBundle mainBundle] pathForResource:@"custom_config_bgViewColor" ofType:@""];
        [BMKMapView customMapStyle:path];
        [BMKMapView enableCustomMapStyle:NO];
        
        _dataMapView = [[BMKMapView alloc]initWithFrame:KFrame(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        _dataMapView.delegate = self;
        _dataMapView.zoomLevel=18;
        _dataMapView.minZoomLevel=5;
        [self addSubview:_dataMapView];
        _dataMapView.showsUserLocation = YES;
        _dataMapView.userTrackingMode = BMKUserTrackingModeFollow;
        pointArray = [NSMutableArray arrayWithCapacity:1];
        
        if(isLocation)
        {
            
            BMKLocationViewDisplayParam *DisplayParam = [[BMKLocationViewDisplayParam alloc]init];
            DisplayParam.locationViewOffsetX=1;
            DisplayParam.locationViewOffsetY=1;
            DisplayParam.isAccuracyCircleShow = NO;
            NSString *imageName = @"icon_center_point";
            DisplayParam.locationViewImgName = imageName;
            [_dataMapView updateLocationViewWithParam:DisplayParam];
            
            _locService = [[BMKLocationService alloc]init];
            _locService.delegate = self;
            //启动LocationService
            [_locService startUserLocationService];
        }
        
        
        
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _dataMapView.frame = KFrame(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
}

-(void)setZoom:(float)zoom
{
    _dataMapView.zoomLevel = zoom;
    // 36.0093847,104.2119021
    
}

-(void)removeMapAnnotations
{
    [_dataMapView removeAnnotations:pointArray];
}


-(void)setPointWithDataArray:(NSMutableArray *)array
{
    [pointArray removeAllObjects];
    for(NearCompanyModel *model in array)
    {
        MapPoint *point = [[MapPoint alloc]initWithModel:model];
        if(point.coordinate.latitude != 0 && point.coordinate.longitude != 0)
        {
            [pointArray addObject:point];
        }
        
    }
    [_dataMapView addAnnotations:pointArray];
}


//不是第四级地图显示时调用
-(void)setPointWithDataArray:(NSMutableArray *)array andMapType:(NSInteger)maptype
{
    [pointArray removeAllObjects];
    for(NSMutableDictionary *dic in array)
    {
        NSLog(@"%@",dic);
        
        MapPoint *point = [[MapPoint alloc]initWithDictary:dic andMapType:maptype];
        if(point.coordinate.latitude != 0 && point.coordinate.longitude != 0)
        {
            [pointArray addObject:point];
        }
        
    }
    [_dataMapView addAnnotations:pointArray];
}

//第四级菜单调用
-(void)setPointWithDictary:(NSMutableArray *)array
{
    [pointArray removeAllObjects];
    for(NSMutableDictionary *dic in array)
    {
        MapPoint *point = [[MapPoint alloc]initWithDictary:dic];
        if(point.coordinate.latitude != 0 && point.coordinate.longitude != 0)
        {
            [pointArray addObject:point];
        }
    }
    [_dataMapView addAnnotations:pointArray];
}


-(void)removePointWithDataArray:(NSArray *)array
{
    [_dataMapView removeAnnotations:array];
}


-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"renameMark";
    PintAnnotiationView *annotationView = (PintAnnotiationView *)[_dataMapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (annotationView == nil) {//会存在复用问题
        annotationView = [[PintAnnotiationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 从天上掉下效果
        annotationView.animatesDrop = NO;
        // 设置可拖拽
        annotationView.draggable = NO;
    }
    annotationView.frame = CGRectMake(annotationView.frame.origin.x, annotationView.frame.origin.y, 30, 30);
    MapPoint *point = (MapPoint *)annotation;
    annotationView.canShowCallout = YES;
    annotationView.companyId = point.tag;
    //annotationView.tag = [point.tag integerValue];
    NSString *pointTag = [NSString stringWithFormat:@"%@",annotationView.companyId];
    if ([pointTag isEqualToString:@"1"] || [pointTag isEqualToString:@"2"])
    {
        //多个企业
        //annotationView.pinColor = BMKPinAnnotationColorPurple;
        annotationView.image = [UIImage imageNamed:@"pinlargest"];
    }
    else
    {
        //单个企业
        // annotationView.pinColor = BMKPinAnnotationColorGreen;
        annotationView.image = [UIImage imageNamed:@"pinlargest"];
    }
    
    if(self.isNearMap)
    {
        if(self.isFiveType)
            
        {
            annotationView.canShowCallout = NO;
            //annotationView.image = [UIImage imageNamed:@"pinlargest"];
        }
        else
        {
            annotationView.image = [UIImage imageNamed:@"pinlargest"];
        }
    }
    else
    {
        annotationView.image = [UIImage imageNamed:@"pinlargest"];
    }
    
    if(self.isMapIntroduction)
    {
        annotationView.image = [UIImage imageNamed:@"pinlargest"];
        annotationView.canShowCallout = NO;
    }
    
    annotationView.paopaoView = [[BMKActionPaopaoView alloc]initWithCustomView:[[PaopaoView alloc]initWithTitle:point.title]];;
    
    
    
    
    return annotationView;
}
/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 选中的annotation views
 */

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    PintAnnotiationView *view1 = (PintAnnotiationView *)view;
    
    
    NSString *str = view.annotation.title;
    if([str isEqualToString:@"我的位置"])
    {
        return;
    }
    if(self.isFiveType)
    {
        if (_mapTapDelegate && [_mapTapDelegate respondsToSelector:@selector(mapViewDidSelectAnnotationView:)]) {
            
            
            
            [self reductionAnnotationViewImage];
            
            selectAnnotation = view1;
            
            NSString *pointTag = [NSString stringWithFormat:@"%@",view1.companyId];
            if ([pointTag isEqualToString:@"1"] || [pointTag isEqualToString:@"2"])
            {
                //多个企业
                
                selectImageName = @"pinlargest";
            }
            else
            {
                //单个企业
                
                selectImageName = @"pinlargest";
            }
            
            
            _selectAnnotainView = view;
            
            view.image = [UIImage imageNamed:@"pinlargest"];
            
            [self.mapTapDelegate mapViewDidSelectAnnotationView:view];
            view.selected = NO;
        }
        
    }
}

/**
 *点中底图空白处会回调此接口
 *@param mapview 地图View
 *@param coordinate 空白处坐标点的经纬度
 */

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    if (_mapTapDelegate && [_mapTapDelegate respondsToSelector:@selector(mapViewonClickedMapBlank)]) {
        
        // [self.mapTapDelegate mapViewonClickedMapBlank];
    }
    
}


// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    PintAnnotiationView *view1 = (PintAnnotiationView *)view;
    NSString *str = view.annotation.title;
    if([str isEqualToString:@"我的位置"])
    {
        return;
    }
    
    if([view1.companyId isEqualToString:@"1"])
    {
        if (_mapTapDelegate && [_mapTapDelegate respondsToSelector:@selector(mapBubbleViewToSearchHowManeyWithMapPoint:)]) {
            [self.mapTapDelegate mapBubbleViewToSearchHowManeyWithMapPoint:view];
        }
    }
    else
    {
        if(_mapTapDelegate && [_mapTapDelegate respondsToSelector:@selector(mapBubbleViewTapWithTag:andMapPoint:)])
        {
            if([view1.companyId isEqualToString:@"2"])
            {
                mapView.centerCoordinate = view.annotation.coordinate;
                //               NSLog(@"%lf%lf",view.annotation.coordinate.latitude,view.annotation.coordinate.longitude);
            }
            [self.mapTapDelegate mapBubbleViewTapWithTag:view1.companyId andMapPoint:view];
        }
    }
}


/**
 *地图区域改变完成后会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CLLocationCoordinate2D centerCoordinate = _dataMapView.centerCoordinate;
    // [mapView setCenterCoordinate:centerCoordinate animated:YES];
    // mapView.centerCoordinate = centerCoordinate;
    if(_mapTapDelegate && [_mapTapDelegate respondsToSelector:@selector(mapViewChange:)])
    {
        [_mapTapDelegate mapViewChange:centerCoordinate];
    }
}


/**
 *  还原选中的图标
 *
 */
-(void)reductionAnnotationViewImage
{
    selectAnnotation.image = [UIImage imageNamed:selectImageName];
}

/*
 *
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 *
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.userLoc = userLocation;
    [_dataMapView updateLocationData:userLocation];
    if(_mapTapDelegate && [_mapTapDelegate respondsToSelector:@selector(updateBMKUserLocation:)])
    {
        [_mapTapDelegate updateBMKUserLocation:userLocation];
    }
}


/**
 *
 *定位失败后，会调用此函数
 *@param error 错误号
 *
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"%@",error.debugDescription);
}

/**
 *  设置地图的中心点
 *
 *  @param centerCoordinate 中心点坐标
 */

-(void)setMapCenter:(CLLocationCoordinate2D)centerCoordinate
{
    _dataMapView.centerCoordinate = centerCoordinate;
    
    //_dataMapView.centerCoordinate = view.annotation.coordinate;
}

-(void)dataMapViewWillAppear
{
    [_dataMapView viewWillAppear];
    _dataMapView.delegate = self;
    _locService.delegate = self;
}


-(void)dataMapViewWillDisappear
{
    
    [_dataMapView viewWillDisappear];
    _dataMapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

@end
