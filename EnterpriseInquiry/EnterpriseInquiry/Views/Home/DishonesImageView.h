//
//  DishonesImageView.h
//  EnterpriseInquiry
//
//  Created by clj on 16/8/14.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DishonestyMonthModel.h"
@interface DishonesImageView : UIImageView
- (instancetype)initWithFrame:(CGRect)frame andDishonestyMonthModel:(DishonestyMonthModel *)dishonestryModel;
@end
