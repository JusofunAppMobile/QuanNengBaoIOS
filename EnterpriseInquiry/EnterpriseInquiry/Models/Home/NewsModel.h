//
//  NewsModel.h
//  EnterpriseInquiry
//
//  Created by clj on 16/9/22.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
@property (nonatomic,copy) NSString *newsid;
@property (nonatomic,copy) NSString *newsimgurl;//资讯图片连接
@property (nonatomic,copy) NSString *newstitle;//
@property (nonatomic,copy) NSString *newreadcount;//资讯阅读
@property (nonatomic,copy) NSString *newdetailurl;//资讯详情对应的html连接
@property (nonatomic,copy) NSString *releasedate;

@end
