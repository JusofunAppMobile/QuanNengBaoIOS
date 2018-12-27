//
//  HotInformationCell.h
//  EnterpriseInquiry
//
//  Created by 方首滔 on 16/9/22.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"



@interface HotInformationCell : UITableViewCell
@property (nonatomic,strong)NewsModel *newsModel;
@property(nonatomic,strong)UIImageView *InformationImg;//热门资讯配图
@property(nonatomic,strong)UILabel *InfomationLabel;//热门资讯标题
@property(nonatomic,strong)UILabel *InfomationreadNum;//热门资讯阅读量






@end
