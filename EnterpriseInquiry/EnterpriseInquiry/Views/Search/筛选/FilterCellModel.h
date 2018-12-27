//
//  FilterCellModel.h
//  EnterpriseInquiry
//
//  Created by wzh on 2018/1/14.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterCellModel : NSObject

@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *value;
@property (nonatomic ,assign) BOOL selected;//是否被选中
@property (nonatomic ,copy) NSString *type;//1城市 2省份  3行业 4注册资金 5年限 6网址
@property (nonatomic ,copy) NSString *key;

@end
