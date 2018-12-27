//
//  BidController.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/7.
//  Copyright © 2017年 王志朋. All rights reserved.
//


// 中标

#import "BasicViewController.h"
#import "BidCell.h"
#import "CommonWebViewController.h"


@interface BidController : BasicViewController<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)NSString *companyId;
@property(nonatomic,strong) NSString *companyName;

@end
