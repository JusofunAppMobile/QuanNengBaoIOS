//
//  CompanySearchVC.h
//  EnterpriseInquiry
//
//  Created by LEZ on 16/8/10.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "BasicViewController.h"

@protocol CompanySearchDelegate <NSObject>

-(void)selectCompanyWithInfo:(NSDictionary*)dict;

@end

@interface CompanySearchVC : BasicViewController

@property (nonatomic,strong)NSString    *tempCompany;

@property (nonatomic,assign)id<CompanySearchDelegate>delegate;

@end
