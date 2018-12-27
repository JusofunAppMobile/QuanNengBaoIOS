//
//  NewHotCompanyCell.h
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/1/5.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CompanyModel;

@protocol NewHotCompanyCellDelegate<NSObject>

- (void)collectCompanyWithButton:(UIButton *)button model:(CompanyModel *)model;
@end

@interface NewHotCompanyCell : UITableViewCell

@property (nonatomic ,strong) CompanyModel              *model;
@property (nonatomic ,strong) UIButton                  *collectBtn;
@property (nonatomic ,strong) UIView                    *lineView;
@property (nonatomic ,weak  ) id <NewHotCompanyCellDelegate> delegate;

@end
