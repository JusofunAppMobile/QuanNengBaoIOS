//
//  LegalPersonChangeController.h
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/11/1.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
#import "CompanyDetailController.h"
@class RecentChangeModel;
@interface LegalPersonChangeController : BasicViewController
//近期变更类型
@property (nonatomic ,strong) RecentChangeModel *changeModel;

@end
