//
//  SearchCell.h
//  EnterpriseInquiry
//
//  Created by 方首滔 on 16/8/10.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyInfoModel.h"
@interface SearchCell : UITableViewCell
@property(nonatomic,strong)UILabel *CompanyName;
@property(nonatomic,strong)UILabel *CompanyInfo;
@property(nonatomic,strong)UIButton *CompanyStatus;
@property(nonatomic,strong)UILabel *CompanyStatusLabel;


/**
 统一社会信用代码
 */
@property(nonatomic,strong)UILabel *creditLabel;

@property(nonatomic,strong)CompanyInfoModel *CompanyInfoModel;


/**
 是否是搜索公司名字
 */
@property(nonatomic,assign)BOOL isSearchCompany;


/**
 搜索关键词view
 */
@property(nonatomic,strong)UIView *keyView;

@property(nonatomic,strong)UILabel *keyLable;

@property(nonatomic,strong)UIView *kongView;


@end
