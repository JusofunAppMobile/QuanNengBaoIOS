//
//  ReportController.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2017/10/17.
//  Copyright © 2017年 王志朋. All rights reserved.
//


#import "BasicWebViewController.h"
#import "CustomAlert.h"
#import "VIPPrivilegeController.h"
@interface ReportController : BasicWebViewController


/**
 0:普通用户 1:vip
 */
@property(nonatomic,copy)    NSString *vipType;

@property (nonatomic,strong) NSString *companyId;
@property (nonatomic,strong) NSString *companyName;

@end
