//
//  NewAddModel.h
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/9/5.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewAddModel : NSObject

@property (nonatomic ,copy) NSString *companyname;

@property (nonatomic ,copy) NSString *companyid;

@property (nonatomic ,copy) NSString *industry;

@property (nonatomic ,copy) NSString *location;

@property (nonatomic ,copy) NSString *funds;//注册资金

@property (nonatomic ,copy) NSString *attentioncount;//关注数

@property (nonatomic ,copy) NSString *companystate;//公司状态

@property (nonatomic ,copy) NSString *socialcredit;//社会信用代码

@property (nonatomic ,copy) NSString *legalPerson;//法定代言人
@property (nonatomic ,copy) NSString *PublishTime;//成立日期


@end
