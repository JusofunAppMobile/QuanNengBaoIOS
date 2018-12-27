//
//  PenaltyController.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2018/1/8.
//  Copyright © 2018年 王志朋. All rights reserved.
//


// ============  行政处罚  ============
#import "BasicViewController.h"
#import "CommonWebViewController.h"
@interface PenaltyController : BasicViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSString *companyId;
@property(nonatomic,strong) NSString *companyName;

@end
