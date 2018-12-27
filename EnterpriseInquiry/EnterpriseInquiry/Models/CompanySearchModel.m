//
//  CompanySearchModel.m
//  EnterpriseInquiry
//
//  Created by 方首滔 on 16/8/15.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "CompanySearchModel.h"

@implementation CompanySearchModel
+ (NSDictionary *)objectClassInArray
{
    return@{
            @"businesslist": CompanyInfoModel.class,
            };
}
@end
