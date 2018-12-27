//
//  MapPoint.h
//  jusfounData
//
//  Created by jusfoun on 15/7/23.
//  Copyright (c) 2015年 jusfoun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NearCompanyModel.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "Verification.h"


@interface MapPoint : BMKPointAnnotation

@property(nonatomic,strong) NSString *tag;
@property(nonatomic,assign) NSInteger mapType;
@property(nonatomic,strong) NSString *companyName ;

-(instancetype)initWithModel:(NearCompanyModel *)model;

//当地图级别放大为1，2，3时调用
- (instancetype)initWithDictary:(NSMutableDictionary *)dic andMapType:(NSInteger)mapType;

//当地图放大级别为4级时才调用
- (instancetype)initWithDictary:(NSMutableDictionary *)dic;

@end
