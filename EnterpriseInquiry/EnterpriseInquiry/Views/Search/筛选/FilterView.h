//
//  FilterView.h
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/1/12.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterViewDelegate<NSObject>

- (void)didSelectFilterView:(NSArray *)selectArray;

@end

@interface FilterView : UIView

@property (nonatomic ,weak) id <FilterViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame isSX:(BOOL)isSX;

-(void)showChooseView;
-(void)hideChooseView;

@end

