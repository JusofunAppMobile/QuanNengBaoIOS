//
//  HotCompanyListController.h
//  EnterpriseInquiry
//
//  Created by clj on 16/8/12.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "BasicViewController.h"
#import "CompanyModel.h"

//热门公司列表
@interface HotCompanyListController : BasicViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@end
