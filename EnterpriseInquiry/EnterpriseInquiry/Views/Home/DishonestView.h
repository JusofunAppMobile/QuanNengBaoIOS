//
//  DishonestView.h
//  EnterpriseInquiry
//
//  Created by clj on 16/8/14.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DishonestyMonthModel.h"

@interface DishonestView : UIView
@property (nonatomic,strong) UIView *colorView;
@property (nonatomic,strong) UILabel *yearLabel;
@property (nonatomic,strong) UILabel *monthLabel;


- (instancetype)initWithFrame:(CGRect)frame andDishonestyMonthModel:(DishonestyMonthModel *)dishonestryModel;


-(void)setDishonestryMonthModel:(DishonestyMonthModel *)dishonestryModel;


@end
