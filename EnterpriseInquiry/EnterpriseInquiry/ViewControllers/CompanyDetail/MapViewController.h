//
//  MapViewController.h
//  EnterpriseInquiry
//
//  Created by clj on 15/11/9.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "BasicViewController.h"
#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import "CompanyDetailModel.h"
@interface MapViewController : BasicViewController

@property (nonatomic,strong) CompanyDetailModel *companyDetailModel;

-(BMKMapView *)createMapViewWithFrame:(CGRect)frame withcoordinate2D:(CLLocationCoordinate2D)coor2D;

@end
