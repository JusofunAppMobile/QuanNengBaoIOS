//
//  FilterSectionHeader.h
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/1/12.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseDataModel.h"

@protocol FilterSectionHeaderDelegate<NSObject>
- (void)filterHeaderOpen:(BOOL)open type:(NSString *)type;//type 1城市  2省

@end

@interface FilterSectionHeader : UICollectionReusableView

@property (nonatomic ,strong) ChooseDataModel *model;
@property (nonatomic ,weak) id <FilterSectionHeaderDelegate> delegate;
@property (nonatomic ,strong) UIButton *openBtn;

@end
