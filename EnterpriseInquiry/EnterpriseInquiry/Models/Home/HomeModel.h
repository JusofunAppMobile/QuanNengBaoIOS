//
//  HomeModel.h
//  EnterpriseInquiry
//
//  Created by clj on 16/8/11.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DishonestyModel.h"
#import "AdModel.h"
#import "CompanyModel.h"
#import "NewsModel.h"
#import "NewAddModel.h"

//首页数据模型
@interface HomeModel : NSObject

@property (nonatomic,strong ) NSArray         *adlist;//广告数组
@property (nonatomic,strong ) NSArray         *hotnewslist;//热门资讯
@property (nonatomic,strong ) NSArray         *hotlist;//热门公司
@property (nonatomic ,strong) NSArray         *newaddlist;//新增企业
@property (nonatomic,strong ) DishonestyModel *dishonesty;//失信信息

@end
