//
//  CompanyInfo.h
//  EnterpriseInquiry
//
//  Created by 方首滔 on 16/8/15.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyInfoModel : NSObject
@property(nonatomic,copy)NSString *FollowSort;
@property(nonatomic,copy)NSString *companyid;//公司id
@property(nonatomic,copy)NSString *companyname;//公司名称
@property(nonatomic,copy)NSString *companylightname;//带有font标签的企业名称
@property(nonatomic,copy)NSString *companystate;//企业状态
@property(nonatomic,copy)NSString *funds;//注册资金
@property(nonatomic,copy)NSString *industry;//互联网”,//行业
@property(nonatomic,copy)NSString *location;//公司所在地区
@property(nonatomic,copy)NSString *related;//关联词

@property(nonatomic,copy)NSString *socialcredit;//信用代码
@property(nonatomic,copy)NSString *establish;//成立日期
@property(nonatomic,copy)NSString *legal;//法人
@property(nonatomic,copy)NSString *relatednofont;
@end
