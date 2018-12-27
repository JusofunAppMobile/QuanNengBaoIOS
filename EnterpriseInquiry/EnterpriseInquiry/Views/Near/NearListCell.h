//
//  NearListCell.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2018/1/2.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearCompanyModel.h"
@interface NearListCell : UITableViewCell


/**名字*/
@property(nonatomic,strong)UILabel *nameLabel;


/**状态*/
@property(nonatomic,strong)UILabel *statusLabel;


/**代表人*/
@property(nonatomic,strong)UILabel *peopleLabel;


/**注册资金*/
@property(nonatomic,strong)UILabel *moneyLabel;


/**距离*/
@property(nonatomic,strong)UILabel *distanceLabel;


/**地址*/
@property(nonatomic,strong)UILabel *areaLabel;

@property(nonatomic,strong)NearCompanyModel *companyModel;

@end
