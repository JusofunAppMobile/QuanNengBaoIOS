//
//  NearMapView.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2017/12/22.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "MapPoint.h"
#import <BaiduMapAPI_Map/BMKLocationViewDisplayParam.h>
#import "PintAnnotiationView.h"
#import "PaopaoView.h"
@protocol MapTapDelegate <NSObject>
@optional
/**
 *  点击地图上气泡方法
 *
 *  @param tag 气泡的tag
 */
-(void)mapBubbleViewTapWithTag:(NSString *)tag andMapPoint:(BMKAnnotationView *)annotationView;
-(void)mapBubbleViewToSearchHowManeyWithMapPoint:(BMKAnnotationView *)annotationView;
/**
 *当选中一个annotation views时，调用此接口
 *
 *@param views 选中的annotation views
 */

-(void)mapViewDidSelectAnnotationView:(BMKAnnotationView *)view;

/**
 *  地图区域发生变化时调用
 *
 *  @param center 地图中心点坐标
 */
-(void)mapViewChange:(CLLocationCoordinate2D) center;

/**
 *  定位自己位置
 *
 *  @param userLocation 自己位置坐标
 */
- (void)updateBMKUserLocation:(BMKUserLocation *)userLocation;

/**
 *  点击地图空白处
 */
-(void)mapViewonClickedMapBlank;


@end




@interface NearMapView : UIView<BMKMapViewDelegate,BMKLocationServiceDelegate>


@property(nonatomic,assign)id <MapTapDelegate> mapTapDelegate;
@property(nonatomic,strong)BMKMapView * dataMapView;
@property(nonatomic,strong)BMKLocationService * locService;
@property(nonatomic,strong)BMKUserLocation * userLoc;//自己的位置
@property(nonatomic,strong)BMKAnnotationView * selectAnnotainView;//选择的大头针


-(instancetype)initWithFrame:(CGRect)frame withIsLocation:(BOOL)isLocation;
/**
 *  是否为附近地图
 */
@property(nonatomic,assign) BOOL isNearMap;


/**
 *  当在附近地图时用到此选项,为yes,不显示第二级label
 */
@property(nonatomic,assign) BOOL isFiveType;

/**
 * 标记地图展开范围大小
 */
@property(nonatomic,assign)float zoom;

//公司简介
@property(nonatomic,assign)BOOL isMapIntroduction;


/**
 *  设置地图上的气泡
 *
 *  @param array 气泡的数据array
 */
-(void)setPointWithDataArray:(NSMutableArray *)array;
-(void)removePointWithDataArray:(NSArray *)array;
-(void)setPointWithDataArray:(NSMutableArray *)array andMapType:(NSInteger)maptype;
-(void)setPointWithDictary:(NSMutableArray *)array;


/**
 *  设置地图的中心点
 *
 *  @param centerCoordinate 中心点坐标
 */

-(void)setMapCenter:(CLLocationCoordinate2D)centerCoordinate;

/**
 *  还原选中的图标
 *
 */
-(void)reductionAnnotationViewImage;


/**
 *  移除地图上次的大头针
 */

-(void)removeMapAnnotations;

/**
 *  页面进来时必须调用否则影响map释放
 */
-(void)dataMapViewWillAppear;

/**
 *  页面消失时必须调用否则影响map释放
 */
-(void)dataMapViewWillDisappear;






@end
