//
//  ChooseDataModel.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 16/8/15.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "ChooseDataModel.h"

@implementation ChooseDataModel
+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"filterItemList":FilterCellModel.class};
}
@end
