//
//  HomeModel.m
//  EnterpriseInquiry
//
//  Created by clj on 16/8/11.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel
+ (NSDictionary *)objectClassInArray
{
    return@{
            @"adlist" :AdModel.class,
            @"hotlist" :CompanyModel.class,
            @"hotnewslist":NewsModel.class,
            @"newaddlist":NewAddModel.class
            };
}
@end
