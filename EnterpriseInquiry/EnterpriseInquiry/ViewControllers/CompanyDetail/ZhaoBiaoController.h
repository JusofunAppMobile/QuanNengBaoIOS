//
//  ZhaoBiaoController.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2018/1/10.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "BasicViewController.h"
#import "CommonWebViewController.h"
#import "ZhaoBiaoCell.h"
@interface ZhaoBiaoController : BasicViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSString *companyId;
@property(nonatomic,strong) NSString *companyName;
@end
