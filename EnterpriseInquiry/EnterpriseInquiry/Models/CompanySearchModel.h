//
//  CompanySearchModel.h
//  EnterpriseInquiry
//
//  Created by 方首滔 on 16/8/15.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CompanyInfoModel.h"
@interface CompanySearchModel : NSObject
@property (nonatomic,strong) NSMutableArray *businesslist;
@property (nonatomic,copy) NSString *msg;
@property (nonatomic,copy) NSString *result;

@end
