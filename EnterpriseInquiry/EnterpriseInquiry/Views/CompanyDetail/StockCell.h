//
//  StockCell.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2017/12/28.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>
//============  股权出质 ============ 
@interface StockCell : UITableViewCell


/** 编号 */
@property(nonatomic,strong)UILabel *numLabel;

/** 出质人 */
@property(nonatomic,strong)UILabel *chuZhiLabel;

/** 质权人 */
@property(nonatomic,strong)UILabel *zhiQuanLabel;

@end
