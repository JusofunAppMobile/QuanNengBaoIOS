//
//  ReportCell.h
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/10/16.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReportModel;

@protocol ReportCellDelegate <NSObject>

- (void)sendReportAction:(ReportModel *)model;

@end

@interface ReportCell : UITableViewCell

@property (nonatomic ,strong) ReportModel *model;

@property (nonatomic ,weak) id <ReportCellDelegate>delegate;

@end
