//
//  NearCompanyModel.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2018/1/2.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NearCompanyModel : NSObject
/**
 *  公司id
 */
@property (nonatomic,strong) NSString *companyId;
/**
 *  地址
 */
@property (nonatomic,strong) NSString *area;

/**
 *  公司名字
 */
@property (nonatomic,strong) NSString *name;
/**
 *  公司法人
 */
@property(nonatomic, strong)NSString *legalPerson;
/**
 * 注册时间
 */
@property (nonatomic,strong) NSString *registerDate;
/**
 *  状态
 */
@property (nonatomic,strong) NSString *registerStatus;
/**
 *  坐标
 */
@property (nonatomic,strong) NSString *mapLat;
/**
 *  坐标
 */
@property (nonatomic,strong) NSString *mapLng;


/**
 *  注册资金
 */
@property (nonatomic,strong) NSString *money;

/**
 *  距离
 */
@property (nonatomic,strong) NSString *distance;

@end
