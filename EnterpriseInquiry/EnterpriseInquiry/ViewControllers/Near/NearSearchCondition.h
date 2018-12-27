//
//  NearSearchCondition.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2017/12/22.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


#define  KNear  [NearSearchCondition sharedInstance]

@interface NearSearchCondition : NSObject
SingletonH(Instance)

/** 地图放大界别 */
@property(nonatomic,assign)int maptype;

@property(nonatomic,copy)NSString *totalmoney;//营收规模

@property(nonatomic,copy)NSString *legalname;// 创始人

@property(nonatomic,assign)CLLocationCoordinate2D mapMinPoint;

@property(nonatomic,assign)CLLocationCoordinate2D mapMaxPoint;

/** 城市 */
@property(nonatomic,copy)NSString *city;

/** 省份名称 */
@property(nonatomic,copy)NSString *province;

/** 区县名称 */
@property(nonatomic,copy)NSString *district;


/** 选择点的纬度 */
@property(nonatomic,assign)double chooseLat;

/** 选择点的经度 */
@property(nonatomic,assign)double chooseLng;


/** 地图中心点纬度 */
@property(nonatomic,assign)double mapCenterLat;

/** 地图中心点经度 */
@property(nonatomic,assign)double mapCenterLng;

/** 自己的坐标 */
@property(nonatomic,assign)double userLat;

/** 自己的坐标 */
@property(nonatomic,assign)double userLng;

/** 自己的坐标 */
@property(nonatomic,assign) BOOL isMapChange;

/** 关键词 */
@property(nonatomic,copy)NSString *searchKey;

/** 收入数组 */
@property(nonatomic,strong)NSMutableArray *inComeArray;

/** 拼接收入字符 */
@property(nonatomic,copy)NSString *inComeString;


/** 行业数组 */
@property(nonatomic,strong)NSMutableArray *industryArray;

/** 拼接行业字符 */
@property(nonatomic,copy)NSString *industryString;


/** 资产规模数组 */
@property(nonatomic,strong)NSMutableArray *totalMoneyArray;

/** 拼接资产规模字符 */
@property(nonatomic,copy)NSString *totalMoneyString;




//保存筛选的数据(不包含失信的)
@property(nonatomic,strong)NSMutableArray *chooseArray;

//失信筛选的数据
@property(nonatomic,strong)NSMutableArray *sxChooseArray;


@end
