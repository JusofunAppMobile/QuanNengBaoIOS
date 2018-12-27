//
//  CompanyDetailController.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 16/8/10.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "BasicViewController.h"
#import "DetailView.h"
#import "UINavigationBar+Extention.h"
#import "SearchResultController.h"
#import "CommonWebViewController.h"
#import "MapViewController.h"
#import "RequestManager.h"
#import "CompanyDetailModel.h"
#import "ShareView.h"
#import "LoginController.h"
#import "MyAlertView.h"
#import "BackgroundController.h"
#import "OperatingController.h"
#import "ReportController.h"
#import "UserCenterController.h"
@interface CompanyDetailController : BasicViewController<MyAlertViewDelegate,DetailViewDelegate>

@property (nonatomic,strong) NSString *companyId;
@property (nonatomic,strong) NSString *companyName;

@end
