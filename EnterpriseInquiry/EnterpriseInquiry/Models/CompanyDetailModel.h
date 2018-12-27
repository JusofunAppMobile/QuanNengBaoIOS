//
//  CompanyDetailModel.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 16/8/12.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyDetailModel : NSObject

//公司名
@property (nonatomic,copy) NSString *companyname;

@property (nonatomic,copy) NSString *companyid;

//评级
@property (nonatomic,copy) NSString *ratings;

//税号
@property (nonatomic,copy) NSString *taxid;

//注册号
@property (nonatomic,copy) NSString *registernumber;


@property (nonatomic,copy) NSString *address;

//经度
@property (nonatomic,copy) NSString *longitude;

//纬度
@property (nonatomic,copy) NSString *latitude;

//企业状态
@property (nonatomic,copy) NSString *companystate;

//关注数
@property (nonatomic,copy) NSString *attentioncount;

//更新状态
@property (nonatomic,copy) NSString *updatestate;

//是否已关注该企业
@property (nonatomic,copy) NSString *isattention;

//九宫格详细内容
@property (nonatomic,strong) NSArray *subclassMenu;

//联系方式
@property (nonatomic,strong) NSArray *contactinformation;

//企业法人
@property (nonatomic,copy) NSString *legal;


@property (nonatomic,copy) NSString *url;

//分享的url
@property (nonatomic,copy) NSString *shareurl;

//首页展示时的图片
@property (nonatomic,copy) NSString *image;

//浏览数
@property (nonatomic,copy) NSString *browsecount;

//企业资质
@property (nonatomic,copy) NSString *companynature;

//法人
@property (nonatomic,copy) NSString *corporate;

//注册资金
@property (nonatomic,copy) NSString *registercapital;

//企业规模
@property (nonatomic,copy) NSString *companysize;

//创建日期
@property (nonatomic,copy) NSString *cratedate;

//行业
@property (nonatomic,copy) NSString *industry;

//0.正在更新或者未更新 1.已更新成功 ”
@property (nonatomic,strong) NSString *currentstate;

//联系方式
@property (nonatomic,strong) NSArray *companyphonelist;

//网址
@property (nonatomic,strong) NSArray *neturl;


/**
 是否有数据 1表示没有企业数据，0 表示 正常
 */
@property (nonatomic,copy) NSString *hasCompanyData;

//登记状态
@property (nonatomic,copy) NSString *states;

@property (nonatomic,copy) NSString *msg;

@property (nonatomic,copy) NSString *result;


@end
