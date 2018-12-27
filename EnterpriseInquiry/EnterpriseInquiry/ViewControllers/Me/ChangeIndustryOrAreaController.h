//
//  ChangeIndustryOrAreaController.h
//  JuXin
//
//  Created by huang on 15/4/13.
//  Copyright (c) 2015年 huang. All rights reserved.
//

/*
 !@ 修改行业或者地区界面
 */

#import "BasicViewController.h"

//#import "IndustryAndAreaManager.h"
#import "IndustryAndArea.h"


typedef NS_ENUM(NSInteger, QueryType) {
    QueryTypeIndustry   =   1,//行业
    QueryTypeArea       =   2,//地区
    QueryTypeJob        =   3//职位
};

@class ChangeIndustryOrAreaController;

@protocol ChangeIndustryOrAreaDelegate <NSObject>

@required
-(void)changeIndustryOrAreaCellSelected:(NSDictionary *)model andSaveDic:(NSMutableArray *)dic;

@end

@interface ChangeIndustryOrAreaController : BasicViewController

-(ChangeIndustryOrAreaController *)initWithQueryType:(QueryType)type;
-(ChangeIndustryOrAreaController *)initWithQueryType:(QueryType)type andIsChangeJob:(BOOL)isJob;

@property (nonatomic, weak) id<ChangeIndustryOrAreaDelegate> delegate;

@end
