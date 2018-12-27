//
//  NewHomeViewController.h
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/1/4.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "BasicViewController.h"
#import "SearchButton.h"
#import "CompanyDetailController.h"
#import "SearchController.h"
#import "HomeHeaderView.h"


@interface NewHomeViewController : BasicViewController
@property (nonatomic ,strong) UITableView *tableview;
@property (nonatomic ,strong) SearchButton *naviSearchView;
@property (nonatomic ,strong) HomeHeaderView *headerView;

@end

