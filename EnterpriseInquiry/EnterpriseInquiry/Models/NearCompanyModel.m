//
//  NearCompanyModel.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2018/1/2.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "NearCompanyModel.h"

@implementation NearCompanyModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"companyId" : @"id",
             
             };
}

@end
