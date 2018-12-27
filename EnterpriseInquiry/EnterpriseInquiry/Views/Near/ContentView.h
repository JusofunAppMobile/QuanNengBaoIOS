//
//  ContentView.h
//  jusfounData
//
//  Created by jusfoun on 16/3/2.
//  Copyright © 2016年 jusfoun. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol contentViewDelegate <NSObject>

-(void)checkDetail;

-(void)collectCompany:(BOOL)isCollect;

-(void)goAdress;
-(void)goTop;

@end

@interface ContentView : UIView

@property(nonatomic,assign) id <contentViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame withCompanyDic:(NSDictionary *)companyDic;

-(void)changeCollect:(BOOL)isCollect;


-(void)changeInfoBackView:(BOOL)showBack;


/**
 到查看企业详情按钮的高度
 */
@property(nonatomic,assign)float detailBtnHight;

@end
