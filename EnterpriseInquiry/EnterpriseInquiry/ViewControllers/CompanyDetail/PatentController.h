//
//  PatentController.h
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/9/6.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "BasicViewController.h"
#import "PatentCell.h"
#import "CommonWebViewController.h"
@interface PatentController : BasicViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSString *companyId;
@property(nonatomic,strong) NSString *companyName;

@end
