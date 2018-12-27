//
//  JobController.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/8.
//  Copyright © 2017年 王志朋. All rights reserved.
//


//    招聘 
#import "BasicViewController.h"
#import "JobCell.h"
#import "CommonWebViewController.h"

@interface JobController : BasicViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSString *companyId;
@property(nonatomic,strong) NSString *companyName;

@end
