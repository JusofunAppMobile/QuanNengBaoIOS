//
//  ChooseDataModel.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 16/8/15.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilterCellModel.h"
//#import "JKDBModel.h"
@interface ChooseDataModel : NSObject

@property(nonatomic,copy)NSString *type;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,strong)NSArray *filterItemList;

@property(nonatomic,copy)NSString *key;

@end


