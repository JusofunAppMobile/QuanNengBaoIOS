//
//  NearMapController.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2017/12/21.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "BasicViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import "NearMapView.h"
#import "NearSearchCondition.h"
#import "BlankSpaceView.h"
#import "NearCompanyCell.h"
#import "NearDetailController.h"
#import "CRGradientLabel.h"
#define KChooseViewHight 44

typedef void(^GetLocationBlock)();

@interface NearMapController : BasicViewController<BMKGeoCodeSearchDelegate,MapTapDelegate,UITableViewDelegate,UITableViewDataSource,BlankSpaceViewDelegate>

@property(nonatomic,copy)GetLocationBlock getLocationBlock;


@property(nonatomic,strong) NearMapView *nearMapView;
@property (nonatomic, strong) BMKGeoCodeSearch *Rsearch; // 地理编码


@property(nonatomic,strong)NSMutableArray *mapArray;


@property(nonatomic,strong)UITableView *dataTableView;

@property (nonatomic,strong) NSMutableArray *companyArray;



@end
