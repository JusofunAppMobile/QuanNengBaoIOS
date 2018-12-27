//
//  JobCell.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/8.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>
// ====================  招聘 ================
@interface JobCell : UITableViewCell


/**
 名字
 */
@property(nonatomic,strong)UILabel *nameLabel;


/**
 时间
 */
@property(nonatomic,strong)UILabel *timeLabel;


/**
 薪资
 */
@property(nonatomic,strong)UILabel *moneyLabel;


/**
 地点
 */
@property(nonatomic,strong)UILabel *areaLabel;


/**
 经验
 */
@property(nonatomic,strong)UILabel *experienceLabel;


/**
 学历
 */
@property(nonatomic,strong)UILabel *educationLabel;


@end
