//
//  NearDetailController.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2018/1/2.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "BasicViewController.h"
#import "BlankSpaceView.h"
#import "ContentView.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import "MapPoint.h"
#import "NearMapView.h"
#import "CompanyDetailController.h"
#import "NearSearchCondition.h"
#define changeHight 44 //多高的时候发生变色
#define KShowAllY  (KIsIphoneX? 44:24) //展示全屏的的y
//#define originalHight 170 //一进页面详情的高度
//#define downHight 150 //自动下降时的高度
//#define downShowHight 170 //最下面仅展示公司信息到资产营收的高度


@interface NearDetailController : BasicViewController<BMKGeoCodeSearchDelegate,MapTapDelegate,UIScrollViewDelegate,contentViewDelegate,MapTapDelegate,BlankSpaceViewDelegate>


@property(nonatomic,strong) NearMapView *detailMapView;

@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) UIColor *navigationBarColor;
@property (nonatomic, strong) UILabel *navigationBarTitleLabel;
@property (nonatomic, assign) BOOL   isHiddenView;
//@property (nonatomic, strong) UIView *detailBackView;

@property(nonatomic,strong)NSString *companyId;

@property(nonatomic,strong)NSString *companyName;

@property(nonatomic,assign)CLLocationCoordinate2D mycoordinate;

/**
 *  收藏id
 */
@property (nonatomic,strong) NSString *favoriteId;


@end
