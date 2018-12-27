//
//  SearchResultController.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/15.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "BasicViewController.h"
#import "BasicViewController.h"
#import "ChooseView.h"
#import "SearchLoseCreitARRModel.h"
#import "LoseCreditCell.h"
#import <UIView+RoundedCorner.h>
#import "ProblemViewController.h"
#import "SearchAllWebView.h"
#define LoseCreditBtnTag 54644

typedef NS_ENUM(NSInteger, SortType) {
    HotSortType = 2,//关注热度
    
    MoneyUpSortType = 3 ,//注册资金升序
    MoneyDownSortType = 4,//注册资金 降序
    
    TimeUpSortType = 5,//注册时间 升序
    TimeDownSortType = 6,//注册时间 降序
    
};//排序类型


typedef NS_ENUM(NSInteger, MoneyButtonState) {
    MoneyNormalState = 546577,//普通状态
    MoneyUpState ,//向上
    MoneyDownState,//向下
};//注册资金的状态

typedef NS_ENUM(NSInteger, TimeButtonState) {
    TimeNormalState = 6556477,//普通状态
    TimeUpState ,//向上
    TimeDownState,//向下
};//注册时间的状态


typedef NS_ENUM(NSInteger, LoseCreditType) {
    LoseAllType = 1,//全部
    LosePepleType ,//失信人
    LoseCompanyType,//失信企业
};//失信类型


typedef NS_ENUM(NSInteger, PopType) {
    PopNormal = 1,//返回上一级
    PopTop ,//返回顶层
    PopThird,//返回第三层
};//返回类型



@protocol SearchBackDelegate <NSObject>

/**
 *  返回界面
 *
 *  @param isClear 是否清空搜索的热词界面
 */
-(void)searchBackWithClear:(BOOL)isClear;

@end


@class ChooseButton;
@interface SearchResultController : BasicViewController
@property(nonatomic,strong)NSString *btnTitile;
@property (nonatomic,assign)SearchType searchType;


/**
 是否是从没数据进入的,是的话一级一级返回
 */
@property(nonatomic,assign)BOOL isFromNoData;

@property(nonatomic,weak)id<SearchBackDelegate>delegate;






/**
 返回类型
 */
@property(nonatomic,assign)PopType popType;

@end
