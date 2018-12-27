//
//  CompanyModel.h
//  EnterpriseInquiry
//
//  Created by clj on 16/8/11.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyModel : NSObject
@property (nonatomic,strong) NSString *companyname;//公司名
@property (nonatomic,strong) NSString *companyid;//
@property (nonatomic,strong) NSString *industry;//行业
@property (nonatomic,strong) NSString *location;//公司所在地
@property (nonatomic,strong) NSString *funds;//注册资金
@property (nonatomic,strong) NSString *attentioncount;//关注数
@property (nonatomic,strong) NSString *PublishTime;//发布时间
@property (nonatomic,strong) NSString *isFav;//是否收藏
@property (nonatomic,strong) NSString *legalPerson;//是否收藏



@end
