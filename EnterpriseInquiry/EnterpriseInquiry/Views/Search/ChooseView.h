//
//  ChooseView.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 16/8/15.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JMRoundedCorner/UIView+RoundedCorner.h>
#import "ChooseDataModel.h"
#import "RequestManager.h"
#import "User.h"
#import "FilterCellModel.h"
@class ChooseButton;

@protocol ChooseDelegate <NSObject>

-(void)chooseBack:(NSMutableArray *)chooseArray;




@end

@interface ChooseView : UIView

@property(nonatomic,assign) id<ChooseDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame isSX:(BOOL)isSX;

//展示页面
-(void)showChooseView;

//隐藏页面
-(void)hideChooseView;

-(void)requestData;

@end


@interface ChooseButton : UIButton


//@property(nonatomic,strong)NSDictionary*buttonDic;
@property (nonatomic ,strong) FilterCellModel *model;

//1城市 2省份 3所在行业 4 注册资金 5 成立年限
//父的type
@property(nonatomic,copy)NSString *type;

//父的name
@property(nonatomic,copy)NSString *name;

@property(nonatomic,assign)BOOL isSpecial;

@property(nonatomic,copy)NSString *key;



@end
