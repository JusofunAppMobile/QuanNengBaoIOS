//
//  NewCompanyRadarCell.h
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/1/5.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CompanyRadarDelegate <NSObject>

- (void)companyRadarClick:(NSDictionary *)dic;
@end

@interface NewCompanyRadarCell : UITableViewCell

@property (nonatomic ,strong) NSArray *radarArray;
@property (nonatomic ,weak) id<CompanyRadarDelegate>delegate;
@end
