//
//  PenaltyCell.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2017/12/28.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>
//============  行政处罚 ============ 
@interface PenaltyCell : UITableViewCell

/** 决定文书号 */
@property(nonatomic,strong)UILabel *numLabel;

/** 违法类型 */
@property(nonatomic,strong)UILabel *typeLabel;

/**日期 */
@property(nonatomic,strong)UILabel *dateLabel;

@end
