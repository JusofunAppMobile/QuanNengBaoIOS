//
//  NearCompanyCell.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2017/12/27.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearCompanyModel.h"
@interface NearCompanyCell : UITableViewCell



@property (nonatomic,strong) UILabel *nameLabel;//公司名
@property (nonatomic,strong) UILabel *addressLabel;//公司地址
@property (nonatomic,strong) UILabel *legalLabel;//行业

@property(nonatomic,strong)NearCompanyModel *companyModel;


@end
