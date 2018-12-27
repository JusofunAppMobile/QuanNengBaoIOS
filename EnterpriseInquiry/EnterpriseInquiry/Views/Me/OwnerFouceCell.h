//
//  OwnerFouceCell.h
//  EnterpriseInquiry
//
//  Created by LEZ on 16/8/13.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OwnerFouceCell : UITableViewCell

@property (nonatomic,strong)UILabel     *companyNameLabel;

@property (nonatomic,strong)UILabel     *legalPersonLabel;

@property (nonatomic,strong)UILabel     *companyStateLabel;


@property (nonatomic,strong)NSDictionary *infoDict;
@end
