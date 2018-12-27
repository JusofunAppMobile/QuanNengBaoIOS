//
//  PatentCell.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/7.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>
// ====================  专利信息 ================
@interface PatentCell : UITableViewCell


/**
 名字
 */
@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *timeLabel;


/**
 分类
 */
@property(nonatomic,strong)UILabel *classifyLabel;

@end
