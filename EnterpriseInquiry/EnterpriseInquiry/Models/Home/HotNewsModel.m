//
//  HotNewsModel.m
//  EnterpriseInquiry
//
//  Created by 方首滔 on 16/9/23.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "HotNewsModel.h"

@implementation HotNewsModel
+ (NSDictionary *)objectClassInArray
{
    return@{
            @"hotnewslist":NewsModel.class
            };
}
@end
