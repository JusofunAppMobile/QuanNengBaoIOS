//
//  TrademarkCell.h
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/9/6.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrademarkModel;

@interface TrademarkCell : UITableViewCell

- (void)loadCell:(TrademarkModel *)model;

@end
