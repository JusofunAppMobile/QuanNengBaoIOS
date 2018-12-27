//
//  HotCompanyCell.h
//  EnterpriseInquiry
//
//  Created by clj on 16/8/13.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyModel.h"

@interface HotCompanyCell : UITableViewCell

@property (nonatomic,strong) UILabel *companyLabel;//公司名
@property (nonatomic,strong) UILabel *detailLabel;//行业、地区、注册资金
@property (nonatomic,strong) UILabel *foucsCountLabel;//关注数

-(void)setCellDataWithModel:(CompanyModel *)companyModel;

@end
