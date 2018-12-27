//
//  ZhaoBiaoCell.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2018/1/10.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhaoBiaoCell : UITableViewCell


/** 名字 */
@property(nonatomic,strong)UILabel *nameLabel;


/** 地区 */
@property(nonatomic,strong)UILabel *areaLabel;


/**日期 */
@property(nonatomic,strong)UILabel *dateLabel;


/** 项目分类 */
@property(nonatomic,strong)UILabel *typeLabel;


@end
