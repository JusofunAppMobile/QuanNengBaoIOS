//
//  DownTaskView.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/8/2.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DownTaskModel.h"

@interface DownTaskView : UIView




@property(nonatomic,strong)UILabel *udidLabel;

@property(nonatomic,strong)UILabel *taskLabel;

@property(nonatomic,strong)UILabel *urlLabel;

@property(nonatomic,strong)UILabel *statusLabel;

@property(nonatomic,strong)UILabel *resultLabel;


@property(nonatomic,strong)UILabel *nextLabel;


-(void)reloadTaskViewWithTaskModel:(DownTaskModel*)model;



@end
