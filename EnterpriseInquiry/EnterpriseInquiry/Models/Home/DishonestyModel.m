//
//  DishonestyModel.m
//  EnterpriseInquiry
//
//  Created by clj on 16/8/11.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "DishonestyModel.h"

@implementation DishonestyModel
+ (NSDictionary *)objectClassInArray
{
    return@{
            @"dishonestylist" :DishonestyMonthModel.class,
            };
}

@end
