//
//  DetailView.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/4.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailInfoCell.h"
#import "DetailGridCell.h"
#import "CompanyDetailModel.h"
#import "ItemModel.h"

//搜索的类型
typedef NS_ENUM(NSInteger, Headerype) {
    HeaderRiskType = 5638, //风险信息
    HeaderManageType  ,//经营状况
    HeaderMoneyType //无形资产
    
};


@protocol DetailViewDelegate <NSObject>

-(void)callCompany:(NSString*)phoneStr;

-(void)companyAdress;

-(void)refreshCompany;

-(void)CompanyUrl:(NSString*)urlStr;

-(void)gridButtonClick:(ItemModel*)model cellSection:(int)section;

-(void)headerClick:(Headerype)type;

-(void)checkReport;

@end



@interface DetailView : UIView<UITableViewDelegate,UITableViewDataSource,DetailGridDelegate>

@property(nonatomic,assign)id<DetailViewDelegate>delegate;

@property(nonatomic,strong)UITableView *backTableView;

@property(nonatomic,strong)CompanyDetailModel *detailModel;


-(void)reloadViewWithType:(Headerype)type gridArray:(NSArray*)array animate:(BOOL)animate;

-(void)beginRefreshAnimation;

-(void)stopRefreshAnimation;


@end
