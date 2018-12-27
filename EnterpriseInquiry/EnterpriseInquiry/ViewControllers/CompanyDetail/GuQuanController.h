//
//  GuQuanController.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2018/1/8.
//  Copyright © 2018年 王志朋. All rights reserved.
//

// ============  股权出质  ============
#import "BasicViewController.h"
#import "CommonWebViewController.h"
#import "StockCell.h"
@interface GuQuanController : BasicViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSString *companyId;
@property(nonatomic,strong) NSString *companyName;
@end
